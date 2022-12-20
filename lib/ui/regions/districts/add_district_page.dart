import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

class AddDistrictPage extends StatefulWidget {
  const AddDistrictPage(
      {Key? key, this.regionId, this.regionModel, this.districtId})
      : super(key: key);
  final String? regionId;
  final String? districtId;
  final UniversalModel? regionModel;

  @override
  State<AddDistrictPage> createState() => _AddDistrictPageState();
}

class _AddDistrictPageState extends State<AddDistrictPage> {
  String? name;
  TextEditingController controller = TextEditingController();
  bool s = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (s) return;
      if (widget.regionModel != null) {
        controller.text = widget.regionModel!.name ?? "";
        name = controller.text;
        setState(() {});
      }
      s = true;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tuman qo'shish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getTextField("Tuman nomini kiriting", onTextChanged: (s) {
          name = s;
          setState(() {});
        }, controller: controller),
      ),
      floatingActionButton: name?.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () async {
                final id = widget.districtId != null
                    ? widget.districtId!
                    : DateTime.now().millisecondsSinceEpoch.toString();
                var documentReference = FirebaseFirestore.instance
                    .collection(regions)
                    .doc(widget.regionId)
                    .collection(widget.regionId!)
                    .doc(id);

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
