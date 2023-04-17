import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/pharmacy_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

import '../../model/universal_model.dart';
import '../../utils/common_widgets.dart';

class AddHospitalPage extends StatefulWidget {
  const AddHospitalPage({Key? key, this.hospitalId, this.pharmacyModel})
      : super(key: key);
  final String? hospitalId;
  final PharmacyModel? pharmacyModel;

  @override
  State<AddHospitalPage> createState() => _AddHospitalPageState();
}

class _AddHospitalPageState extends State<AddHospitalPage> {
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
          title: const Text("Shifoxona qo'shish"),
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
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final id = widget.hospitalId != null
                  ? widget.hospitalId!
                  : DateTime.now().millisecondsSinceEpoch.toString();
              var documentReference =
                  FirebaseFirestore.instance.collection(hospitals).doc(id);

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

  getRegions() {
    final store = FirebaseFirestore.instance
        .collection(regions)
        .orderBy('name', descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: store,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Viloyatlar mavjud emas. Iltimos avval viloyatlarni kiriting",
                style: TextStyle(
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
              if (selectedRegionId == element.id) {
                selectedRegion = element;
              }
            }
            return TextButton(
              onPressed: () {
                showDataDialog(context, regions, true);
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(
                selectedRegion?.name == null
                    ? "Viloyatni tanlang"
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

  getDistrict() {
    if (selectedRegionId == null) return const SizedBox();
    final store = FirebaseFirestore.instance
        .collection(regions)
        .doc(selectedRegionId)
        .collection(selectedRegionId!)
        .orderBy('name', descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: store,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Tumanlar mavjud emas. Iltimos avval tumanlarni kiriting",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          } else {
            final data = <UniversalModel>[];
            UniversalModel? selectedData;
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final element = UniversalModel.fromJson(snapshot.data!.docs[i]);
              data.add(element);
              if (selectedDistrictId == element.id) {
                selectedData = element;
              }
            }
            return TextButton(
              onPressed: () {
                showDataDialog(context, data, false);
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(
                selectedData?.name == null
                    ? "Tumanni tanlang"
                    : selectedData!.name!,
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

  showDataDialog(BuildContext context, List<UniversalModel> data, isRegion) {
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
                    "${isRegion ? "Viloayat" : "Tuman"}ni tanlang",
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
                            if (isRegion) {
                              selectedRegionId = data[index].id;
                            } else {
                              selectedDistrictId = data[index].id;
                            }
                            Navigator.pop(context);
                            setState(() {});
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
