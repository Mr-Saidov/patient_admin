import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/pharmacy_model.dart';
import 'package:patient_admin/ui/pharmacy/add_pharmacy_page.dart';
import 'package:patient_admin/utils/constants.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dorixonalar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(pharmacy)
            .orderBy('name')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Dorixonalar mavjud emas",
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
                  final element = PharmacyModel.fromJson(itemData);
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text("${element.name}")),
                        IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AddPharmacyPage(
                                    pharmacyId: itemData.id,
                                    pharmacyModel: element,
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
                                .collection(pharmacy)
                                .doc(itemData.id)
                                .delete();
                          },
                        ),
                      ],
                    ),
                    onTap: () {},
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
          onPressed: () {},
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPharmacyPage(),
                  ));
            },
          )),
    );
  }
}
