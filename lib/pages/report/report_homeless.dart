import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/pages/report/form.dart';
import 'package:jood/pages/report/state.dart';
import 'package:jood/report_button.dart';

class ReportHomeless extends HookWidget {
  static String routeName = "/report_homeless";

  @override
  Widget build(BuildContext context) {
    useProvider(formStateProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('Report homeless'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'better well being for the candidate depending on data you provides us.',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                SizedBox(height: 20),
                ReportForm(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ReportButton(
        onPressed: () => context.read(formStateProvider).submit(() {
          Navigator.pop(context);
        }),
      ),
    );
  }
}
