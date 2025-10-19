import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/dialog_search_service.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_controller.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';

class DialogSearchVcpaTab extends StatefulWidget {
  const DialogSearchVcpaTab(
      {super.key,
      this.keyword,
      this.initialValue,
      this.onChangeListViewItem,
      this.productItem,
      this.searchType,
      this.capSo,
      this.maNganhCap5,
      this.moTaMaNganhCap5,
      this.isInitSearch});

  final String? keyword;
  final String? initialValue;
  final Function(TableDmMotaSanpham, dynamic, int)? onChangeListViewItem;
  final dynamic productItem;

  ///Để đảm bảo mã sản phẩm cấp 8 đang tìm kiếm thuộc phạm vi mã sản phẩm cấp 5 này.
  final String? maNganhCap5;
  final String? moTaMaNganhCap5;

  ///0: AI; 1: Danh muc
  final int? searchType;
  final int? capSo;
  final bool? isInitSearch;

  @override
  State<DialogSearchVcpaTab> createState() => _DialogSearchVcpaTabState();
}

class _DialogSearchVcpaTabState extends State<DialogSearchVcpaTab>
    with SingleTickerProviderStateMixin {
  final phieuTBController = Get.find<QuestionPhieuTBController>();
  late TabController _tabController;
  int? selectedIndex;

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
   
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      
      child: Container(
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tìm kiếm ngành sản phẩm',
                    style: styleMediumBold.copyWith(fontSize: 18),
                    maxLines: 2,
                  ),
                ),
                // const Spacer(),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: backgroundColor, // Default background color
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: Colors.grey, // Default border color
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            AnimatedBuilder(
                animation: _tabController,
                builder: (context, snapshot) {
                  return TabBar(
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      //widget.onTabPress(index);
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
                                  selectedIndex = 0;
                                });
                                // widget.onTabPress(0);
                              },
                            ),
                            // if ( phieuTBController.aISearchStatus.value != null &&  phieuTBController.aISearchStatus.value != '') ...[
                            //   Text('AI (${phieuTBController.aISearchStatus.value})'),
                            // ] else
                            Text('AI')
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
                                  selectedIndex = 1;
                                });
                                //  widget.onTabPress(1);
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
                  VcpaSearchService(
                      keywordText: widget.keyword,
                      initialValue: widget.initialValue,
                      onChangeListViewItem: widget.onChangeListViewItem,
                      productItem: widget.productItem,
                      searchType: 0,
                      capSo: widget.capSo,
                      maNganhCap5: widget.maNganhCap5,
                      moTaMaNganhCap5: widget.moTaMaNganhCap5),
                  VcpaSearchService(
                      keywordText: widget.keyword,
                      initialValue: widget.initialValue,
                      onChangeListViewItem: widget.onChangeListViewItem,
                      productItem: widget.productItem,
                      searchType: 1,
                      capSo: widget.capSo,
                      maNganhCap5: widget.maNganhCap5,
                      moTaMaNganhCap5: widget.moTaMaNganhCap5)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
