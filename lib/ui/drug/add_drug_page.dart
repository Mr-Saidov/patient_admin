import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/drug_model.dart';
import 'package:patient_admin/utils/constants.dart';

import '../../model/universal_model.dart';
import '../../utils/common_widgets.dart';
import '../base/components.dart';

class AddDrugPage extends StatefulWidget {
  AddDrugPage({Key? key, this.drugModel}) : super(key: key);
  DrugModel? drugModel;

  @override
  State<AddDrugPage> createState() => _AddDrugPageState();
}

class _AddDrugPageState extends State<AddDrugPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usingController = TextEditingController();
  TextEditingController countryOfManufactureController =
      TextEditingController();
  TextEditingController activeIngredientController = TextEditingController();
  TextEditingController numberOfPackagesController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  String? selectedDrugTypeId;
  String? selectedDrugTypeName;
  bool isSetFirstTime = false;

  @override
  Widget build(BuildContext context) {
    if (!isSetFirstTime) {
      selectedDrugTypeId = widget.drugModel?.drugTypeId;
      selectedDrugTypeName = widget.drugModel?.drugTypeName;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isSetFirstTime) return;
      if (widget.drugModel != null) {
        nameController.text = widget.drugModel!.name ?? "";
        usingController.text = widget.drugModel!.using ?? "";
        countryOfManufactureController.text = widget.drugModel!.country ?? "";
        activeIngredientController.text =
            widget.drugModel!.activeIngredient ?? "";
        numberOfPackagesController.text =
            widget.drugModel!.numberOfPackages ?? "";
        expireDateController.text = widget.drugModel!.expireDate ?? "";
        expireDateController.text = widget.drugModel!.expireDate ?? "";
      }
      isSetFirstTime = true;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangi dorini kiritish"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 24),
        children: [
          SizedBox(height: 8,),
          getTextField(
            "FIO",
            controller: nameController,
          ),
          getDivider(),
          getRegionDistricts(
              FirebaseFirestore.instance
                  .collection(drugType)
                  .orderBy('name', descending: true),
              "Dori turi",
              selectedDrugTypeId, (UniversalModel m) {
            selectedDrugTypeId = m.id;
            selectedDrugTypeName = m.name;
            setState(() {});
          }),
          getDivider(),
          getTextField(
            "Qo'llanilishi",
            controller: usingController,
          ),
          getDivider(),
          getTextField(
            "Ishlab chiqaruvchi davlat",
            controller: countryOfManufactureController,
          ),
          getDivider(),
          getTextField(
            "Faol modda",
            controller: activeIngredientController,
          ),
          getDivider(),
          getTextField(
            "Qadoqlar soni",
            controller: numberOfPackagesController,
          ),
          getDivider(),
          getTextField(
            "Yaroqlilik muddati",
            controller: expireDateController,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          final id = widget.drugModel?.id != null
              ? widget.drugModel?.id!
              : DateTime.now().millisecondsSinceEpoch.toString();
          var documentReference =
              FirebaseFirestore.instance.collection(drugs).doc(id);

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.set(
              documentReference,
              DrugModel(
                id: id,
                name: nameController.text,
                drugTypeId: selectedDrugTypeId,
                drugTypeName: selectedDrugTypeName,
                using: usingController.text,
                country: countryOfManufactureController.text,
                activeIngredient: activeIngredientController.text,
                numberOfPackages: numberOfPackagesController.text,
                expireDate: expireDateController.text,
              ).toJson(),
            );
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}
