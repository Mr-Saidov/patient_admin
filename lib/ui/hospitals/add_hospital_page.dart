import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/pharmacy_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  ).toJson(),
                );
              });
              Navigator.pop(context);
            },
            child: const Icon(Icons.done)));
  }
}
