import 'package:flutter/material.dart';
import 'package:lockers_app/screens/desktop/assignation/menu_widgets/dropdown_item_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: DropDownItemWidget(
                list: widget.sortList,
                controller: widget.sortController,
                hintText: "Veuillez choisir...",
              ),
            ),
            const SizedBox(
              width: 40,
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
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.changeLockerListStateVoid(
                  widget.sortController, widget.isOrderCheckChecked);
            },
            // style: Theme.of(context).elevatedButtonTheme.style,
            child: const Text(
              'Appliquer',
            ),
          ),
        )
      ],
    );
  }
}
