import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

class ImportAllMenu extends StatefulWidget {
  ImportAllMenu({super.key});
  final List<Widget> items = [];

  @override
  State<ImportAllMenu> createState() => _ImportAllMenuState();
}

class _ImportAllMenuState extends State<ImportAllMenu> {
  // Controllers for the importing student form
  final fileController = TextEditingController();

  late FilePickerResult? pickedFile;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Importer un fichier CSV",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: fileController,
                decoration: InputDecoration(
                  labelText: "Choisir...",
                  prefixIcon: Icon(Icons.file_upload_outlined),
                ),
                readOnly: true,
                onTap: () async {
                  pickedFile = (await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv'],
                    allowMultiple: false,
                    withData: true,
                  ));

                  if (pickedFile != null) {
                    fileController.text = pickedFile!.files.single.name;
                  }

                  // pickedFile = (await FilePicker.platform.pickFiles(
                  //   type: FileType.custom,
                  //   allowedExtensions: ['xlsx'],
                  //   withData: true,
                  //   allowMultiple: false,
                  // ));

                  // if (pickedFile != null) {
                  //   fileController.text = pickedFile!.files.single.name;
                  // }
                },
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  //écrire la méthode
                  final error = await Provider.of<LockerStudentProvider>(
                    context,
                    listen: false,
                  ).importAllWithCSV(pickedFile!);
                  if (error != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)));
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Importation réussie"),
                      ),
                    );

                    fileController.clear();
                  }

                  // final message = await Provider.of<LockerStudentProvider>(
                  //   context,
                  //   listen: false,
                  // ).importAllWithXLSX(pickedFile!);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(message),
                  //   ),
                  // );
                },
                child: const Text("Importer"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
