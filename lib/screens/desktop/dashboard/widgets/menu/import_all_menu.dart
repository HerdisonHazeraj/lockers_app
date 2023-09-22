import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme.dart';

class ImportAllMenu extends StatefulWidget {
  ImportAllMenu({super.key});
  final List<Widget> items = [];

  @override
  State<ImportAllMenu> createState() => _ImportAllMenuState();
}

class _ImportAllMenuState extends State<ImportAllMenu> {
  // Controllers for the importing student form
  final fileController = TextEditingController();

  late FilePickerResult? filePicker;

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
                  filePicker = (await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv'],
                    withData: true,
                  ));

                  if (filePicker != null) {
                    fileController.text = filePicker!.files.single.name;
                  }
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
                  ).importAllWithCSV(filePicker!);
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
