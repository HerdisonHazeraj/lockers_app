import 'package:flutter/material.dart';
import 'package:lockers_app/screens/assignation/menu_widgets/dropdown_item_widget.dart';

// ignore: must_be_immutable
class SortElementWidget extends StatefulWidget {
  SortElementWidget(
      {super.key,
      required this.sortList,
      required this.orderList,
      required this.orderController,
      required this.sortController,
      required this.changeLockerListStateVoid,
      required this.isOrderCheckChecked});

  Map<String, String> sortList;
  Map<String, String> orderList;
  TextEditingController orderController;
  TextEditingController sortController;

  bool isOrderCheckChecked;
  final Function(TextEditingController sortController, bool isOrderCheckChecked)
      changeLockerListStateVoid;

  @override
  State<SortElementWidget> createState() => _SortElementWidgetState();
}

class _SortElementWidgetState extends State<SortElementWidget> {
  // bool isOrderCheckChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: DropDownItemWidget(
                list: widget.sortList,
                controller: widget.sortController,
                hintText: "Trier par...",
              ),
            ),
            Row(
              children: [
                Checkbox(
                    value: widget.isOrderCheckChecked,
                    onChanged: (newValue) {
                      setState(() {
                        widget.isOrderCheckChecked = newValue!;
                      });
                    }),
                const Text('Croissant')
              ],
            ),
            // DropDownItemWidget(
            //   list: widget.orderList,
            //   controller: widget.orderController,
            //   hintText: "Ordre...",
            // ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
          child: ElevatedButton(
              onPressed: () {
                widget.changeLockerListStateVoid(
                    widget.sortController, widget.isOrderCheckChecked);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black54),
              ),
              child: const Text('Trier')),
        )
      ],
    );
  }
}
