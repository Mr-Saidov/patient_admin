import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

class AddDrugTypePage extends StatefulWidget {
  const AddDrugTypePage({Key? key, this.drugTypeId, this.universalModel})
      : super(key: key);
  final String? drugTypeId;
  final UniversalModel? universalModel;

  @override
  State<AddDrugTypePage> createState() => _AddDrugTypePageState();
}

class _AddDrugTypePageState extends State<AddDrugTypePage> {
  String? name;
  TextEditingController controller = TextEditingController();
  bool s = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (s) return;
      if (widget.universalModel != null) {
        controller.text = widget.universalModel!.name ?? "";
        name = controller.text;
        setState(() {});
      }
      s = true;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dori turini qo'shish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            getTextField("Dori turi nomini kiriting", onTextChanged: (s) {
          name = s;
          setState(() {});
        }, controller: controller),
      ),
      floatingActionButton: name?.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () async {
                final id = widget.drugTypeId != null
                    ? widget.drugTypeId!
                    : DateTime.now().millisecondsSinceEpoch.toString();
                var documentReference =
                    FirebaseFirestore.instance.collection(drugType).doc(id);

                await FirebaseFirestore.instance
                    .runTransaction((transaction) async {
                  transaction.set(
                    documentReference,
                    UniversalModel(name: name, id: id).toJson(),
                  );
                });
                Navigator.pop(context);
              },
              child: const Icon(Icons.done))
          : null,
    );
  }
}
