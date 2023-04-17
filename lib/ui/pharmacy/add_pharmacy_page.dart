import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/pharmacy_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

import '../../model/universal_model.dart';

class AddPharmacyPage extends StatefulWidget {
  const AddPharmacyPage({Key? key, this.pharmacyId, this.pharmacyModel})
      : super(key: key);
  final String? pharmacyId;
  final PharmacyModel? pharmacyModel;

  @override
  State<AddPharmacyPage> createState() => _AddPharmacyPageState();
}

class _AddPharmacyPageState extends State<AddPharmacyPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController timeTableController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  bool s = false;
  String? selectedRegionId;
  String? selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    if (!s) {
      selectedRegionId = widget.pharmacyModel?.regionId;
      selectedDistrictId = widget.pharmacyModel?.districtId;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (s) return;
      if (widget.pharmacyModel != null) {
        log("widget.pharmacyModel?.districtId ${widget.pharmacyModel?.districtId}");
        nameController.text = widget.pharmacyModel!.name ?? "";
        addressController.text = widget.pharmacyModel!.address ?? "";
        aboutController.text = widget.pharmacyModel!.about ?? "";
        timeTableController.text = widget.pharmacyModel!.timeTable ?? "";
        phoneController.text = widget.pharmacyModel!.phone ?? "";
        latController.text = widget.pharmacyModel!.lat ?? "";
        longController.text = widget.pharmacyModel!.long ?? "";
      }
      s = true;
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dorixona qo'shish"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getTextField(
                "Nomi",
                controller: nameController,
              ),
              getDivider(),
              getTextField(
                "Manzili",
                controller: addressController,
              ),
              getDivider(),
              getTextField(
                "Tavsif",
                controller: aboutController,
              ),
              getDivider(),
              getTextField(
                "Ish vaqti",
                controller: timeTableController,
              ),
              getDivider(),
              getTextField(
                "Telefon raqami",
                controller: phoneController,
              ),
              getDivider(),
              getRegionDistricts(
                  FirebaseFirestore.instance
                      .collection(regions)
                      .orderBy('name', descending: true),
                  "Viloyat",
                  selectedRegionId, (id) {
                if (selectedRegionId != id) selectedDistrictId = null;
                selectedRegionId = id;
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
                    selectedDistrictId, (id) {
                  selectedDistrictId = id;
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
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final id = widget.pharmacyId != null
                  ? widget.pharmacyId!
                  : DateTime.now().millisecondsSinceEpoch.toString();
              var documentReference =
                  FirebaseFirestore.instance.collection(pharmacy).doc(id);

              await FirebaseFirestore.instance
                  .runTransaction((transaction) async {
                transaction.set(
                  documentReference,
                  PharmacyModel(
                    id: id,
                    name: nameController.text,
                    address: addressController.text,
                    about: aboutController.text,
                    timeTable: timeTableController.text,
                    phone: phoneController.text,
                    lat: latController.text,
                    long: longController.text,
                    regionId: selectedRegionId ?? "",
                    districtId: selectedDistrictId ?? "",
                  ).toJson(),
                );
              });
              Navigator.pop(context);
            },
            child: const Icon(Icons.done)));
  }

  getRegionDistricts(
      Query collection, String title, String? selectedData, Function onSelect) {
    final store = collection.snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: store,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "${title}lar mavjud emas. Iltimos avval ${title}larni kiriting",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          } else {
            final regions = <UniversalModel>[];
            UniversalModel? selectedRegion;
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final element = UniversalModel.fromJson(snapshot.data!.docs[i]);
              regions.add(element);
              if (selectedData == element.id) {
                selectedRegion = element;
              }
            }
            return TextButton(
              onPressed: () {
                showDataDialog(context, regions, title, onSelect);
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(
                selectedRegion?.name == null
                    ? "${title}ni tanlang"
                    : selectedRegion!.name!,
              ),
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

  showDataDialog(BuildContext context, List<UniversalModel> data, String title,
      Function onSelect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Center(
                  child: Text(
                    "${title}ni tanlang",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: data.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        var item = data[index];
                        return ListTile(
                          title: Text(item.name ?? ""),
                          onTap: () {
                            onSelect.call(data[index].id);
                            // if (isRegion) {
                            //   selectedRegionId = data[index].id;
                            // } else {
                            //   selectedDistrictId = data[index].id;
                            // }
                            Navigator.pop(context);
                            // setState(() {});
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
