import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screen_index.dart';

final GlobalKey<ScaffoldState> dashboardScaffoldKey =
    GlobalKey<ScaffoldState>();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentIndex = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _onDestinationSelected(int index) =>
      setState(() => currentIndex = index);

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {});
    // init();
  }

  Future<bool> onWillPop() async {
    if (currentIndex != 0) {
      _onDestinationSelected(0);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      onWillPop: onWillPop,
      child: Scaffold(
        key: dashboardScaffoldKey,
        drawer: const DashboardDrawer(),
        body: [
          const DashboardFragment(),
          const WalletFragment(),
          const AdvertisementFragment(),
          const ProfileFragment()
        ][currentIndex],
        bottomNavigationBar: DashBoardBottomNavBar(
          onDestinationSelected: _onDestinationSelected,
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}
