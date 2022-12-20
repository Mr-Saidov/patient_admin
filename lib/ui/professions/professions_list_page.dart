import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/professions/add_profession_page.dart';
import 'package:patient_admin/utils/constants.dart';

class ProfessionListPage extends StatelessWidget {
  const ProfessionListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mutaxassisliklar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(professions)
            .orderBy('name', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Mutaxassisliklar mavjud emas",
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
                  final element = UniversalModel.fromJson(itemData);
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text("${element.name}")),
                        IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AddProfessionsPage(
                                    professionsId: itemData.id,
                                    regionModel: element,
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
                                .collection(professions)
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
                builder: (context) => AddProfessionsPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
