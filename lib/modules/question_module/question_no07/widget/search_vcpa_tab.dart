import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';

class SearchVcpaTab extends StatefulWidget {
  const SearchVcpaTab(
      {super.key,
      this.headerTab,
      this.aiTab,
      this.dmTab,
      required this.onTabPress});

  final Widget? headerTab;
  final Widget? aiTab;
  final Widget? dmTab;
  final Function(int?) onTabPress;

  @override
  State<SearchVcpaTab> createState() => _SearchVcpaTabState();
}

class _SearchVcpaTabState extends State<SearchVcpaTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedIndex;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(),
            AnimatedBuilder(
                animation: _tabController,
                builder: (context, snapshot) {
                  return TabBar(
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onTabPress(index);
                    },
                    unselectedLabelColor: blackText,
                    labelColor: primaryColor,
                    indicatorColor: primaryColor,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<int>(
                              activeColor: primaryColor,
                              value: 0,
                              groupValue: _tabController.index,
                              onChanged: (int? value) {
                                _tabController.animateTo(0);
                                setState(() {
                                  _selectedIndex = 0;
                                });
                                widget.onTabPress(0);
                              },
                            ),
                            const Text('AI'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<int>(
                              activeColor: primaryColor,
                              value: 1,
                              groupValue: _tabController.index,
                              onChanged: (int? value) {
                                _tabController.animateTo(1);
                                setState(() {
                                  _selectedIndex = 1;
                                });
                                widget.onTabPress(1);
                              },
                            ),
                            const Text('Danh mục'),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  widget.aiTab!,
                  widget.dmTab!,
                ],
              ),
            ),
          ],
        ));
  }

  void onTabPress(int? idx) {
    debugPrint('Tab Press me');
    widget.onTabPress(idx);
  }
}
