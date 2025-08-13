import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import '../interview_module.dart';

class InterviewListDetailScreen extends GetView<InterviewListDetailController> {
  const InterviewListDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: GestureDetector(
        onTap: () => controller.unFocus(context),
        child: Scaffold(
          appBar: AppBarHeader(
            title:
                controller.currentMaTinhTrangDT == '${AppDefine.chuaPhongVan}'
                    ? 'un_interviewed_title'.tr
                    : 'interviewed_title'.tr,

            onPressedLeading: () => {},
            iconLeading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            subTitle: (controller.currentMaDoiTuongDT ==
                        AppDefine.maDoiTuongDT_07Mau.toString() ||
                    controller.currentMaDoiTuongDT ==
                        AppDefine.maDoiTuongDT_07TB.toString())
                ? 'Địa bàn: ${controller.currentMaDiaBan}'
                : '',
            //  backAction: () => controller.backInterviewList(),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.sliverController,
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            expandedHeight: 80.0,
            flexibleSpace: _searchView(),
          ),
          SliverList(
            delegate: _listViewByCategories(),
          ),
        ],
      );
    });
  }

  Widget _searchView() {
    return FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetFieldInput(
              controller: controller.searchController,
              onChanged: controller.onSearch,
              hint: 'search'.tr,
              bgColor: Colors.white,
              prefix: IconButton(
                onPressed: null,
                icon: Image.asset(AppIcons.icSearch),
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverChildBuilderDelegate _listViewByCategories() {
     if (controller.currentMaTinhTrangDT == '${AppDefine.chuaPhongVan}') {
        return SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var bkCoSo = controller.danhSachBKCoSoSXXKD[index];
            String tenCs = '${bkCoSo.maXa} - ${bkCoSo.tenCoSo}';
            return WidgetSubject(
              index: '${index + 1}',
              onPressed: () => controller.startInterView(index),
              name: tenCs,
              questions: controller.currentTenDoiTuongDT,
            );
          },
          childCount: controller.danhSachBKCoSoSXXKD.length,
        );
      } else {
        return SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var bkCoSo = controller.danhSachBKCoSoSXXKD[index];
            String tenCs = '${bkCoSo.maXa} - ${bkCoSo.tenCoSo}';
            return WidgetSubject(
              index: '${index + 1}',
              onPressed: () => controller.startInterView(index),
              name: tenCs,
              questions: controller.currentTenDoiTuongDT,
            );
          },
          childCount: controller.danhSachBKCoSoSXXKD.length,
        );
      }
  }
}
