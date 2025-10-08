import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';
import 'package:rxdart/subjects.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class InterviewListDetailController extends BaseController {
  final InterviewListController interviewListController = Get.find();
  // maTinhTrangDT = 1 => chua pv
  // maTinhTrangDT = 9 => da pv
  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const tenDoiTuongDTKey = 'tenDoiTuongDT';
  static const maTinhTrangDTKey = 'maTinhTrangDT';
  static const maDiaBanKey = 'maDiaBan';
  static const tenDiaBanKey = 'tenDiaBan';
  static const maXaKey = 'maXa';
  static const tenXaKey = 'tenXa';
  static const routeKey = 'routeKey';
  // controller
  final searchController = TextEditingController();
  final sliverController = ScrollController();

  // params
  String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  String currentTenDoiTuongDT = Get.parameters[tenDoiTuongDTKey]!;
  String currentMaTinhTrangDT = Get.parameters[maTinhTrangDTKey]!;
  String? currentMaDiaBan = Get.parameters[maDiaBanKey];
  String? currentTenDiaBan = Get.parameters[tenDiaBanKey];
  String? currentMaXa = Get.parameters[maXaKey];
  String? currentTenXa = Get.parameters[tenXaKey];

  //static final interviewListDetailStream = PublishSubject();

  // params send to questions
  //String? currentIdCoSoTG;
  String? currentIdCoSo;

  //RX
  final danhSachDiaBanCoSoSXKD = <TableDmDiaBanCosoSxkd>[].obs;
  final danhSachBKCoSoSXXKD = <TableBkCoSoSXKD>[].obs;

  // provider
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();

  @override
  void onInit() async {
    setLoading(true);
    await getSubjects();
    setLoading(false);

    // interviewListDetailStream.stream.listen((value) {
    //   if (value) {
    //     getSubjects();
    //   }
    // });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  getSubTitle() {
    return interviewListController.getSubTitle();
  }

  void backInterviewList() {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      Get.toNamed(AppRoutes.interviewList, parameters: {
        InterviewListController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      });
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      Get.toNamed(AppRoutes.interviewList, parameters: {
        InterviewListController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      });
    }
  }

  startInterView(int index) async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      currentMaXa = danhSachBKCoSoSXXKD[index].maXa;
      currentIdCoSo = danhSachBKCoSoSXXKD[index].iDCoSo;
      currentMaDiaBan = danhSachBKCoSoSXXKD[index].maDiaBan;
      await Get.toNamed(AppRoutes.activeStatus);
      await getSubjects();
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      currentMaXa = danhSachBKCoSoSXXKD[index].maXa;
      currentIdCoSo = danhSachBKCoSoSXXKD[index].iDCoSo;
      currentMaDiaBan = danhSachBKCoSoSXXKD[index].maDiaBan;
      await Get.toNamed(AppRoutes.activeStatus);
      await getSubjects();
    } else {}
  }

  Future getSubjects() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      // => dieu tra theo địa bàn  (Cơ sở SXKD)
      if (currentMaTinhTrangDT == AppDefine.chuaPhongVan.toString()) {
        await getListBkDiaBanCoSoSXKDUnInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!);
      } else {
        await getListBkDiaBanCoSoSXKDInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!);
      }
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      // => dieu tra theo địa bàn  (Cơ sở SXKD)
      if (currentMaTinhTrangDT == AppDefine.chuaPhongVan.toString()) {
        await getListBkDiaBanCoSoSXKDUnInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!);
      } else {
        await getListBkDiaBanCoSoSXKDInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!);
      }
    }
  }

  onSearch(String search) async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      // => dieu tra theo địa bàn xã (Cơ sở sxkd)
      if (currentMaTinhTrangDT == AppDefine.chuaPhongVan.toString()) {
        await getListBkDiaBanCoSoSXKDUnInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!,
            search: search);
      } else {
        await getListBkDiaBanCoSoSXKDInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!,
            search: search);
      }
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      // => dieu tra theo địa bàn xã (Cơ sở sxkd)
      if (currentMaTinhTrangDT == AppDefine.chuaPhongVan.toString()) {
        await getListBkDiaBanCoSoSXKDUnInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!,
            search: search);
      } else {
        await getListBkDiaBanCoSoSXKDInterviewed(
            int.parse(currentMaDoiTuongDT), currentMaDiaBan!,
            search: search);
      }
    }
  }

  // danh sach BK CoSo SXKD chua phong van
  Future getListBkDiaBanCoSoSXKDUnInterviewed(int maDoiTuongDT, String maDB,
      {String? search}) async {
    if (search != null) {
      List<Map> map = await bkCoSoSXKDProvider.searchListUnInterviewedAll(
          maDoiTuongDT, maDB, search, currentMaXa!);
      danhSachBKCoSoSXXKD.clear();
      danhSachBKCoSoSXXKD.value = TableBkCoSoSXKD.listFromJson(map);
    }
    List<Map> map = await bkCoSoSXKDProvider.selectListUnInterviewedAll(
        maDoiTuongDT, maDB!, currentMaXa!);
    danhSachBKCoSoSXXKD.clear();
    danhSachBKCoSoSXXKD.value = TableBkCoSoSXKD.listFromJson(map);
  }

  // danh sach BK CoSo SXKD  da phong van
  Future getListBkDiaBanCoSoSXKDInterviewed(int maDoiTuongDT, String maDB,
      {String? search}) async {
    if (search != null) {
      List<Map> map = await bkCoSoSXKDProvider.searchListInterviewedAll(
          maDoiTuongDT, maDB, search, currentMaXa!);
      danhSachBKCoSoSXXKD.clear();
      danhSachBKCoSoSXXKD.value = TableBkCoSoSXKD.listFromJson(map);
    }
    List<Map> map = await bkCoSoSXKDProvider.selectListInterviewedAll(
        maDoiTuongDT, maDB, currentMaXa!);
    danhSachBKCoSoSXXKD.clear();
    danhSachBKCoSoSXXKD.value = TableBkCoSoSXKD.listFromJson(map);
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
