import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  SearchController controller = SearchController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SearchBar(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Color(0xffF4F6F7)),
        elevation: MaterialStateProperty.all(0),
        controller: controller,
        onChanged: (value) {
          // Provider.of<LockerStudentProvider>(context, listen: false)
        },
        onTap: () {},
        leading: const Icon(Icons.search),
      ),
    );
  }
}
