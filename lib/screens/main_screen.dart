import 'package:cleanercms/util/responsive.dart';
import 'package:cleanercms/widgets/dashboard_widget.dart';
import 'package:cleanercms/widgets/side_menu_widget.dart';
import 'package:cleanercms/widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static void showSubmissionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post Submitted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      drawer: !isDesktop
          ? const SizedBox(
        width: 250,
        child: SideMenuWidget(),
      )
          : null,
      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: const SummaryWidget(),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              const Expanded(
                flex: 2,
                child: SideMenuWidget(),
              ),
            const Expanded(
              flex: 7,
              child: DashboardWidget(),
            ),
            if (isDesktop)
              const Expanded(
                flex: 3,
                child: SummaryWidget(),
              ),
          ],
        ),
      ),
    );
  }
}
