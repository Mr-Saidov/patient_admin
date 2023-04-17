import 'package:flutter/material.dart';
import 'package:patient_admin/ui/consultation_language/consultation_language_list_page.dart';
import 'package:patient_admin/ui/doctor/doctor_list_page.dart';
import 'package:patient_admin/ui/drug/drug_list_page.dart';
import 'package:patient_admin/ui/drug_types/drug_types_page.dart';
import 'package:patient_admin/ui/hospitals/hospitals_list_screen.dart';
import 'package:patient_admin/ui/pharmacy/pharmacy_list_screen.dart';
import 'package:patient_admin/ui/professions/professions_list_page.dart';
import 'package:patient_admin/ui/regions/regions_list_page.dart';
import 'package:patient_admin/ui/users/user_list_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor online adminstrator'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Viloyatlar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegionListPage(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Dorixonalar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PharmacyScreen(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Dori turlari"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DrugTypesPage(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Dorilar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DrugListPage(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Shifoxonalar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HospitalsListScreen(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Mutaxassisliklar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfessionListPage(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Maslahat tillari"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConsultationLanguageListPage(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Shifokorlar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorListPage(),
                  ));
            },
          ),
          getDivider(),
          ListTile(
            title: const Text("Foydalanuvchilar"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersPage(),
                  ));
            },
          ),
          getDivider(),
        ],
      ),
    );
  }

  Widget getDivider() {
    return const Divider(height: 1);
  }
}
