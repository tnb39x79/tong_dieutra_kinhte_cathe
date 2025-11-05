import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/checkbox/animation_check.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_images.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/sync_module.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/widget/w_title_header.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_result.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api.dart';

class SyncScreenV2 extends GetView<SyncControllerV2> {
  const SyncScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
        loading: controller.loadingSubject,
        child: GestureDetector(
          child: Scaffold(
            key: controller.scaffoldKey,
            appBar: AppBar(
              title: const Text('Đồng bộ dữ liệu'),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Obx(() => buildBody()),
          ),
        ));
  }

  buildBody() {
    final isConnected = controller.networkService.isConnected;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      if (isConnected) {
        return controller.obx((state) {
          // If we got an error
          if (controller.danhSachBkCoSoSXKDInterviewed.isNotEmpty) {
            return Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsetsGeometry.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Danh sách cơ sở cần đồng bộ',
                                style: styleLargeBold,
                              )
                            ],
                          )),
                      buildResultMessageCommon(),
                      Expanded(
                          child: buildSyncList(
                              controller.danhSachBkCoSoSXKDInterviewed.value)),
                      buildButton(hasData: true)
                    ]));
          } else {
            return buildEmptyData(viewportConstraints);
          }
        },
            onEmpty: buildEmptyData(viewportConstraints),
            onLoading: CircularProgressIndicator());
      }
      return buildNetwork(viewportConstraints);
    });
  }

  buildResultMessageCommon() {
    if (controller.isSyncCompleted.value) {
      return Center(
          child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: true ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: const Image(
                          image: AssetImage(
                            AppImages.uploadSuccess,
                          ),
                          width: 48,
                        ),
                      );
                    },
                  ),
                  Text(
                    'Đồng bộ hoàn thành',
                    style: styleSmallBold.copyWith(color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    controller.responseMessage.value,
                    style: styleSmall.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              )));
    }
    return const SizedBox();
  }

  buildEmptyData(BoxConstraints viewportConstraints) {
    return SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(AppValues.padding),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight - kToolbarHeight + 30,
            ),
            child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage(
                            AppImages.uploadEmpty,
                          ),
                          width: 72,
                        ),
                        Text(
                          'Dữ liệu đồng bộ rỗng.',
                          style: styleSmall.copyWith(color: blackText),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),
                    buildButton()
                  ],
                ))));
  }

  buildNetwork(BoxConstraints viewportConstraints) {
    return SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(AppValues.padding),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight - kToolbarHeight + 30,
            ),
            child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Column(
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 64,
                          color: const Color(0xFF68696B),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Vui lòng kiểm tra kết nối mạng.',
                          style: styleSmall.copyWith(color: blackText),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),
                    buildButton()
                  ],
                ))));
  }

  // buildFuBody() {
  //   return FutureBuilder(
  //       // Future that needs to be resolved
  //       // inorder to display something on the Canvas
  //       future: controller.getData(),
  //       builder: (ctx, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           // If we got an error
  //           if (snapshot.hasError) {
  //             return SingleChildScrollView(
  //                 physics: const ScrollPhysics(),
  //                 padding: const EdgeInsets.all(AppValues.padding),
  //                 child: ConstrainedBox(
  //                     constraints: BoxConstraints(
  //                       minHeight:
  //                           ctx.mediaQuerySize.height - kToolbarHeight - 60,
  //                     ),
  //                     child: Obx(() => Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Center(
  //                                 child: Text(
  //                               '${snapshot.error} occurred',
  //                               style: TextStyle(fontSize: 18),
  //                             )),
  //                             buildButton()
  //                           ],
  //                         ))));

  //             // if we got our data
  //           } else if (snapshot.hasData) {
  //             // Extracting data from snapshot object
  //             //final data = controller.danhSachBkCoSoSXKDInterviewed;
  //             if (controller.danhSachBkCoSoSXKDInterviewed.isEmpty) {
  //               return SingleChildScrollView(
  //                   physics: const ScrollPhysics(),
  //                   padding: const EdgeInsets.all(AppValues.padding),
  //                   child: ConstrainedBox(
  //                       constraints: BoxConstraints(
  //                         minHeight:
  //                             ctx.mediaQuerySize.height - kToolbarHeight - 60,
  //                       ),
  //                       child: Obx(() => Column(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Center(
  //                                   child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   const Image(
  //                                     image: AssetImage(
  //                                       AppImages.uploadEmpty,
  //                                     ),
  //                                     width: 72,
  //                                   ),
  //                                   Text(
  //                                     'Dữ liệu đồng bộ rỗng.',
  //                                     style:
  //                                         styleSmall.copyWith(color: blackText),
  //                                     textAlign: TextAlign.center,
  //                                   )
  //                                 ],
  //                               )),
  //                               buildButton()
  //                             ],
  //                           ))));
  //             } else {
  //               return Obx(() => Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Padding(
  //                             padding: EdgeInsetsGeometry.all(16),
  //                             child: Row(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   'Danh sách cơ sở cần đồng bộ',
  //                                   style: styleLargeBold,
  //                                 )
  //                               ],
  //                             )),
  //                         Expanded(
  //                             child: buildSyncList(
  //                                 controller.danhSachBkCoSoSXKDInterviewed)),
  //                         buildButton()
  //                       ]));
  //             }
  //           }
  //         }
  //         return SingleChildScrollView(
  //             physics: const ScrollPhysics(),
  //             padding: const EdgeInsets.all(AppValues.padding),
  //             child: ConstrainedBox(
  //                 constraints: BoxConstraints(
  //                   minHeight: ctx.mediaQuerySize.height - kToolbarHeight - 60,
  //                 ),
  //                 child: Obx(() => Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Center(
  //                             child: Column(
  //                           children: [
  //                             // Displaying LoadingSpinner to indicate waiting state
  //                             CircularProgressIndicator(
  //                               color: primaryColor,
  //                               padding: EdgeInsets.only(bottom: 8),
  //                             ),
  //                             Text(
  //                               'Đang kiểm tra mạng...',
  //                               style: styleSmall.copyWith(color: blackText),
  //                               textAlign: TextAlign.center,
  //                             )
  //                           ],
  //                         )),
  //                         buildButton()
  //                       ],
  //                     ))));
  //       });
  // }

  Widget buildSyncList(List<TableBkCoSoSXKDSync> dataResult) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: dataResult.length,
      itemBuilder: (BuildContext context, int index) {
        var item = dataResult.elementAt(index);
        int idx = index + 1;

        String tenCoSo =
            'Địa bàn: ${item.maDiaBan} - Xã: ${item.maXa!} - ${item.tenCoSo!} (${item.loaiPhieu == 0 ? AppDefine.tenDoiTuongDT_07TB : item.loaiPhieu == 5 ? AppDefine.tenDoiTuongDT_07Mau : ''})';

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(child: buildItem(idx, item)),
          ],
        );
      },
    );
  }

  Widget buildItem(int idx, TableBkCoSoSXKDSync item) {
    String tenCoSo =
        '$idx. Địa bàn: ${item.maDiaBan} - Xã: ${item.maXa!} - ${item.tenCoSo!} (${item.loaiPhieu == 0 ? AppDefine.tenDoiTuongDT_07TB : item.loaiPhieu == 5 ? AppDefine.tenDoiTuongDT_07Mau : ''})';
    int? syncResultIsSuccess = 0;
    String syncResultMessage = '';
    if (item.syncResult != null) {
      syncResultIsSuccess = item.syncResult!.resCode ?? 0;
      syncResultMessage = item.syncResult!.resMessage ?? '';
    }
    Widget ic = Icon(Icons.circle_outlined, color: Colors.grey.shade100);
    String textResult = 'Chưa đồng bộ';
    String errorMessage = '';
    Color colorResult = warningColor;
    if (syncResultIsSuccess == 2) {
      //ic = Icon(Icons.check_circle_outlined, color: successColor);
      // ic = TweenAnimationBuilder<double>(
      //   tween: Tween<double>(begin: 0.0, end:  1.0),
      //   duration: const Duration(milliseconds: 300),
      //   builder: (context, opacity, child) {
      //     return Opacity(
      //       opacity: opacity,
      //       child:  Icon(Icons.check_circle_outlined, color: successColor),
      //     );
      //   },
      // );
      ic = AnimatedCheckmark(checkColor: successColor);
      textResult = 'Đồng bộ thành công';
      colorResult = successColor;
    } else if (syncResultIsSuccess == 3) {
      ic = Icon(Icons.error_outline_rounded, color: errorColor);
      textResult = 'Đồng bộ lỗi';
      errorMessage = syncResultMessage;
      colorResult = errorColor;
    } else if (syncResultIsSuccess == 1) {
      ic = CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: 2,
      );
      textResult = 'Đang đồng bộ...';
      colorResult = warningColor;
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(
        8,
        4,
        8,
        4,
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppValues.borderLv2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 4),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 24,
                  width: 24,
                  margin: EdgeInsets.only(right: 8),
                  child: ic),
              Expanded(
                  child: Text(
                tenCoSo,
                style: styleMedium.copyWith(fontWeight: FontWeight.w400),
              )),
            ],
          ),
          subtitle: syncResultIsSuccess == 3
              ? Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    trailing:
                        syncResultIsSuccess == 3 ? null : SizedBox.shrink(),
                    title: Text(
                      textResult,
                      style: TextStyle(color: colorResult),
                    ),
                    initiallyExpanded: false,
                    children: [
                      if (syncResultIsSuccess == 3)
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              key: ValueKey(item.iDCoSo),
                              '$errorMessage',
                              style: TextStyle(color: errorColor),
                            ))
                    ],
                  ))
              : Text(textResult, style: TextStyle(color: colorResult))
          // Column(
          //     crossAxisAlignment:
          //         CrossAxisAlignment.start, // Align children to the start
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //               child: Text(
          //             textResult,
          //             style: TextStyle(color: colorResult),
          //           )),
          //         ],
          //       ),
          //       Text(
          //         key: ValueKey(idx),
          //         'Sau nhiều nỗ lực ngoại giao không hiệu quả, ông Trump cuối cùng phải tung đòn trừng phạt Nga, nhằm thể hiện lập trường cứng rắn với Moskva trong vấn đề chiến sự Ukraine. Tổng thống Donald Trump ngày 22/10 thông báo Mỹ đã áp lệnh trừng phạt "nặng nề" với hai tập đoàn dầu mỏ Nga là Rosneft và Lukoil. Các lệnh trừng phạt bao gồm đóng băng tất cả tài sản của hai tập đoàn tại Mỹ, đồng thời cấm tất cả công ty Mỹ giao dịch với hai doanh nghiệp này.',
          //         style: TextStyle(color: errorColor),
          //       )
          //     ]),
          ),
    );
  }

  Widget buildButton({bool? hasData = false}) {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: 4),
          padding: EdgeInsets.fromLTRB(12, 8, 8, 16),
          child:
              WidgetButton(title: 'Trang chủ', onPressed: controller.backHome),
        )),
        if ((hasData != null && hasData == true) ||
            controller.isSyncCompleted.value)
          Expanded(
              child: Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.fromLTRB(8, 8, 12, 16),
            child: WidgetButton(
              iconCenter: Icon(
                size: 28,
                Icons.sync,
                color: Colors.white,
              ),
              title: 'Đồng bộ',
              onPressed: controller.isSyncing.value
                  ? () => {}
                  : controller.syncSingleData,
              background: controller.isSyncing.value
                  ? Colors.grey.shade400
                  : primaryColor,
            ),
          ))
      ],
    );
  }
}
