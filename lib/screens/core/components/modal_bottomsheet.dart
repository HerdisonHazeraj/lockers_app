import 'package:flutter/material.dart';

class ModalBottomSheetWidgetTest extends StatefulWidget {
  const ModalBottomSheetWidgetTest(
      {required this.title,
      required this.standardList,
      required this.importantList,
      super.key});
  final String title;
  final List<ListTile> standardList;
  final List<ListTile> importantList;

  @override
  State<ModalBottomSheetWidgetTest> createState() =>
      _ModalBottomSheetWidgetTestState();
}

class _ModalBottomSheetWidgetTestState
    extends State<ModalBottomSheetWidgetTest> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 34,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ...widget.standardList.map((e) {
                            return Column(
                              children: [
                                ListTile(
                                  title: e.title,
                                  trailing: e.trailing,
                                  onTap: e.onTap,
                                ),
                                if (widget.standardList.last != e)
                                  const Divider(),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ...widget.importantList.map(
                            (e) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: e.title,
                                    trailing: e.trailing,
                                    onTap: () {
                                      setState(() {
                                        e.onTap;
                                      });
                                    },
                                    iconColor: Colors.red,
                                    textColor: Colors.red,
                                  ),
                                  if (widget.importantList.last != e)
                                    const Divider(),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> ModalBottomSheetWidget(BuildContext context,
    List<ListTile> standardList, List<ListTile> importantList, String title) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    context: context,
    builder: (builder) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 34,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            ...standardList.map((e) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: e.title,
                                    trailing: e.trailing,
                                    onTap: () {},
                                  ),
                                  if (standardList.last != e) const Divider(),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            ...importantList.map(
                              (e) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: e.title,
                                      trailing: e.trailing,
                                      onTap: e.onTap,
                                      iconColor: Colors.red,
                                      textColor: Colors.red,
                                    ),
                                    if (importantList.last != e)
                                      const Divider(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
