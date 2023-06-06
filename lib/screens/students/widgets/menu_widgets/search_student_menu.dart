import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

class SearchStudentMenu extends StatefulWidget {
  const SearchStudentMenu({super.key});

  @override
  State<SearchStudentMenu> createState() => _SearchStudentMenuState();
}

class _SearchStudentMenuState extends State<SearchStudentMenu> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Rechercher un élève",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: "Rechercher...",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              Provider.of<LockerStudentProvider>(context, listen: false)
                  .searchStudents(value);
            });
          },
        ),
      ],
    );
  }
}
