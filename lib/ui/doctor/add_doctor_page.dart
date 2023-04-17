import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/doctor_model.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

import '../../utils/common_widgets.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({Key? key, this.doctorId, this.doctorModel})
      : super(key: key);
  final String? doctorId;
  final DoctorModel? doctorModel;

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController birthYearController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController workHistoryController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController workTimeController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  bool isSetFirstTime = false;
  List<UniversalModel> allProfessionsList = [];
  List<String> currentProfessionsList = [];
  List<String> currentLanguagesList = [];
  List<UniversalModel> allLanguagesList = [];
  String? avatarPath;

  String? selectedRegionId;
  String? selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    if (!isSetFirstTime) {
      selectedRegionId = widget.doctorModel?.regionId;
      selectedDistrictId = widget.doctorModel?.districtId;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isSetFirstTime) return;
      if (widget.doctorModel != null) {
        avatarPath = widget.doctorModel?.avatar;
        nameController.text = widget.doctorModel!.fullname ?? "";
        emailController.text = widget.doctorModel!.email ?? "";
        passwordController.text = widget.doctorModel!.password ?? "";
        experienceController.text = widget.doctorModel!.experience ?? "";
        ratingController.text = widget.doctorModel!.rating ?? "";
        birthYearController.text = widget.doctorModel!.birthYear ?? "";
        educationController.text = widget.doctorModel!.education ?? "";
        workHistoryController.text = widget.doctorModel!.workHistory ?? "";
        bioController.text = widget.doctorModel!.bio ?? "";
        workTimeController.text = widget.doctorModel!.workTime ?? "";
        currentProfessionsList = widget.doctorModel!.profession ?? [];
        currentLanguagesList = widget.doctorModel!.language ?? [];
        latController.text = widget.doctorModel!.lat ?? "";
        longController.text = widget.doctorModel!.long ?? "";
      }
      isSetFirstTime = true;
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shifokor qo'shish"),
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 24),
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: InkWell(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.image,
                    );

                    if (result != null && result.files.first.bytes != null) {
                      Uint8List fileBytes = result.files.first.bytes!;
                      if (avatarPath?.isNotEmpty == true) {
                        await FirebaseStorage.instance
                            .ref(avatarPath!)
                            .delete();
                      }
                      avatarPath =
                          "${DateTime.now().millisecondsSinceEpoch}.jpg";
                      // Upload file
                      await FirebaseStorage.instance
                          .ref(avatarPath)
                          .putData(fileBytes);
                      setState(() {});
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Xatolik sodir bo'ldi"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Ok"))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: avatarPath != null
                        ? FutureBuilder(
                            future: FirebaseStorage.instance
                                .ref(avatarPath!)
                                .getDownloadURL(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                return Image(
                                  image: CachedNetworkImageProvider(
                                    snapshot.data!,
                                    imageRenderMethodForWeb:
                                        ImageRenderMethodForWeb.HttpGet,
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    "Rasmni yuklab olib bo'lmadi",
                                  ),
                                );
                              }
                            })
                        : const Center(child: Text("Rasm yuklang")),
                  ),
                ),
              ),
            ),
            getTextField(
              "FIO",
              controller: nameController,
            ),
            getDivider(),
            getTextField(
              "Elektron pochta",
              controller: emailController,
            ),
            getDivider(),
            getTextField(
              "Parol",
              controller: passwordController,
            ),
            getDivider(),
            getTextField(
              "Tajriba (Yil)",
              controller: experienceController,
            ),
            getDivider(),
            getTextField(
              "Reyting",
              controller: ratingController,
            ),
            getDivider(),
            getTextField(
              "Yoshi",
              controller: birthYearController,
            ),
            getDivider(),
            getTextField(
              "Ta'lim",
              controller: educationController,
            ),
            getDivider(),
            getTextField(
              "Ish joyi",
              controller: workHistoryController,
            ),
            getDivider(),
            getProfessions(),
            getDivider(),
            getLanguages(),
            getDivider(),
            getTextField(
              "Tavsif",
              controller: bioController,
            ),
            getDivider(),
            getTextField(
              "Ish vaqti",
              controller: workTimeController,
            ),
            getDivider(),
            getRegionDistricts(
                FirebaseFirestore.instance
                    .collection(regions)
                    .orderBy('name', descending: true),
                "Viloyat",
                selectedRegionId, (UniversalModel m) {
              if (selectedRegionId != m.id) selectedDistrictId = null;
              selectedRegionId = m.id;
              setState(() {});
            }),
            if (selectedRegionId != null) getDivider(),
            if (selectedRegionId != null)
              getRegionDistricts(
                  FirebaseFirestore.instance
                      .collection(regions)
                      .doc(selectedRegionId)
                      .collection(selectedRegionId!)
                      .orderBy('name', descending: true),
                  "Tuman",
                  selectedDistrictId, (UniversalModel m) {
                selectedDistrictId = m.id;
                setState(() {});
              }),
            getDivider(),
            const Text("Geo manzili :"),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: getTextField(
                    "Latitude",
                    controller: latController,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: getTextField(
                    "Longitude",
                    controller: longController,
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final id = widget.doctorId != null
                  ? widget.doctorId!
                  : DateTime.now().millisecondsSinceEpoch.toString();
              var documentReference =
                  FirebaseFirestore.instance.collection(doctors).doc(id);

              await FirebaseFirestore.instance
                  .runTransaction((transaction) async {
                transaction.set(
                  documentReference,
                  DoctorModel(
                    id: id,
                    fullname: nameController.text,
                    email: emailController.text,
                    avatar: avatarPath,
                    bio: bioController.text,
                    birthYear: birthYearController.text,
                    education: educationController.text,
                    experience: experienceController.text,
                    language: currentLanguagesList,
                    password: passwordController.text,
                    profession: currentProfessionsList,
                    rating: ratingController.text,
                    workHistory: workHistoryController.text,
                    workTime: workTimeController.text,
                    lat: latController.text,
                    long: longController.text,
                    role: "3",
                    regionId: selectedRegionId,
                    districtId: selectedDistrictId,
                  ).toJson(),
                );
              });
              Navigator.pop(context);
            },
            child: const Icon(Icons.done)));
  }

  getLanguages() {
    final store =
        FirebaseFirestore.instance.collection(consultationLanguage).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: store,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Maslahat tillari mavjud emas. Iltimos avval maslahat tillarini kiriting",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          } else {
            allLanguagesList.clear();
            var s = "";
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final element = UniversalModel.fromJson(snapshot.data!.docs[i]);
              if (currentLanguagesList.isNotEmpty == true) {
                for (var value in currentLanguagesList) {
                  if (element.id == value) {
                    element.isSelected = true;
                    s += "${element.name ?? ""} ";
                    break;
                  }
                }
              }
              allLanguagesList.add(element);
            }
            return TextButton(
              onPressed: () {
                showLanguagesDialog(context);
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(currentLanguagesList.isEmpty
                  ? "Maslahat tillarini tanlang"
                  : s),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }
      },
    );
  }

  getProfessions() {
    final store =
        FirebaseFirestore.instance.collection(professions).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: store,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Mutaxassisliklar mavjud emas. Iltimos avval mutaxassisliklar kiriting",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          } else {
            allProfessionsList.clear();
            var s = "";
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final element = UniversalModel.fromJson(snapshot.data!.docs[i]);
              if (currentProfessionsList.isNotEmpty == true) {
                for (var value in currentProfessionsList) {
                  if (element.id == value) {
                    element.isSelected = true;
                    s += "${element.name ?? ""} ";
                    break;
                  }
                }
              }
              allProfessionsList.add(element);
            }
            return TextButton(
              onPressed: () {
                showProfessionsDialog(context);
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(currentProfessionsList.isEmpty
                  ? "Mutaxassisliklarni tanlang"
                  : s),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }
      },
    );
  }

  showLanguagesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.height / 2,
            child: StatefulBuilder(
              builder: (
                BuildContext context,
                StateSetter stateSetter,
              ) {
                return Column(
                  children: [
                    const Center(
                        child: Text(
                      "Maslahat tillarini tanlang",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                    Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: allLanguagesList.length,
                          separatorBuilder: (context, index) {
                            if (allLanguagesList[index].isSelected) {
                              return Container();
                            } else {
                              return const Divider(height: 1);
                            }
                          },
                          itemBuilder: (context, index) {
                            var item = allLanguagesList[index];
                            return ListTile(
                              tileColor: item.isSelected
                                  ? Colors.blue.withAlpha(50)
                                  : null,
                              title: Text(item.name ?? ""),
                              onTap: () {
                                allLanguagesList[index].isSelected =
                                    !allLanguagesList[index].isSelected;
                                stateSetter(() {});
                              },
                            );
                          }),
                    ),
                    ElevatedButton(
                      child: const Text("Saqlash"),
                      onPressed: () {
                        currentLanguagesList.clear();
                        for (var element in allLanguagesList) {
                          if (element.isSelected) {
                            currentLanguagesList.add(element.id!);
                          }
                        }
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  showProfessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.height / 2,
            child: StatefulBuilder(
              builder: (
                BuildContext context,
                StateSetter stateSetter,
              ) {
                return Column(
                  children: [
                    const Center(
                        child: Text(
                      "Mutaxassisliklarni tanlang",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                    Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: allProfessionsList.length,
                          separatorBuilder: (context, index) {
                            if (allProfessionsList[index].isSelected) {
                              return Container();
                            } else {
                              return const Divider(height: 1);
                            }
                          },
                          itemBuilder: (context, index) {
                            var item = allProfessionsList[index];
                            return ListTile(
                              tileColor: item.isSelected
                                  ? Colors.blue.withAlpha(50)
                                  : null,
                              title: Text(item.name ?? ""),
                              onTap: () {
                                allProfessionsList[index].isSelected =
                                    !allProfessionsList[index].isSelected;
                                stateSetter(() {});
                              },
                            );
                          }),
                    ),
                    ElevatedButton(
                      child: const Text("Saqlash"),
                      onPressed: () {
                        currentProfessionsList.clear();
                        for (var element in allProfessionsList) {
                          if (element.isSelected) {
                            currentProfessionsList.add(element.id!);
                          }
                        }
                        print(
                            "currentProfessionsList ${currentProfessionsList.toString()}");
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
