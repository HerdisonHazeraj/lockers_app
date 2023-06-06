import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:provider/provider.dart';

import '../../../providers/lockers_student_provider.dart';

class StudentsMenu extends StatefulWidget {
  const StudentsMenu({super.key});

  @override
  State<StudentsMenu> createState() => _StudentsMenuState();
}

class _StudentsMenuState extends State<StudentsMenu> {
  List<Student> searchedStudents = [];

  String? dropdownSearchValue = "";

  // Controllers
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final mailController = TextEditingController();
  final jobController = TextEditingController();
  final loginController = TextEditingController();
  final yearController = TextEditingController();
  final classeController = TextEditingController();
  final responsableController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xffececf6),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: dropDown(
                            {
                              "lastName": "Nom",
                              "firstName": "Prénom",
                              "login": "Login",
                            },
                            Icons.search,
                            (value) {
                              setState(() {
                                dropdownSearchValue = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: "Rechercher",
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchedStudents =
                                    Provider.of<LockerStudentProvider>(context,
                                            listen: false)
                                        .searchStudents(
                                            dropdownSearchValue!, value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Ajouter un élève",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                addStudentForm(context),

                // Students list
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Liste des élèves",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    itemCount: searchedStudents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          "${searchedStudents[index].firstName} ${searchedStudents[index].lastName}",
                        ),
                        subtitle: Text(
                          searchedStudents[index].login,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column addStudentForm(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
                      labelText: "Prénom",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  TextField(
                    controller: loginController,
                    decoration: const InputDecoration(
                      labelText: "Login",
                      prefixIcon: Icon(Icons.login),
                    ),
                  ),
                  TextField(
                    controller: classeController,
                    decoration: const InputDecoration(
                      labelText: "Classe",
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                  TextField(
                    controller: jobController,
                    decoration: const InputDecoration(
                      labelText: "Formation",
                      prefixIcon: Icon(Icons.work),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: lastnameController,
                    decoration: const InputDecoration(
                      labelText: "Nom",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  TextField(
                    controller: mailController,
                    decoration: const InputDecoration(
                      labelText: "Mail",
                      prefixIcon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  dropDown(
                    {
                      "1": "1ère année",
                      "2": "2ème année",
                      "3": "3ème année",
                      "4": "4ème année",
                    },
                    Icons.calendar_today,
                    (value) {
                      setState(() {
                        yearController.text = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: responsableController,
                    decoration: const InputDecoration(
                      labelText: "Maître de classe",
                      prefixIcon: Icon(Icons.admin_panel_settings),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black54),
            ),
            onPressed: () {
              Student student = Student(
                firstName: firstnameController.text,
                lastName: lastnameController.text,
                job: jobController.text,
                responsable: responsableController.text,
                caution: 0,
                lockerNumber: 0,
                login: loginController.text,
                year: int.parse(yearController.text),
                classe: classeController.text,
              );

              Provider.of<LockerStudentProvider>(context, listen: false)
                  .addStudent(student);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'L\'élève "${student.firstName} ${student.lastName}" a été ajouté avec succès !'),
                  duration: const Duration(seconds: 3),
                ),
              );

              firstnameController.clear();
              lastnameController.clear();
              jobController.clear();
              responsableController.clear();
              loginController.clear();
              yearController.clear();
              classeController.clear();
              mailController.clear();
            },
            child: const Text("Ajouter"),
          ),
        ),
      ],
    );
  }

  DropdownButtonFormField<String> dropDown(
      Map<String, String> items, IconData icon, Function(String?) onChanged) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
      ),
      hint: const Text("Choisir..."),
      iconSize: 36,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black54,
      ),
      isExpanded: true,
      items: items.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
