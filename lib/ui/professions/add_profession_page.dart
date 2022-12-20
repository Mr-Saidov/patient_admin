import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/base/components.dart';
import 'package:patient_admin/utils/constants.dart';

class AddProfessionsPage extends StatefulWidget {
  const AddProfessionsPage({Key? key, this.professionsId, this.regionModel})
      : super(key: key);
  final String? professionsId;
  final UniversalModel? regionModel;

  @override
  State<AddProfessionsPage> createState() => _AddProfessionsPageState();
}

class _AddProfessionsPageState extends State<AddProfessionsPage> {
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
        title: const Text("Mutaxassislik qo'shish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            getTextField("Mutaxassislik nomini kiriting", onTextChanged: (s) {
          name = s;
          setState(() {});
        }, controller: controller),
      ),
      floatingActionButton: name?.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () async {
                final id = widget.professionsId != null
                    ? widget.professionsId!
                    : DateTime.now().millisecondsSinceEpoch.toString();
                var documentReference =
                    FirebaseFirestore.instance.collection(professions).doc(id);

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
