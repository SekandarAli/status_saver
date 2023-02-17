import 'package:flutter/cupertino.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ReusingWidgets.emptyData(context: context);
  }
}