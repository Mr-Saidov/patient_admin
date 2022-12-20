import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_admin/model/universal_model.dart';
import 'package:patient_admin/ui/regions/districts/add_district_page.dart';
import 'package:patient_admin/utils/constants.dart';

class DistrictListPage extends StatelessWidget {
  DistrictListPage(
      {Key? key, required this.regionId, required this.regionModel})
      : super(key: key);
  String regionId;
  UniversalModel regionModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${regionModel.name} viloyati"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(regions)
            .doc(regionId)
            .collection(regionId)
            .orderBy('name', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Tumanlar mavjud emas",
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
                                  return AddDistrictPage(
                                    regionId: regionId,
                                    regionModel: element,
                                    districtId: itemData.id,
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
                                .collection(regions)
                                .doc(regionId)
                                .collection(regionId)
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
                builder: (context) => AddDistrictPage(
                  regionId: regionId,
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
