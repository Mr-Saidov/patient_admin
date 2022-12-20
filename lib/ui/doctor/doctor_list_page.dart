import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/doctor_model.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/consultation_language/add_consultation_language_page.dart';
import 'package:patient_admin/ui/doctor/add_doctor_page.dart';
import 'package:patient_admin/ui/professions/add_profession_page.dart';
import 'package:patient_admin/utils/constants.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shifokorlar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(doctors)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print("BuildContext object ${snapshot.data?.docs.length}");
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Shifokorlar mavjud emas",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  final itemData = snapshot.data!.docs[index];
                  final element = DoctorModel.fromJson(itemData);
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text("${element.fullname}")),
                        IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AddDoctorPage(
                                    doctorId: itemData.id,
                                    doctorModel: element,
                                  );
                                },
                              ));
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection(doctors)
                                .doc(itemData.id)
                                .delete();
                          },
                        ),
                      ],
                    ),
                  );
                  // return buildItem(index, snapshot.data?.docs[index], context);
                },
                itemCount: snapshot.data!.docs.length,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDoctorPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
