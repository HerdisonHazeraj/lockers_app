import 'package:flutter/material.dart';
import 'package:lockers_app/infrastructure/firebase_rtdb_service.dart';

class PrepareDatabaseScreen extends StatefulWidget {
  const PrepareDatabaseScreen({super.key});

  @override
  State<PrepareDatabaseScreen> createState() => _PrepareDatabaseScreenState();
}

class _PrepareDatabaseScreenState extends State<PrepareDatabaseScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      await FirebaseRTDBService.instance.prepareDataBase();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const Center(child: Text("DataLoaded"));
  }
}
