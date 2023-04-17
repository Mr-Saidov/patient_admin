import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/universal_model.dart';

getRegionDistricts(
    Query collection, String title, String? selectedData, Function onSelect) {
  final store = collection.snapshots();
  return StreamBuilder<QuerySnapshot>(
    stream: store,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "${title}lar mavjud emas. Iltimos avval ${title}larni kiriting",
              style: const TextStyle(
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
            if (selectedData == element.id) {
              selectedRegion = element;
            }
          }
          return TextButton(
            onPressed: () {
              showDataDialog(context, regions, title, onSelect);
            },
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: Text(
              selectedRegion?.name == null
                  ? "${title}ni tanlang"
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

showDataDialog(BuildContext context, List<UniversalModel> data, String title,
    Function onSelect) {
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
                  "${title}ni tanlang",
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
                          onSelect.call(data[index]);
                          // if (isRegion) {
                          //   selectedRegionId = data[index].id;
                          // } else {
                          //   selectedDistrictId = data[index].id;
                          // }
                          Navigator.pop(context);
                          // setState(() {});
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
