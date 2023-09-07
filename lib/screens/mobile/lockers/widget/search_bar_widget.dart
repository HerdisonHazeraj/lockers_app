import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/screens/mobile/lockers/widget/locker_details_mobile.dart';
import 'package:lockers_app/screens/mobile/students/widget/student_details_screen.dart';
import 'package:provider/provider.dart';

import '../../../../models/locker.dart';
import '../../../../providers/lockers_student_provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key, this.isLockerPage, this.refreshSearchBar});

  final Function()? refreshSearchBar;

  final bool? isLockerPage;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<Locker> searchedListLockers = [];
  List<Student> searchedListStudents = [];

  FocusNode searchFocusNode = FocusNode();

  SearchController controller = SearchController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SearchAnchor(
        viewLeading: IconButton(
            onPressed: () {
              widget.refreshSearchBar!();

              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(context);
              searchFocusNode.unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        // suggestions: searchedListLockers,
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          if (widget.isLockerPage!) {
            searchedListLockers =
                Provider.of<LockerStudentProvider>(context, listen: false)
                    .searchLockers(controller.text);
            return List<ListTile>.from(searchedListLockers.map((item) {
              return ListTile(
                title: Text(item.lockerNumber.toString()),
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            LockerDetailsScreenMobile(
                          locker: item,
                        ),
                      ),
                    );
                  });
                },
              );
            }));
          } else {
            searchedListStudents =
                Provider.of<LockerStudentProvider>(context, listen: false)
                    .searchStudents(controller.text);
            return List<ListTile>.from(searchedListStudents.map((item) {
              return ListTile(
                title: Text("${item.firstName} ${item.lastName}"),
                onTap: () {
                  setState(() {
                    // controller.closeView(item);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            StudentDetailsScreenMobile(
                          student: item,
                        ),
                      ),
                    );
                  });
                },
              );
            }));
          }
        },

        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
              focusNode: searchFocusNode,
              // hintText: widget.isLockerPage!
              //     ? "Rechercher un Casier..."
              //     : "Rechercher un élève...",
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Color(0xffF4F6F7)),
              elevation: MaterialStateProperty.all(0),
              controller: controller,
              onChanged: (value) {},
              onTap: () {
                controller.openView();
              },
              leading: const Icon(Icons.search));
        },
      ),
    );
  }
}
