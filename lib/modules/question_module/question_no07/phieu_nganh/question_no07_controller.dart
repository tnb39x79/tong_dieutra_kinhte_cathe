import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_utils.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_barrier_widget.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_customize_widget.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/question/select_one.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/searchable/dropdown_category.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/searchable/search_sp_vcpa.dart';

import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/validation_no07.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/search_vcpa.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/search_vcpa_motasp.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/search_vcpa_tab.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau_dm.dart';

import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/danh_dau_sanpham_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/question_group.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/dm_common_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/models/predict_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/services/industry_code_evaluator.dart';

import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart';

class QuestionNo07Controller extends BaseController with QuestionUtils {
  QuestionNo07Controller({required this.vcpaVsicAIRepository});
  final HomeController homeController = Get.find();
  MainMenuController mainMenuController = Get.find();
  static const idCoSoKey = 'idCoSo';
  static const isNhomNganhCap1BCEKey = 'IsNhomNganhCap1BCE';

  String isNhomNganhCap1BCE = Get.parameters[isNhomNganhCap1BCEKey] ?? "";
  DateTime startTime = DateTime.now();
  //final FocusNode focusNode = FocusNode();

  /// param
  String? currentIdHoDuPhong;
  String? currentIdCoSoDuPhong;
  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaDiaBan;
  String? currentIdCoSo;
  String? currentMaXa;
  String? currentMaTinhTrangDT;

  final scrollController = ScrollController();

  final generalInformationController = Get.find<GeneralInformationController>();

  // Provider
  final dataProvider = DataProvider();
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();

  final phieuProvider = PhieuProvider();
  final phieuMauTBProvider = PhieuMauTBProvider();
  final phieuMauTBSanPhamProvider = PhieuMauTBSanPhamProvider();
  final phieuNganhCNProvider = PhieuNganhCNProvider();
  final phieuNganhLTProvider = PhieuNganhLTProvider();
  final phieuNganhTMProvider = PhieuNganhTMProvider();
  final phieuNganhTMSanphamProvider = PhieuNganhTMSanPhamProvider();
  final phieuNganhVTProvider = PhieuNganhVTProvider();
  final phieuNganhVTGhiRoProvider = PhieuNganhVTGhiRoProvider();

  final xacNhanLogicProvider = XacNhanLogicProvider();

  ///Danh mucj
  final dmDiaDiemSXKDProvider = CTDmDiaDiemSXKDProvider();
  final dmHoatDongLogisticProvider = CTDmHoatDongLogisticProvider();
  final dmLinhVucProvider = CTDmLinhVucProvider();
  final dmLoaiDiaDiemProvider = CTDmLoaiDiaDiemProvider();

  // final dmNhomNganhVcpaProvider = CTDmNhomNganhVcpaProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();
  final dmLinhvucSpProvider = DmLinhvucProvider();
  final dmQuocTichProvider = DmQuocTichProvider();
  final dmTrinhDoChuyenMonProvider = CTDmTrinhDoChuyenMonProvider();
  final dmTinhTrangDKKDProvider = CTDmTinhTrangDKKDProvider();
  final dmDanTocProvider = DmDanTocProvider();
  final dmCoKhongProvider = DmCoKhongProvider();
  final dmGioiTinhProvider = DmGioiTinhProvider();

  ///search by AI
  final VcpaVsicAIRepository vcpaVsicAIRepository;

  ///table
  ///
  final tblBkCoSoSXKD = TableBkCoSoSXKD().obs;
  final tblPhieu = TablePhieu().obs;
  final tblPhieuMauTB = TablePhieuMauTB().obs;
  final tblPhieuMauTBSanPham = <TablePhieuMauTBSanPham>[].obs;
  final tblPhieuNganhCN = <TablePhieuNganhCN>[].obs;
  final tblPhieuNganhLT = TablePhieuNganhLT().obs;

  final tblPhieuNganhTM = TablePhieuNganhTM().obs;
  final tblPhieuNganhTMSanPham = <TablePhieuNganhTMSanPham>[].obs;

  final tblPhieuNganhVT = TablePhieuNganhVT().obs;
  final tblPhieuNganhVTGhiRos = <TablePhieuNganhVTGhiRo>[].obs;

  //final tblDmCap = <TableDmCap>[].obs;
  final tblDmDiaDiemSXKD = <TableCTDmDiaDiemSXKD>[].obs;
  final tblDmHoatDongLogistic = <TableCTDmHoatDongLogistic>[].obs;
  final tblDmLinhVuc = <TableCTDmLinhVuc>[].obs;
  final tblDmLoaiDiaDiem = <TableCTDmLoaiDiaDiem>[].obs;
  // final tblDmNhomNganhVcpaSearch = <TableCTDmNhomNganhVcpa>[].obs;
  final tblDmMoTaSanPhamSearch = <TableDmMotaSanpham>[].obs;
  final tblDmMoTaSanPham = <TableDmMotaSanpham>[].obs;
  //final tblDmMoTaSanPhamFilterd = <TableDmMotaSanpham>[].obs;
  final tblLinhVucSp = <TableDmLinhvuc>[].obs;
  final tblLinhVucSpFilter = <TableDmLinhvuc>[].obs;
  final tblDmQuocTich = <TableCTDmQuocTich>[].obs;
  final tblDmTrinhDoChuyenMon = <TableCTDmTrinhDoChuyenMon>[].obs;
  final tblDmTinhTrangDKKD = <TableCTDmTinhTrangDKKD>[].obs;
  final tblDmDanToc = <TableDmDanToc>[].obs;
  final tblDmCoKhong = <TableDmCoKhong>[].obs;
  final tblDmGioiTinh = <TableDmGioiTinh>[].obs;

  final questions = <QuestionCommonModel>[].obs;
  final currentScreenNo = 0.obs;
  final currentScreenIndex = 0.obs;
  final questionIndex = 0.obs;

  final keywordDanToc = ''.obs;
  final searchResult = false.obs;
  final keywordVcpaCap5 = ''.obs;
  final searchResultCap5 = false.obs;

  ///Chọn search từ danh mục hay AI
  final aIModeStatus = ''.obs;
  final searchVcpaType = 0.obs;
  final startSearch = true.obs;
  final limitNumSearchAI = 10.obs;
  final limitNumSearchAIValue = 100;
  final responseMessageAI = ''.obs;

  final tblDmDanTocSearch = <TableDmDanToc>[].obs;

//* Chứa các giá trị
  RxMap<dynamic, dynamic> answerTblPhieuMau = {}.obs;
  RxMap<dynamic, dynamic> answerTblPhieuNganhVT = {}.obs;
  RxMap<dynamic, dynamic> answerTblPhieuNganhLT = {}.obs;

  ///Chứa STT_Sanpham đầu tiên.
  final sttProduct = 0.obs;
  RxMap<dynamic, dynamic> answerDanhDauSanPham = {}.obs;
  final isCap2_56 = false.obs;
  final isCap1HPhanVI = false.obs;
  final isCap5VanTaiHanhKhachPhanVI = false.obs;
  final isCap5DichVuHangHoaPhanVI = false.obs;
  final isCap2_55PhanVII = false.obs;

//* Chứa danh sách nhóm câu hỏi
  final questionGroupList = <QuestionGroupByMaPhieu>[].obs;
//* Chứa thông tin hoàn thành phiếu
  final completeInfo = {}.obs;
  String subTitleBar = '';

  String vcpaCap2PhanV = "56";
  String cap5VanTaiHanhKhach =
      "49210;49220;49290;49312;49313;49319;49321;49329;50111;50112;50211;50212";
  String cap5VanTaiHangHoa =
      "49331;49332;49333;49334;49339;50121;50122;50221;50222";
  String vcpaCap2PhanVII = "55";

  String maVcpaLoaiTruG_C5 = "45413";
  String maVcpaLoaiTruG_C4 = "4513;4520;4542";
  String maVcpaLoaiTruG_C3 = "461";

  String maVcpaL6810 = "6810";

  //Warning
  final warningA1_1 = ''.obs;
  final warningA4_2 = ''.obs;
  final warningA4_6 = ''.obs;
  final warningA6_4 = ''.obs;
  final warningA6_5 = ''.obs;
  final warningA6_11 = ''.obs;
  final warningA6_12 = ''.obs;

  // RxMap<dynamic, dynamic> warningMessage = {}.obs;
  //
  final a1_5_6MaWarning = [4, 5, 6, 7, 8, 9, 10];
  final a7_1FieldWarning = [
    'A7_1_1_3',
    'A7_1_2_3',
    'A7_1_3_3',
    'A7_1_4_3',
    'A7_1_5_3'
  ];
  final warningA7_1_1_3 = ''.obs;
  final warningA7_1_2_3 = ''.obs;
  final warningA7_1_3_3 = ''.obs;
  final warningA7_1_4_3 = ''.obs;
  final warningA7_1_5_3 = ''.obs;

  ///LinhVuc item đang chọn

  final linhVucSelected =
      TableDmLinhvuc(id: 0, maLV: '0', tenLinhVuc: "Chọn lĩnh vực").obs;

  final sanPhamIdSelected = 0.obs;
  final moTaSpSelected = ''.obs;
  final maLVSelected = ''.obs;

  ///Tìm kiếm vcpa offline AI
  final _evaluator = IndustryCodeEvaluator(isDebug: true);
  final isInitializedEvaluator = false.obs;

  @override
  void onInit() async {
    //focusNode.addListener( onFocusOpenDialogVcpa);
    setLoading(true);
    if (homeController.isDefaultUserType()) {
      final interviewListDetailController =
          Get.find<InterviewListDetailController>();
      currentMaDoiTuongDT = interviewListDetailController.currentMaDoiTuongDT;
      currentTenDoiTuongDT = interviewListDetailController.currentTenDoiTuongDT;
      currentIdCoSo = interviewListDetailController.currentIdCoSo;
      currentMaXa = interviewListDetailController.currentMaXa;
      currentMaDiaBan = interviewListDetailController.currentMaDiaBan;
      currentMaTinhTrangDT = interviewListDetailController.currentMaTinhTrangDT;
    } else {
      currentMaDoiTuongDT = generalInformationController.currentMaDoiTuongDT;
      currentTenDoiTuongDT = generalInformationController.currentTenDoiTuongDT;
      currentIdCoSo = generalInformationController.currentIdCoSo;
      currentMaXa = generalInformationController.currentMaXa;
      currentMaDiaBan = generalInformationController.currentMaDiaBan;
      currentMaTinhTrangDT = generalInformationController.currentMaTinhTrangDT;
    }
    startTime = getStartDate(
        currentIdCoSo!, int.parse(currentMaDoiTuongDT!), startTime);

    if (currentScreenNo.value == 0) {
      currentScreenNo.value = generalInformationController.screenNos()[0];
    }
    subTitleBar =
        'Mã địa bàn: ${generalInformationController.tblBkCoSoSXKD.value.maDiaBan} - ${generalInformationController.tblBkCoSoSXKD.value.tenCoSo}';

    log('Màn hình ${currentScreenNo.value}');
    await getDanhMuc();
    await fetchData();
    await getQuestionContent();
    await danhDauSanPhamPhanVI();
    await danhDauSanPhamPhanVII();
    await assignAllQuestionGroup();
    if (generalInformationController.tblBkCoSoSXKD.value.maTrangThaiDT ==
        AppDefine.hoanThanhPhongVan) {
      var trangThaiLogic = await bkCoSoSXKDProvider.selectTrangThaiLogicById(
          idCoSo: currentIdCoSo!);
      if (trangThaiLogic != 1) {
        ///Insert các màn hình đã hoàn thành logic nếu  trạng thái cơ sở SX đã hoàn thành phỏng vấn
        updateXacNhanLogicByMaTrangThaiDT(
            questionGroupList.value,
            int.parse(currentMaDoiTuongDT!),
            currentIdCoSo!,
            AppDefine.hoanThanhPhongVan);
        bkCoSoSXKDProvider.updateTrangThaiLogic(
            colBkCoSoSXKDTrangThaiLogic, 1, currentIdCoSo!);
      }
    }
    //}

    await setSelectedQuestionGroup();
    await getLinhVucSanPham();
    await getMoTaSanPham();
    setLoading(false);
    super.onInit();
  }

  Future getMoTaSanPham() async {
    var res = await dmMotaSanphamProvider.selectAll();
    var mtAll = TableDmMotaSanpham.listFromJson(res);

    tblDmMoTaSanPham.assignAll(mtAll);
  }

  Future getLinhVucSanPham() async {
    var res = await dmLinhvucSpProvider.selectAll();
    var mtAll = TableDmLinhvuc.listFromJson(res);
    mtAll.insert(0, TableDmLinhvuc.defaultLinhVuc());
    tblLinhVucSp.assignAll(mtAll);
  }

  /// Fetch Data các bảng của phiếu
  Future fetchData() async {
    Map questionPhieuMap =
        await phieuMauTBProvider.selectByIdCoSo(currentIdCoSo!);
    Map questionPhieuMauTBMap =
        await phieuMauTBProvider.selectByIdCoSo(currentIdCoSo!);
    if (questionPhieuMauTBMap.isNotEmpty) {
      answerTblPhieuMau.addAll(questionPhieuMauTBMap);
      var hasFieldTenDanToc = answerTblPhieuMau.containsKey('A1_3_3_tendantoc');
      if (!hasFieldTenDanToc) {
        var maDanToc = answerTblPhieuMau['A1_3_3'];
        if (maDanToc != null && maDanToc != '') {
          var danTocItems = await dmDanTocProvider.selectByMaDanToc(maDanToc);
          var result = danTocItems.map((e) => TableDmDanToc.fromJson(e));
          var dtM = result.toList();
          log('fetchData getValueDanTocByFieldName: ${danTocItems.length}');
          var res = dtM.firstOrNull;
          if (res != null) {
            log('Ten Dan Toc: ${res.tenDanToc!}');
            updateAnswerTblPhieuMau(
                'A1_3_3_tendantoc', res.tenDanToc!, tablePhieuMauTB);
          }
        }
      }
      tblPhieu.value = TablePhieu.fromJson(questionPhieuMap);
      tblPhieuMauTB.value = TablePhieuMauTB.fromJson(questionPhieuMauTBMap);
      await getThongTinNguoiPV();

      Map phieuNganhLTMap =
          await phieuNganhLTProvider.selectByIdCoSo(currentIdCoSo!);
      if (phieuNganhLTMap.isNotEmpty) {
        answerTblPhieuNganhLT.addAll(phieuNganhLTMap);
      }

//
      Map phieuNganhVTMap =
          await phieuNganhVTProvider.selectByIdCoSo(currentIdCoSo!);
      if (phieuNganhVTMap.isNotEmpty) {
        answerTblPhieuNganhVT.addAll(phieuNganhVTMap);
      }

      await getTablePhieuMauTBSanPham();
      await getTablePhieuNganhCN();
      await getTablePhieuNganhLT();
      await getTablePhieuNganhTM();
      await getTablePhieuNganhTMSanPham();
      await getTablePhieuNganhVT();
      await getTablePhieuNganhVTGhiRo();
    }
  }

  Future getThongTinNguoiPV() async {
    // String? soDienThoaiDTV = tblPhieu.value.soDienThoaiDTV;
//    String? hoTenDTV = tblPhieuMau.value.hoTenDTV;
    // if (soDienThoaiDTV == null || soDienThoaiDTV == '') {
    //   soDienThoaiDTV = mainMenuController.userModel.value.sDT;
    // }
    // if (hoTenDTV == null || hoTenDTV == '') {
    //   hoTenDTV = mainMenuController.userModel.value.tenNguoiDung;
    // }
    await mapCompleteInfo(soDienThoaiBase, tblPhieu.value.soDienThoai);
    await mapCompleteInfo(nguoiTraLoiBase, tblPhieu.value.nguoiTraLoi);
    await mapCompleteInfo(kinhDoBase, tblPhieu.value.kinhDo);
    await mapCompleteInfo(viDoBase, tblPhieu.value.viDo);
    //  await mapCompleteInfo(soDienThoaiDTVBase, soDienThoaiDTV);
    // await mapCompleteInfo(hoTenDTVBase, hoTenDTV);
  }

  Future getTablePhieu() async {
    Map question07Map = await phieuProvider.selectByIdCoSo(currentIdCoSo!);

    if (question07Map.isNotEmpty) {
      tblPhieu.value = TablePhieu.fromJson(question07Map);
    }
  }

  Future getTablePhieuMauTB() async {
    Map questionPhieuMauTBMap =
        await phieuMauTBProvider.selectByIdCoSo(currentIdCoSo!);

    if (questionPhieuMauTBMap.isNotEmpty) {
      tblPhieuMauTB.value = TablePhieuMauTB.fromJson(questionPhieuMauTBMap);
    }
  }

  Future getTablePhieuMauTBSanPham() async {
    List<Map> questionSpMap =
        await phieuMauTBSanPhamProvider.selectByIdCoSo(currentIdCoSo!);
    var rs = TablePhieuMauTBSanPham.fromListJson(questionSpMap)!;
    tblPhieuMauTBSanPham.assignAll(rs);
    tblPhieuMauTBSanPham.refresh();
    var rsFirst = rs.firstOrNull;
    if (rsFirst != null) {
      if (rsFirst.isDefault == 1) {
        sttProduct.value = rsFirst.sTTSanPham!;
      } else {
        var ress = rs.where((x) => x.isDefault == 1).firstOrNull;
        if (ress != null) {
          sttProduct.value = ress.sTTSanPham!;
        }
      }
    }

    ///Danh dau san pham
    await danhDauSanPham();
  }

  Future getTablePhieuNganhCN() async {
    List<Map> questionCNMap =
        await phieuNganhCNProvider.selectByIdCoso(currentIdCoSo!);

    tblPhieuNganhCN.assignAll(TablePhieuNganhCN.fromListJson(questionCNMap)!);
    tblPhieuNganhCN.refresh();
  }

  Future getTablePhieuNganhVT() async {
    Map questionVTMap =
        await phieuNganhVTProvider.selectByIdCoSo(currentIdCoSo!);

    tblPhieuNganhLT.value = TablePhieuNganhLT.fromJson(questionVTMap)!;
    tblPhieuNganhLT.refresh();
  }

  Future getTablePhieuNganhVTGhiRo() async {
    List<Map> questionVTGhiRoMap =
        await phieuNganhVTGhiRoProvider.selectByIdCoso(currentIdCoSo!);

    tblPhieuNganhVTGhiRos
        .assignAll(TablePhieuNganhVTGhiRo.fromListJson(questionVTGhiRoMap)!);
    tblPhieuNganhVTGhiRos.refresh();
  }

  Future getTablePhieuNganhLT() async {
    Map questionLTMap =
        await phieuNganhLTProvider.selectByIdCoSo(currentIdCoSo!);

    tblPhieuNganhLT.value = TablePhieuNganhLT.fromJson(questionLTMap);
    tblPhieuNganhLT.refresh();
  }

  Future getTablePhieuNganhTM() async {
    Map questionTMMap =
        await phieuNganhTMProvider.selectByIdCoSo(currentIdCoSo!);

    tblPhieuNganhTM.value = TablePhieuNganhTM.fromJson(questionTMMap);
    tblPhieuNganhTM.refresh();
  }

  Future getTablePhieuNganhTMSanPham() async {
    List<Map> questionTMSanPhamMap =
        await phieuNganhTMProvider.selectListByIdCoSo(currentIdCoSo!);

    tblPhieuNganhTMSanPham.assignAll(
        TablePhieuNganhTMSanPham.fromListJson(questionTMSanPhamMap)!);
    tblPhieuNganhTMSanPham.refresh();
  }

  ///Danh dau san pham
  danhDauSanPham() async {
    if (tblPhieuMauTBSanPham.isNotEmpty) {
      for (var item in tblPhieuMauTBSanPham) {
        bool isCap1BCDE = false;
        bool isCap1GL = false;
        bool isCap2_56 = false;
        // bool isCap1H = false;
        // bool isCap5VanTaiHanhKhach = false;
        // bool isCap5DichVuHangHoa = false;
        // bool isCap2_55 = false;
        if (item.a5_1_2 != null && item.a5_1_2 != '') {
          isCap1BCDE = await hasA5_3BCDE(item.a5_1_2!);
          isCap1GL = await hasA5_5G_L6810(item.a5_1_2!);
          isCap2_56 = await hasCap2_56PhanV(item.a5_1_2!, vcpaCap2PhanV);
        }
        Map<String, dynamic> ddSP = {
          ddSpId: item.id,
          ddSpMaSanPham: item.a5_1_2,
          ddSpSttSanPham: item.sTTSanPham,
          ddSpIsCap1BCDE: isCap1BCDE,
          ddSpIsCap1GL: isCap1GL,
          ddSpIsCap2_56: isCap2_56
        };
        updateAnswerDanhDauSanPham(item.sTTSanPham, ddSP);
      }

      await danhDauSanPhamPhanVI();
      await danhDauSanPhamPhanVII();
    }
  }

  danhDauSanPhamPhanVI() async {
    if (currentScreenNo.value == 1 ||
        currentScreenNo.value == 5 ||
        currentScreenNo.value == 6 ||
        currentScreenNo.value == 7 ||
        currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {
      if (tblPhieuMauTBSanPham.isNotEmpty) {
        isCap1HPhanVI.value = await hasCap1PhanVI();
        isCap5VanTaiHanhKhachPhanVI.value =
            await hasCap5PhanVI(cap5VanTaiHanhKhach);
        isCap5DichVuHangHoaPhanVI.value =
            await hasCap5PhanVI(cap5VanTaiHangHoa);
      }
    }
  }

  danhDauSanPhamPhanVII() async {
    if (currentScreenNo.value == 1 ||
        currentScreenNo.value == 5 ||
        currentScreenNo.value == 6 ||
        currentScreenNo.value == 7 ||
        currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {
      if (tblPhieuMauTBSanPham.isNotEmpty) {
        isCap2_55PhanVII.value = await hasCap2PhanVII('55');
      }
    }
  }

  Future<List<QuestionCommonModel>> getQuestionContent() async {
    try {
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      dynamic question08 = tableData.toCauHoiPhieu07(currentMaDoiTuongDT!);

      List<QuestionCommonModel> questionsTemp =
          QuestionCommonModel.listFromJson(jsonDecode(question08));
      List<QuestionCommonModel> questionsTemp2 = [];
      if (questionsTemp.isNotEmpty) {
        questionsTemp2.addAll(questionsTemp);
        questions.clear();

        questionsTemp2.retainWhere((x) {
          return (x.manHinh == currentScreenNo.value);
        });
      }

      //kiểm tra VCPA cấp 1 không phải là H thì remove câu hỏi phần 6
      // if (currentScreenNo.value == 6 || currentScreenNo.value == 7) {
      //   await danhDauSanPhamPhanVI();
      //   await danhDauSanPhamPhanVI();
      //   var questionByVcpa = await getQuestionContentFilterByVcpa(
      //       questionsTemp2,
      //       currentScreenNo.value,
      //       isCap1HPhanVI.value,
      //       isCap5VanTaiHanhKhachPhanVI.value,
      //       isCap5DichVuHangHoaPhanVI.value,
      //       isCap2_55PhanVII.value);
      //   questions.addAll(questionByVcpa);
      // } else {
      //   questions.addAll(questionsTemp2);
      // }
      questions.addAll(questionsTemp2);
      return questions;
    } catch (e) {
      log('ERROR lấy danh sách câu hỏi phiếu: $e');
      return [];
    }
  }

  Future getDanhMuc() async {
    await Future.wait([
      getDmCoKhong(),
      getDmDanToc(),
      getDmGioiTinh(),
      getDmDiaDiemSXKD(),
      getDmHoatDongLogistic(),
      getDmLinhVuc(),
      getDmLoaiDiaDiem(),
      getDmQuocTich(),
      getDmTinhTrangDKKD(),
      getDmTrinhDoChuyenMon(),
    ]);
  }

  Future getDmCoKhong() async {
    try {
      dynamic map = await dmCoKhongProvider.selectAll();
      tblDmCoKhong.value = TableDmCoKhong.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmCoKhong: $e');
    }
  }

  Future getDmDanToc() async {
    try {
      dynamic map = await dmDanTocProvider.selectAll();
      tblDmDanToc.value = TableDmDanToc.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmDanToc: $e');
    }
  }

  Future getDmGioiTinh() async {
    try {
      dynamic map = await dmGioiTinhProvider.selectAll();
      tblDmGioiTinh.value = TableDmGioiTinh.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmGioiTinh: $e');
    }
  }

  Future getDmDiaDiemSXKD() async {
    try {
      dynamic map = await dmDiaDiemSXKDProvider.selectAll();
      tblDmDiaDiemSXKD.value = TableCTDmDiaDiemSXKD.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmDiaDiemSXKD: $e');
    }
  }

  Future getDmHoatDongLogistic() async {
    try {
      dynamic map = await dmHoatDongLogisticProvider.selectAll();
      tblDmHoatDongLogistic.value = TableCTDmHoatDongLogistic.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmHoatDongLogistic: $e');
    }
  }

  Future getDmLinhVuc() async {
    try {
      dynamic map = await dmLinhVucProvider.selectAll();
      tblDmLinhVuc.value = TableCTDmLinhVuc.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmLinhVuc: $e');
    }
  }

  Future getDmLoaiDiaDiem() async {
    try {
      dynamic map = await dmLoaiDiaDiemProvider.selectAll();
      tblDmLoaiDiaDiem.value = TableCTDmLoaiDiaDiem.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmLoaiDiaDiem: $e');
    }
  }

  Future getDmQuocTich() async {
    // try {
    //   dynamic map = await dmQuocTichProvider.selectAll();
    //   tblDmQuocTich.value = TableCTDmQuocTich.listFromJson(map);
    // } catch (e) {
    //   log('ERROR lấy getDmQuocTich: $e');
    // }
  }

  Future getDmTinhTrangDKKD() async {
    try {
      dynamic map = await dmTinhTrangDKKDProvider.selectAll();
      tblDmTinhTrangDKKD.value = TableCTDmTinhTrangDKKD.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmTinhTrangDKKD: $e');
    }
  }

  Future getDmTrinhDoChuyenMon() async {
    try {
      dynamic map = await dmTrinhDoChuyenMonProvider.selectAll();
      tblDmTrinhDoChuyenMon.value = TableCTDmTrinhDoChuyenMon.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmTrinhDoChuyenMon: $e');
    }
  }

  // Future assignAllQuestionGroup() async {
  //   var qGroups = await getQuestionGroups(currentMaDoiTuongDT!, currentIdCoSo!);
  //   questionGroupList.assignAll(qGroups);
  // }
  Future assignAllQuestionGroup() async {
    // var qGroups = await getQuestionGroups(currentMaDoiTuongDT!, currentIdCoSo!);
    // for (var item in qGroups) {
    //   if (item.fromQuestion == "6.1") {
    //     item.enable = (isCap1HPhanVI.value == true &&
    //             isCap5DichVuHangHoaPhanVI.value == true) ||
    //         (isCap1HPhanVI.value == true &&
    //             isCap5VanTaiHanhKhachPhanVI.value == true);
    //   } else if (item.fromQuestion == "7.1") {
    //     // if (isCap2_55PhanVII.value == true) {
    //     item.enable = isCap2_55PhanVII.value;
    //     // }
    //   }
    // }
    // questionGroupList.assignAll(qGroups);
  }

  Future onOpenDrawerQuestionGroup() async {
    scaffoldKey.currentState?.openDrawer();
  }

  Future onMenuPress(int id,int idManHinh) async {
    await fetchData();
    String validateResult = await validateAllFormV2();
    if (validateResult != '') {
      insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
      return showError(validateResult);
    }
    await clearSelectedQuestionGroup();
    // var qItem = questionGroupList.where((x) => x.id == id).first;
    // if (qItem != null) {
    //   if (qItem.enable!) {
    //     qItem.isSelected = true;
    //     currentScreenNo.value = qItem.manHinh!;
    //     if (currentScreenNo.value > 0) {
    //       currentScreenIndex.value = currentScreenNo.value - 1;
    //     }
    //     await danhDauSanPhamPhanVI();
    //     await danhDauSanPhamPhanVII();
    //     await getQuestionContent();
    //     if (currentScreenIndex.value ==
    //         generalInformationController.screenNos().length - 1) {}
    //   } else {
    //     snackBar('Thông báo', 'Danh sách cấu hỏi này chưa nhập');
    //   }
    // }
    questionGroupList.refresh();
    scaffoldKey.currentState?.closeDrawer();
  }

  Future clearSelectedQuestionGroup() async {
    // for (var item in questionGroupList) {
    //   item.isSelected = false;
    // }
    // questionGroupList.refresh();
  }

  Future setSelectedQuestionGroup() async {
    // if (currentScreenNo.value > 0) {
    //   await clearSelectedQuestionGroup();
    //   var questionGroupItem = questionGroupList
    //       .where((x) => x.manHinh == currentScreenNo.value)
    //       .firstOrNull;
    //   if (questionGroupItem != null) {
    //     if (questionGroupItem.enable!) {
    //       questionGroupItem.isSelected = true;
    //       questionGroupList.refresh();
    //     }
    //   }
    // }
  }

  Future onBackStart() async {
    await fetchData();
    String validateResult = await validateAllFormV2();
    if (validateResult != '') {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
    } else {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          '',
          int.parse(currentMaTinhTrangDT!));
    }
    Get.back();
  }

  /// Handle onPressed [Quay lại] button
  Future onBack() async {
    await fetchData();
    String validateResult = await validateAllFormV2();
    if (validateResult != '') {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
    } else {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          '',
          int.parse(currentMaTinhTrangDT!));
    }
    if (currentScreenNo.value > 0) {
      currentScreenNo.value--;
      currentScreenIndex.value--;
      if (currentScreenNo.value == 0) {
        Get.back();
      } else {
        if (currentScreenNo.value == 6 || currentScreenNo.value == 7) {
          await danhDauSanPhamPhanVI();
          await danhDauSanPhamPhanVII();
          await getQuestionContent();
          if (questions.isEmpty) {
            if (currentScreenIndex.value > 0) {
              currentScreenNo(currentScreenNo.value - 1);
              currentScreenIndex(currentScreenIndex.value - 1);
              await getQuestionContent();
              if (questions.isEmpty) {
                if (currentScreenIndex.value > 0) {
                  currentScreenNo(currentScreenNo.value - 1);
                  currentScreenIndex(currentScreenIndex.value - 1);
                  await getQuestionContent();
                }
              }
            }
          }
        }
        await danhDauSanPhamPhanVI();
        await danhDauSanPhamPhanVII();
        await getQuestionContent();

        await scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        await setSelectedQuestionGroup();
      }
    } else {
      currentScreenIndex.value = 0;
      Get.back();
    }
  }

  void onNext() async {
    await fetchData();

    String validateResult = ""; // await validateAllFormV2();

    ///
    ///Kiểm tra màn hình để đến màn hình tiếp hoặc hiện màn hình kết thúc phỏng vấn
    ///
    // if (currentScreenNo.value == 0) {
    //   currentScreenNo.value = generalInformationController.screenNos()[0];
    // }
    if (validateResult != '') {
      insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
      return showError(validateResult);
    } else {
      ///Đã vượt qua validate xong thì update/add thông tin vào bảng tableXacNhanLogic
      await insertUpdateXacNhanLogic(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          1,
          '',
          int.parse(currentMaTinhTrangDT!));
    }
    if (currentScreenNo.value == 4 ||
        currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {
      //Kiểm tra NganhCN
      var hasBDCE = await hasAllSanPhamBCDE();
      if (hasBDCE) {
        ///Kiểm tra bảng NganhCN có dữ liệu chưa???
        //updateDataNganhCN();
        onNextContinue();
      }
    } else if (currentScreenNo.value == 8 ||
        currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {
      //Kiểm tra NganhTM
      var hasBDCE = await hasAll_5G_L6810();
      if (hasBDCE) {
        ///Kiểm tra bảng NganhCN có dữ liệu chưa???
        //updateDataNganhTM();
        onNextContinue();
      }
    } else if (currentScreenNo.value == 5 ||
        currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {
      await danhDauSanPhamPhanVI();
      await danhDauSanPhamPhanVII();
      var validSp = await validateNganhHPhanVI();
      var validSpVII = await validateNganhHPhanVII();
      if (validSp == "" && validSpVII == "") {
        onNextContinue();
      } else {
        // 'Thông tin về nhóm sản phẩm không có hoạt động kinh doanh vận tải. Dữ liệu mục VI và mục VII sẽ bị xoá. Bạn có đồng ý?.';
        if (validSp == "phan6hh") {
          String warningMsg =
              'Thông tin về nhóm sản phẩm không có hoạt động vận tải hàng hoá. Dữ liệu mục VI hoạt động vận tải hàng hoá sẽ bị xoá. Bạn có đồng ý?.';
          await showDialogValidNganhHPhanVIPhanVII(validSp!, warningMsg);
        } else if (validSp == "phan6hk") {
          String warningMsg =
              'Thông tin về nhóm sản phẩm không có hoạt động vận tải hành khách. Dữ liệu mục VI hoạt động vận tải hành khách sẽ bị xoá. Bạn có đồng ý?.';
          await showDialogValidNganhHPhanVIPhanVII(validSp!, warningMsg);
        } else if (validSp == "phan6") {
          String warningMsg =
              'Thông tin về nhóm sản phẩm không có hoạt động vận tải. Dữ liệu mục VI sẽ bị xoá. Bạn có đồng ý?.';
          await showDialogValidNganhHPhanVIPhanVII(validSp!, warningMsg);
        } else if (validSpVII == "phan7") {
          String warningMsg =
              'Thông tin về nhóm sản phẩm không có hoạt động kinh doanh dịch vụ lưu trú. Dữ liệu mục VII sẽ bị xoá. Bạn có đồng ý?.';
          await showDialogValidNganhHPhanVIPhanVII(validSpVII!, warningMsg);
        }
      }
    } else {
      onNextContinue();
    }
  }

  void onNextContinue() async {
    await assignAllQuestionGroup();
    if (currentScreenIndex.value <
        generalInformationController.screenNos().length - 1) {
      currentScreenNo(currentScreenNo.value + 1);
      currentScreenIndex(currentScreenIndex.value + 1);
      await danhDauSanPhamPhanVI();
      await danhDauSanPhamPhanVII();
      await getQuestionContent();

      ///Qua màn hình tiếp theo nếu câu hỏi màn hình đó rỗng;
      if (currentScreenNo.value == 6 || currentScreenNo.value == 7) {
        if (questions.isEmpty) {
          if (currentScreenIndex.value <
              generalInformationController.screenNos().length - 1) {
            currentScreenNo(currentScreenNo.value + 1);
            currentScreenIndex(currentScreenIndex.value + 1);
            await getQuestionContent();
            if (questions.isEmpty) {
              if (currentScreenIndex.value <
                  generalInformationController.screenNos().length - 1) {
                currentScreenNo(currentScreenNo.value + 1);
                currentScreenIndex(currentScreenIndex.value + 1);
                await getQuestionContent();
              }
            }
          }
        }
      }

      await setSelectedQuestionGroup();
      snackBar('Man hinh', '${currentScreenNo.value}');
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    } else {
      await setSelectedQuestionGroup();
      var result = await validateCompleted();
      if (result != null && result != '') {
        result = result.replaceAll('^', '\r\n');
        return showError(result);
      }
      onKetThucPhongVan();
    }
  }

  ///Nếu không có ngành H (isCap1HPhanVI.value==true) thì cảnh báo và xoá dữ liệu phần VI và VII
  ///Nếu có ngành H (isCap1HPhanVI.value==false ) nhưng  isCap5VanTaiHanhKhachPhanVI.value == false
  ///Nếu có ngành H (isCap1HPhanVI.value==false )  isCap5DichVuHangHoaPhanVI.value == false
  ///thì sẽ xoá dữ liệu phần tương ứng
  Future<String?> validateNganhHPhanVI() async {
    await danhDauSanPhamPhanVI();
    await danhDauSanPhamPhanVII();

    if (isCap1HPhanVI.value == true) {
      if (isCap5VanTaiHanhKhachPhanVI.value == false &&
          isCap5DichVuHangHoaPhanVI.value == true) {
        ///Cảnh báo và xoá dữ liệu phần VI hành khách
        //Kiểm tra dữ liệu phần VI có không?
        var hasP6HK = await hasMucVIHanhKhach();
        if (hasP6HK) {
          return "phan6hk";
        }
      } else if (isCap5VanTaiHanhKhachPhanVI.value == true &&
          isCap5DichVuHangHoaPhanVI.value == false) {
        ///Cảnh báo và xoá dữ liệu phần VI hàng hoá
        var hasP6HH = await hasMucVIHangHoa();
        if (hasP6HH) {
          return "phan6hh";
        }
      } else if (isCap5DichVuHangHoaPhanVI.value == false &&
          isCap5VanTaiHanhKhachPhanVI.value == false) {
        ///Cảnh báo và xoá dữ liệu phần VI hàng hoá, hành khách
        var hasP6HH = await hasMucVIHangHoa();
        var hasP6HK = await hasMucVIHanhKhach();
        if (hasP6HH || hasP6HK) {
          return "phan6";
        }
      }
    } else {
      ///Cảnh báo và xoá dữ liệu phần VI và VII
      var hasP6HH = await hasMucVIHangHoa();
      var hasP6HK = await hasMucVIHanhKhach();
      if (hasP6HH || hasP6HK) {
        return "phan6";
      }
    }
    return "";
  }

  Future<String?> validateNganhHPhanVII() async {
    await danhDauSanPhamPhanVI();
    await danhDauSanPhamPhanVII();
    // if (isCap2_55PhanVII.value == false) {
    //   var hasP7 = await phieuMauTBProvider.kiemTraPhanVIVIIValues(
    //       currentIdCoSo!, fieldNamesPhan7);
    //   if (hasP7) {
    //     return "phan7";
    //   }
    // }
    return "";
  }

  Future showDialogValidNganhHPhanVIPhanVII(
      String hoatDong, String warningMsg) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await excueteValidNganhVIVII(hoatDong);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: warningMsg,
    ));
  }

  Future excueteValidNganhVIVII(String hoatDong) async {
    if (hoatDong == "phan6") {
      ///Cảnh báo và xoá dữ liệu phần VI và VII
      await excueteDeletePhan6ItemHangHoa();
      await excueteDeletePhan6ItemHanhKhach();

      ///Cập nhật lại bảng xacnhanlogic cho phần VI về null
      await insertUpdateXacNhanLogic(
          6,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "phan6hh") {
      await excueteDeletePhan6ItemHangHoa();
      await insertUpdateXacNhanLogic(
          6,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "phan6hk") {
      await excueteDeletePhan6ItemHanhKhach();
      await insertUpdateXacNhanLogic(
          6,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "phan7") {
      await excueteDeletePhan7Item();
      await insertUpdateXacNhanLogic(
          7,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    }

    ///Tính lại A5_7 và A7_10 A7_11 A7_13
    ///"5T. TỔNG DOANH THU CỦA CÁC SẢN PHẨM NĂM 2025 (TỔNG CÁC CÂU A5.2 * CÂU A4.1)
    var total5TValue = await total5T();
    await updateAnswerToDB(tablePhieuMauTB, colPhieuMauTBA5T, total5TValue);
    if (hoatDong != "phan7") {
      //colPhieuMauTBA7_5_M: 5. Doanh thu từ khách ngủ qua đêm chiếm bao nhiêu phần trăm trong tổng doanh thu?
      var a7_9Value = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA7_5_M);
      if (a7_9Value != null) {
        await tinhCapNhatA8_M_A9_M_A10_M(a7_9Value);
      }
    }
    // var countRes =
    //     await phieuMauSanPhamProvider.countNotIsDefaultByIdCoso(currentIdCoSo!);
    // if (countRes == 0) {
    //   await phieuMauSanPhamProvider.updateValue(
    //       columnPhieuMauSanPhamA5_0, 2, currentIdCoSo);
    // }
    await getTablePhieuMauTBSanPham();
    await danhDauSanPhamPhanVI();
    await danhDauSanPhamPhanVII();
  }

  Future<bool> hasMucVIHangHoa() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HHTB);
      var has6_8 = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI || has6_8);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HHTB);
      var has6_8 = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI || has6_8);
    } else {
      return false;
    }
  }

  Future<bool> hasMucVIHanhKhach() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HKTB);
      var has6_1 = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI || has6_1);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HKTB);
      var has6_1 = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI || has6_1);
    } else {
      return false;
    }
  }

  Future excueteDeletePhan6ItemHangHoa() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HHTB);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HHMau);
    }
  }

  Future excueteDeletePhan6ItemHanhKhach() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HKTB);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HKMau);
    }
  }

  Future excueteDeletePhan7Item() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhLTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan7LTTB);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhLTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan7LTMau);
    }
  }

  Future<String?> validateCompleted() async {
    var result = await xacNhanLogicProvider.kiemTraLogicByIdDoiTuongDT(
        maDoiTuongDT: currentMaDoiTuongDT!, idDoiTuongDT: currentIdCoSo!);
    return result;
  }

  updateAnswerCompletedToDb(key, value) async {
    log("Update to db: $key $value");
    await phieuProvider.updateValue(key, value, currentIdCoSo);
  }

  onChangeCompleted(key, value) {
    log('ON CHANGE COMPLETED: $key $value', name: "onChangeCompleted");
    Map<String, dynamic> map = Map<String, dynamic>.from(completeInfo);
    try {
      map.update(key, (val) => value, ifAbsent: () => value);
      completeInfo.value = map;
      updateAnswerCompletedToDb(key, value);
    } catch (e) {
      log('onChangeCompleted error: ${e.toString()}');
    }
  }

  Future mapCompleteInfo(key, value) async {
    Map<String, dynamic> map = Map<String, dynamic>.from(completeInfo);
    map.update(key, (val) => value, ifAbsent: () => value);
    completeInfo.value = map;
  }

  ///BEBGIN::Event câu hỏi

  onChangeInput(String table, String? maCauHoi, String? fieldName, value,
      {String? fieldNameTotal}) async {
    log('ON onChangeInput: $fieldName $value');

    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      if (maCauHoi == colPhieuMauTBA3_2) {
        await updateAnswerDongCotToDB(table, fieldName!, value,
            fieldNames: fieldNameA3T,
            fieldNameTotal: colPhieuMauTBA3T,
            maCauHoi: maCauHoi);
      }
      if (maCauHoi == colPhieuTenCoSo) {
        await warningA1_1TenCoSo();
      }
      if (maCauHoi == "A4_1" || maCauHoi == "A4_2") {
        var fieldNamesA4T = ['A4_1', 'A4_2'];
        await updateAnswerDongCotToDB(table, fieldName!, value,
            fieldNames: fieldNamesA4T,
            fieldNameTotal: colPhieuMauTBA4T,
            maCauHoi: maCauHoi);

        if (maCauHoi == "A4_1") {
          var total5TValue = await total5T();
          updateAnswerToDB(tablePhieuMauTB, colPhieuMauTBA5T, total5TValue);
        }
      }
      if (maCauHoi == colPhieuMauTBA4_2) {
        await warningA4_2DoanhThu();
      }
      if (maCauHoi == colPhieuMauTBA4_3) {
        await warningA4_6TienThueDiaDiem();
      }
      //Van tai mẫu
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
        if (maCauHoi == colPhieuNganhVTA1_M ||
            maCauHoi == colPhieuNganhVTA2_M) {
          var fieldNameTotalA6_6 = colPhieuNganhVTA4_M;
          var fieldNamesA6_3_6_4 = [colPhieuNganhVTA1_M, colPhieuNganhVTA2_M];
          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNamesA6_3_6_4,
              fieldNameTotal: fieldNameTotalA6_6,
              maCauHoi: maCauHoi);

          if (maCauHoi == colPhieuNganhVTA2_M) {
            await warningA6_4SoKhachBQ();
          }
        }

        if (maCauHoi == colPhieuNganhVTA3_M) {
          var fieldNameTotalA6_7 = colPhieuNganhVTA5_M;
          var fieldNamesA6_5 = [colPhieuNganhVTA3_M, colPhieuNganhVTA4_M];
          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNamesA6_5,
              fieldNameTotal: fieldNameTotalA6_7,
              maCauHoi: maCauHoi);

          await warningA6_5SoKmBQ();
        }

        if (maCauHoi == colPhieuNganhVTA6_M ||
            maCauHoi == colPhieuNganhVTA7_M) {
          var fieldNameTotalA6_13 = colPhieuNganhVTA9_M;
          var fieldNamesA6_13 = [colPhieuNganhVTA6_M, colPhieuNganhVTA7_M];
          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNamesA6_13,
              fieldNameTotal: fieldNameTotalA6_13,
              maCauHoi: maCauHoi);

          if (maCauHoi == colPhieuNganhVTA7_M) {
            await warningA6_11KhoiLuongHHBQ();
          }
          await tinhCapNhatA6_13_A6_14();
        }
        if (maCauHoi == colPhieuNganhVTA8_M) {
          var fieldNameTotalA6_14 = colPhieuNganhVTA10_M;
          var fieldNamesA6_14 = [colPhieuNganhVTA8_M, colPhieuNganhVTA9_M];
          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNamesA6_14,
              fieldNameTotal: fieldNameTotalA6_14,
              maCauHoi: maCauHoi);

          await warningA6_12SoKmBQ();
          await tinhCapNhatA6_13_A6_14();
        }
      }
      if (maCauHoi == colPhieuNganhLTA1_M || maCauHoi == colPhieuNganhLTA2_M) {
        // var fieldNameTotalA7x = "A7_8";
        // var fieldNamesA7x = ['A7_6', 'A7_7'];
        // await updateAnswerDongCotToDB(table, fieldName!, value,
        //     fieldNames: fieldNamesA7x,
        //     fieldNameTotal: fieldNameTotalA7x,
        //     maCauHoi: maCauHoi);
      }
      if (maCauHoi == colPhieuNganhLTA1_1_M ||
          maCauHoi == colPhieuNganhLTA2_1_M) {
        // var fieldNameTotalA7x = "A7_8_1";
        // var fieldNamesA7x = ['A7_6_1', 'A7_7_1'];
        // await updateAnswerDongCotToDB(table, fieldName!, value,
        //     fieldNames: fieldNamesA7x,
        //     fieldNameTotal: fieldNameTotalA7x,
        //     maCauHoi: maCauHoi);
      }
      if (maCauHoi == colPhieuNganhLTA5_M || maCauHoi == colPhieuNganhLTA6_M) {
        await updateAnswerDongCotToDB(table, fieldName!, value,
            maCauHoi: maCauHoi);
      }
      if (maCauHoi == colPhieuNganhTMA3 && table == tablePhieuNganhTM) {
        var total3TValue = await totalA3TNganhtTM();
        updateAnswerToDB(tablePhieuNganhTM, colPhieuNganhTMA3T, total3TValue);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  /// Update giá trị của 1 trường
  updateAnswerToDB(String table, String fieldName, value,
      {List<String>? fieldNames, String? fieldNameTotal}) async {
    if (fieldName == '') return;
    if (table == tablePhieuMauTB) {
      await phieuMauTBProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
    } else if (table == tablePhieuNganhVT) {
      await phieuNganhVTProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
    } else if (table == tablePhieuNganhLT) {
      await phieuNganhLTProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
    } else if (table == tablePhieuNganhTM) {
      await phieuNganhTMProvider.updateValue(fieldName, value, currentIdCoSo!);
      await getTablePhieuNganhTM();
    } else {
      snackBar("dialog_title_warning".tr, "data_table_undefine".tr);
    }
  }

// * Update lại giá trị cho answerTblSanpham khi onchangexxx
  Future updateAnswerTblPhieuMau(fieldName, value, table) async {
    if (table == tablePhieuMauTB) {
      Map<String, dynamic> map = Map<String, dynamic>.from(answerTblPhieuMau);
      map.update(fieldName, (val) => value, ifAbsent: () => value);
      answerTblPhieuMau.value = map;
      answerTblPhieuMau.refresh();
    } else if (table == tablePhieuNganhLT) {
      Map<String, dynamic> map =
          Map<String, dynamic>.from(answerTblPhieuNganhLT);
      map.update(fieldName, (val) => value, ifAbsent: () => value);
      answerTblPhieuNganhLT.value = map;
      answerTblPhieuNganhLT.refresh();
    } else if (table == tablePhieuNganhVT) {
      Map<String, dynamic> map =
          Map<String, dynamic>.from(answerTblPhieuNganhVT);
      map.update(fieldName, (val) => value, ifAbsent: () => value);
      answerTblPhieuNganhVT.value = map;
      answerTblPhieuNganhVT.refresh();
    }
  }

// * Update lại giá trị cho answerDanhDauSanPham khi onchangexxx
  Future updateAnswerDanhDauSanPhamByMap(stt, values) async {
    Map<dynamic, dynamic> mapItem =
        Map<dynamic, dynamic>.from(answerDanhDauSanPham[stt] ?? {});
    values.forEach((key, value) {
      mapItem.update(key, (val) => value, ifAbsent: () => value);
    });
    updateAnswerDanhDauSanPham(stt, mapItem);
  }

  ///fieldName STT;
  Future updateAnswerDanhDauSanPham(stt, value) async {
    Map<dynamic, dynamic> map =
        Map<dynamic, dynamic>.from(answerDanhDauSanPham);
    map.update(stt, (val) => value, ifAbsent: () => value);
    answerDanhDauSanPham.value = map;
    answerDanhDauSanPham.refresh();
  }
//BEGIN::A3_2

//END::A3_2

//Begin::A6_1
  onChangeInputA6_1(
      String table, String tenCauHoi, String? fieldName, idValue, value) async {
    log('ON onChangeInputA6_1: $fieldName $value');
    try {
      // if (table == tablePhieuMauA61) {
      //   await updateToDbA6_1(table, fieldName ?? "", idValue, value);
      //   if (fieldName == columnPhieuMauA61A6_1_1 ||
      //       fieldName == columnPhieuMauA61A6_1_2) {
      //     var fieldNameTotalA6_1_3 = "A6_1_3";
      //     var fieldNamesA6_1_3 = ['A6_1_1', 'A6_1_2'];
      //     await updateToDbA6_1(table, fieldName!, idValue, value,
      //         fieldNames: fieldNamesA6_1_3,
      //         fieldNameTotal: fieldNameTotalA6_1_3);
      //   }
      // } else if (table == tablePhieuMauA68) {
      //   await updateToDbA6_8(table, fieldName ?? "", idValue, value);
      //   if (fieldName == columnPhieuMauA68A6_8_1 ||
      //       fieldName == columnPhieuMauA68A6_8_2) {
      //     var fieldNameTotalA6_8_3 = "A6_8_3";
      //     var fieldNamesA6_8_3 = ['A6_8_1', 'A6_8_2'];
      //     await updateToDbA6_8(table, fieldName!, idValue, value,
      //         fieldNames: fieldNamesA6_8_3,
      //         fieldNameTotal: fieldNameTotalA6_8_3);
      //   }
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

// updateToDbA6_1(String table, String fieldName, idValue, value,{List<String>? fieldNames,
//       String? fieldNameTotal,
//       String? maCauHoi}) async {
//     var res = await phieuMauA61Provider.isExistQuestion(currentIdCoSo!);
//     if (res) {
//       await phieuMauA61Provider.updateValueByIdCoso(
//           fieldName, value, currentIdCoSo, idValue!);
//     } else {
//       await insertNewRecordPhieuMauA6_1();
//     }
//     await getTablePhieuMauA61();
//   }
  updateToDbA6_1(String table, String fieldName, idValue, value,
      {List<String>? fieldNames,
      String? fieldNameTotal,
      String? maCauHoi}) async {
    // var res = await phieuMauA61Provider.isExistQuestion(currentIdCoSo!);
    // if (res) {
    //   await phieuMauA61Provider.updateValueByIdCoso(
    //       fieldName, value, currentIdCoSo, idValue!);
    //   if (fieldNameTotal != null &&
    //       fieldNameTotal != '' &&
    //       fieldNames != null &&
    //       fieldNames.isNotEmpty) {
    //     var total = await phieuMauA61Provider.totalIntByMaCauHoi(
    //         currentIdCoSo!, idValue, fieldNames, "*");
    //     await phieuMauA61Provider.updateValueByIdCoso(
    //         fieldNameTotal, total, currentIdCoSo, idValue!);
    //   }
    // } else {
    //   await insertNewRecordPhieuMauA6_1();
    // }
    // await getTablePhieuMauA61();
  }

  ///validate A5
  onValidateInputA5(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    if (maCauHoi == colPhieuMauTBSanPhamA5_1_1) {
    } else if (maCauHoi == colPhieuMauTBSanPhamA5_1_2) {
    } else if (maCauHoi == colPhieuMauTBSanPhamA5_2) {}
    // if (fieldName == columnPhieuMauSanPhamA5_1_1) {
    //   if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_1_2) {
    //   if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_2) {
    //   var validRes = onValidateInputA5_2(
    //       table,
    //       maCauHoi,
    //       fieldName,
    //       idValue,
    //       valueInput,
    //       minLen,
    //       maxLen,
    //       minValue,
    //       maxValue,
    //       loaiCauHoi,
    //       sttSanPham,
    //       typing);
    //   if (validRes != null && validRes != '') {
    //     return validRes;
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_3) {
    //   var hasA5_3Cap1BCDE = getValueDanhDauSP(ddSpIsCap1BCDE, stt: sttSanPham);
    //   if (hasA5_3Cap1BCDE) {
    //     if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_3_1) {
    //   var hasA5_3Cap1BCDE = getValueDanhDauSP(ddSpIsCap1BCDE, stt: sttSanPham);
    //   if (hasA5_3Cap1BCDE) {
    //     if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_4) {
    //   var hasA5_3Cap1BCDE = getValueDanhDauSP(ddSpIsCap1BCDE, stt: sttSanPham);
    //   if (hasA5_3Cap1BCDE) {
    //     if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_5) {
    //   var hasA5_5Cap1GL = getValueDanhDauSP(ddSpIsCap1GL, stt: sttSanPham);
    //   if (hasA5_5Cap1GL) {
    //     var validRes = onValidateInputA5_5(
    //         table,
    //         maCauHoi,
    //         fieldName,
    //         idValue,
    //         valueInput,
    //         minLen,
    //         maxLen,
    //         minValue,
    //         maxValue,
    //         loaiCauHoi,
    //         sttSanPham,
    //         typing);
    //     if (validRes != null && validRes != '') {
    //       return validRes;
    //     }
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_6) {
    //   var hasA5_6Cap2_56 = getValueDanhDauSP(ddSpIsCap2_56, stt: sttSanPham);
    //   if (hasA5_6Cap2_56) {
    //     if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    // }
    // if (fieldName == columnPhieuMauSanPhamA5_6_1) {
    //   var hasA5_6Cap2_56 = getValueDanhDauSP(ddSpIsCap2_56, stt: sttSanPham);
    //   if (hasA5_6Cap2_56) {
    //     var validRes = onValidateInputA5_6_1(
    //         table,
    //         maCauHoi,
    //         fieldName,
    //         idValue,
    //         valueInput,
    //         minLen,
    //         maxLen,
    //         minValue,
    //         maxValue,
    //         loaiCauHoi,
    //         sttSanPham,
    //         typing);
    //     if (validRes != null && validRes != '') {
    //       return validRes;
    //     }
    //   }
    // }

    return null;
  }

  onValidateMaVcpaCap5(String maVcpaCap5, bool typing) {
    if (maVcpaCap5 == null || maVcpaCap5 == '' || maVcpaCap5 == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
    //- Chỉ có 1 ngành san phẩm và Mã VCPA cấp 2=68 và  C1.1=1|2|3|4|5;

    //- Chỉ có 1 hoặc nhiều ngành sản phẩm nhưng có mã ngành san phẩm và Mã ngành sản phẩm >=47811
    //và Mã ngành <=47899 mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định;

    //- Mã ngành=46492. Dịch vụ bán buôn dược phẩm và dụng cụ y tế hoặc mã ngành=47721.
    //Bán lẻ dược phẩm, dụng cụ y tế trong các cửa hàng chuyên doanh & C1.4=2|6

    // (Mã ngành sản phẩm>=86101 và Mã ngành<=86990.
    //Hoạt động y tế) hoặc (Mã ngành= 96310. Dịch vụ cắt tóc gội đầu)  hoặc ( mã ngành>=71101
    //và mã ngành<=71109. Hoạt động kiến trúc, kiểm tra và phân tích kỹ thuật) & C2.1_Tổng số =1 & C1.3.5=1. Chưa qua dào tạo?

    return null;
  }

  onValidateInputA5_2(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    // if (fieldName == columnPhieuMauSanPhamA5_2) {
    //   if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var tblPhieuCT;
    //   // tblPhieuTonGiao.value.toJson();
    //   if (typing == false) {
    //     tblPhieuCT = tblPhieuMau.value.toJson();
    //   } else {
    //     tblPhieuCT = answerTblPhieuMau;
    //   }
    //   double a5_2Value =
    //       AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));

    //   var a4_2Value = tblPhieuCT[columnPhieuMauA4_2] != null
    //       ? AppUtils.convertStringToDouble(
    //           tblPhieuCT[columnPhieuMauA4_2].toString())
    //       : 0;
    //   // if (a4_2Value != null) {
    //   //   double a4_2Val = AppUtils.convertStringToDouble(a4_2Value);
    //   if (a5_2Value > a4_2Value) {
    //     return 'Doanh thu câu 5.2 ($a5_2Value) phải <= doanh thu ở câu 4.2 ($a4_2Value). Vui lòng kiểm tra lại.';
    //   }
    //   // }
    //   return null;
    // }
  }

  onValidateInputA5_5(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    // if (fieldName == columnPhieuMauSanPhamA5_5) {
    //   if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   double a5_5Value =
    //       AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //   var a5_2Value = getValueSanPham(
    //       tablePhieuMauSanPham, columnPhieuMauSanPhamA5_2, idValue);
    //   if (a5_2Value != null) {
    //     double a5_2Val = AppUtils.convertStringToDouble(a5_2Value);
    //     if (a5_5Value > a5_2Val) {
    //       return 'Doanh thu câu 5.5 ($a5_5Value) phải <= doanh thu ở câu 5.2 ($a5_2Val). Vui lòng kiểm tra lại.';
    //     }
    //   }
    //   return null;
    // }
  }

  onValidateInputA5_6_1(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    // if (fieldName == columnPhieuMauSanPhamA5_6_1) {
    //   // if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //   //   return 'Vui lòng nhập giá trị.';
    //   // }
    //   double a5_6_1Value = AppUtils.convertStringToDouble(valueInput);
    //   var a5_6Value = getValueSanPham(
    //       tablePhieuMauSanPham, columnPhieuMauSanPhamA5_6, idValue);
    //   if (a5_6Value == 1) {
    //     if (valueInput == null || valueInput == '' || valueInput == 'null') {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    //   if (a5_6Value == 2) {
    //     return null;
    //   }
    //   return null;
    // }
  }

  ///Validate "5T. TỔNG DOANH THU CỦA CÁC NHÓM SẢN PHẨM NĂM 2024 (TỔNG CÁC CÂU A5.2 * CÂU A4.1)
  onValidateInputA5T(String table, String maCauHoi, bool typing) {
    // if (fieldName == columnPhieuMauSanPhamA5_7) {
    // if (typing == false) {
    //   // var a4_2Value =
    //   //     getValueByFieldNameFromDB(tablePhieuMau, columnPhieuMauA4_2);
    //   var a4_0Value =
    //       getValueByFieldNameFromDB(tablePhieuMau, columnPhieuMauA4_0);
    //   var a5_7Value =
    //       getValueByFieldNameFromDB(tablePhieuMau, columnPhieuMauA5_7);

    //   double a4_2Val = 0.0;
    //   double a5_7Val = 0.0;

    //   if (a4_0Value != null) {
    //     a4_0Value = AppUtils.convertStringToDouble(a4_0Value);
    //   }
    //   if (a5_7Value != null) {
    //     a5_7Val = AppUtils.convertStringToDouble(a5_7Value);
    //   }
    //   if (a5_7Val > a4_0Value) {
    //     return 'Tổng doanh thu câu 5T ($a5_7Val) phải <= Tổng doanh thu ở câu 4T ($a4_0Value). Vui lòng kiểm tra lại.';
    //   }
    // }
    // return null;
  }

  ///
  onValidateInputA6_1(String table, String maCauHoi, String? fieldName, idValue,
      String? valueInput, minLen, maxLen, minValue, maxValue, int loaiCauHoi) {
    return ValidateQuestionNo07.onValidateInputA6_1(table, maCauHoi, fieldName,
        idValue, valueInput, minLen, maxLen, minValue, maxValue, loaiCauHoi);
  }

  onValidateInputA6_8(String table, String maCauHoi, String? fieldName, idValue,
      String? valueInput, minLen, maxLen, minValue, maxValue, int loaiCauHoi) {
    return ValidateQuestionNo07.onValidateInputA6_8(table, maCauHoi, fieldName,
        idValue, valueInput, minLen, maxLen, minValue, maxValue, loaiCauHoi);
  }

  onValidateInput(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? valueInput) {
    var table = question.bangDuLieu;
    var maCauHoi = question.maCauHoi;
    var minValue = chiTieuCot!.giaTriNN;
    var maxValue = chiTieuCot.giaTriLN;
  }

  ///
  addNewRowPhieuMauAA6_1(String table, String maCauHoi) async {
    // if (table == tablePhieuMauA61) {
    //   await insertNewRecordPhieuMauA6_1();
    //   await getTablePhieuMauA61();
    // } else if (table == tablePhieuMauA68) {
    //   await insertNewRecordPhieuMauA6_8();
    //   await getTablePhieuMauA68();
    // }
  }

  ///
  ///A6_1
  ///
  // Future<TablePhieuMauA61> createPhieuMauA61Item() async {
  //   var maxStt = await phieuMauA61Provider.getMaxSTTByIdCoso(currentIdCoSo!);
  //   maxStt = maxStt + 1;
  //   var table04C8 = TablePhieuMauA61(
  //       iDCoSo: currentIdCoSo, sTT: maxStt, maDTV: AppPref.uid);
  //   return table04C8;
  // }

  ///
  // Future insertNewRecordPhieuMauA6_1({bool? isInsert = true}) async {
  //   var tableA61 = await createPhieuMauA61Item();

  //   List<TablePhieuMauA61> tablePhieuMauA6_1s = [];
  //   tablePhieuMauA6_1s.add(tableA61);
  //   await phieuMauA61Provider.insert(
  //       tablePhieuMauA6_1s, AppPref.dateTimeSaveDB!);
  // }

  Future deleteA61Item(
      String table, String maCauHoi, dynamic recordValue) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await excueteDeleteA61Item(table, maCauHoi, recordValue);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: 'dialog_content_warning_delete'.trParams({'param': 'sản phẩm'}),
    ));
  }

  Future excueteDeleteA61Item(
      String table, String maCauHoi, dynamic recordValue) async {
    // if (table == tablePhieuMauA61) {
    //   TablePhieuMauA61 record = recordValue;
    //   if (record.id != null) {
    //     await phieuMauA61Provider.deleteById(record.id!);
    //     await getTablePhieuMauA61();
    //   }
    // } else if (table == tablePhieuMauA68) {
    //   TablePhieuMauA68 record = recordValue;
    //   if (record.id != null) {
    //     await phieuMauA68Provider.deleteById(record.id!);
    //     await getTablePhieuMauA68();
    //   }
    // }
  }

  checkExistA6_1() async {
    //return await phieuMauA61Provider.isExistQuestion(currentIdCoSo!);
    return false;
  }

  ///END:: A6_1 event
  /***********/
  ///A6_8
  ///
  updateToDbA6_8(String table, String fieldName, idValue, value,
      {List<String>? fieldNames,
      String? fieldNameTotal,
      String? maCauHoi}) async {
    // var res = await phieuMauA68Provider.isExistQuestion(currentIdCoSo!);
    // if (res) {
    //   await phieuMauA68Provider.updateValueByIdCoso(
    //       fieldName, value, currentIdCoSo, idValue!);
    //   if (fieldNameTotal != null &&
    //       fieldNameTotal != '' &&
    //       fieldNames != null &&
    //       fieldNames.isNotEmpty) {
    //     var total = await phieuMauA68Provider.totalDoubleByMaCauHoi(
    //         currentIdCoSo!, idValue, fieldNames, "*");
    //     var totalRounded = AppUtils.roundDouble(total, 2);
    //     await phieuMauA68Provider.updateValueByIdCoso(
    //         fieldNameTotal, totalRounded, currentIdCoSo, idValue!);
    //   }
    // } else {
    //   await insertNewRecordPhieuMauA6_8();
    // }
    // await getTablePhieuMauA68();
  }

  ///
  // Future<TablePhieuMauA68> createPhieuMauA68Item() async {
  //   var maxStt = await phieuMauA68Provider.getMaxSTTByIdCoso(currentIdCoSo!);
  //   maxStt = maxStt + 1;
  //   var tableA68 = TablePhieuMauA68(
  //       iDCoSo: currentIdCoSo, sTT: maxStt, maDTV: AppPref.uid);
  //   return tableA68;
  // }

  // ///
  // Future insertNewRecordPhieuMauA6_8({bool? isInsert = true}) async {
  //   var tableA68 = await createPhieuMauA68Item();

  //   List<TablePhieuMauA68> tablePhieuMauA6_8s = [];
  //   tablePhieuMauA6_8s.add(tableA68);
  //   await phieuMauA68Provider.insert(
  //       tablePhieuMauA6_8s, AppPref.dateTimeSaveDB!);
  // }

  Future deleteA68Item(
      String table, String maCauHoi, dynamic recordValue) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await excueteDeleteA68Item(table, maCauHoi, recordValue);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: 'dialog_content_warning_delete'
          .trParams({'param': 'loại phương tiện'}),
    ));
  }

  Future excueteDeleteA68Item(
      String table, String maCauHoi, dynamic recordValue) async {
    // if (table == tablePhieuMauA68) {
    //   TablePhieuMauA68 record = recordValue;
    //   if (record.id != null) {
    //     await phieuMauA68Provider.deleteById(record.id!);
    //     await getTablePhieuMauA68();
    //   }
    // }
  }

  checkExistA6_8() async {
    // return await phieuMauA68Provider.isExistQuestion(currentIdCoSo!);
  }

  ///END:: A6_8 event
/*******/

/*******/

  ///BEGIN::EVEN SELECT INT
  onSelect(String table, String? maCauHoi, String? fieldName, value) {
    log('ON CHANGE $maCauHoi: $fieldName $value');

    try {
      // updateAnswerToDB(table, fieldName ?? "", value);
      // updateAnswerTblPhieuMau(fieldName, value,table);
      // if (maCauHoi == columnPhieuMauA4_4) {
      //   if (!value.toString().contains("1")) {
      //     updateAnswerToDB(table, "A4_4_1", null);
      //     updateAnswerTblPhieuMau("A4_4_1", null,table);
      //   } else if (!value.toString().contains("2")) {
      //     updateAnswerToDB(table, "A4_4_2", null);
      //     updateAnswerTblPhieuMau("A4_4_2", null,table);
      //   }
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  onSelectDm(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, value, dmItem) {
    log('ON CHANGE onSelectDm: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblPhieuMau(fieldName, value, table);
      // if (question.bangChiTieu != null && question.bangChiTieu != '') {
      //   var hasGhiRo = hasDanhMucGhiRoByTenDm(question.bangChiTieu!);
      //   if (hasGhiRo != null && hasGhiRo == true) {
      //     if (value != 17 && fieldName == maCauHoi) {
      //       String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
      //       updateAnswerToDB(table, fieldNameGhiRo, null);
      //       updateAnswerTblPhieuMau(fieldNameGhiRo, null,table);
      //     }
      //   }
      // }
      if (maCauHoi == colPhieuMauTBA1_1) {
        if (value != 5) {
          String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
          updateAnswerToDB(table, fieldNameGhiRo, null);
          updateAnswerTblPhieuMau(fieldNameGhiRo, null, table);
        }
      }
      if (maCauHoi == colPhieuMauTBA1_2) {
        if (value != 1) {
          updateAnswerToDB(table, colPhieuMauTBA4_3, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA4_3, null, table);
        }
      }
      if (maCauHoi == colPhieuMauTBA1_5) {
        if (value != 1) {
          updateAnswerToDB(table, colPhieuMauTBA1_5_1, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA1_5_1, null, table);
        }
      }
      // if (maCauHoi == columnPhieuMauA1_4) {
      //   if (value == 2) {
      //     var a1_3Value = answerTblPhieuMau[columnPhieuMauA1_3];
      //     if (a1_3Value != null) {
      //       int a1_3Val = int.parse(a1_3Value.toString());
      //       if (a1_3Val == 2 || a1_3Val == 3) {
      //         String msgText = a1_3Val == 2
      //             ? 'Câu 1.3 đã chọn chỉ tiêu 2 - Tại siêu thị, Trung tâm thương mại'
      //             : 'Câu 1.3 đã chọn chỉ tiêu 3 - Tại chợ';
      //         updateAnswerToDB(table, columnPhieuMauA1_4, null);
      //         updateAnswerTblPhieuMau(columnPhieuMauA1_4, null,table);
      //         return showError(
      //             '$msgText nên Câu 1.4 không thể chọn chỉ tiêu 2 - Địa điểm thuộc sở hữu của chủ cơ sở.');
      //       }
      //     }

      //     ///Bổ sung logic A1.4=2 và A4.6>0 19/02/2025
      //     var a4_6Value = answerTblPhieuMau[columnPhieuMauA4_6];
      //     if (a4_6Value > 0) {
      //       updateAnswerToDB(table, columnPhieuMauA4_6,
      //           null); //Nên update null hay là 0? Nếu update null thì phải insert vào bảng xacnhanlogic câu A4.6 phải nhập giá trị
      //       updateAnswerTblPhieuMau(columnPhieuMauA4_6,
      //           null,table); //Nên update null hay là 0? Nếu update null thì phải insert vào bảng xacnhanlogic câu A4.6 phải nhập giá trị
      //       //Câu 1.4 Địa điểm thuộc sở hữu của chủ cơ sở nên câu 4.6 Tiền thuê địa điểm SXKD phải = 0
      //       // insertUpdateXacNhanLogic(manHinh, idCoSoIdHo, maDoiTuongDT, isLogic, isEnableMenuItem, noiDungLogic, maTrangThaiDT)
      //     }
      //   }
      // }

      // if (maCauHoi == columnPhieuMauA4_3) {
      //   if (value != 1) {
      //     updateAnswerToDB(table, "A4_4", null);
      //     updateAnswerTblPhieuMau("A4_4", null,table);
      //     updateAnswerToDB(table, "A4_4_1", null);
      //     updateAnswerTblPhieuMau("A4_4_1", null,table);
      //     updateAnswerToDB(table, "A4_4_2", null);
      //     updateAnswerTblPhieuMau("A4_4_2", null,table);
      //   }
      // }
      // if (maCauHoi == "A4_5") {
      //   for (var i = 1; i <= 4; i++) {
      //     String fName = "A4_5_${i}_1";
      //     String fName2 = "A4_5_${i}_2";
      //     if (fieldName == fName) {
      //       if (value != 1) {
      //         updateAnswerToDB(table, fName2, null);
      //         updateAnswerTblPhieuMau(fName2, null);
      //       }
      //       break;
      //     }
      //   }
      // }
      // if (maCauHoi == "A4_7") {
      //   for (var i = 1; i <= 8; i++) {
      //     String fName = "A4_7_${i}_1";
      //     String fName2 = "A4_7_${i}_2";
      //     if (fieldName == fName) {
      //       if (value != 1) {
      //         updateAnswerToDB(table, fName2, null);
      //         updateAnswerTblPhieuMau(fName2, null,table);
      //         // var fieldNameTotalA4_7_0 = "A4_7_0";
      //         // var fieldNamesA4_7_0 = [
      //         //   'A4_7_1_2',
      //         //   'A4_7_2_2',
      //         //   'A4_7_3_2',
      //         //   'A4_7_4_2',
      //         //   'A4_7_5_2',
      //         //   'A4_7_6_2',
      //         //   'A4_7_7_2',
      //         //   'A4_7_8_2'
      //         // ];
      //         // updateAnswerDongCotToDB(table, fieldName!, value,
      //         //     fieldNames: fieldNamesA4_7_0,
      //         //     fieldNameTotal: fieldNameTotalA4_7_0,
      //         //     maCauHoi: maCauHoi);
      //       }
      //       break;
      //     }
      //   }
      // }
      // if (maCauHoi == "A8_1") {
      //   for (var i = 1; i <= 11; i++) {
      //     String fName = "A8_1_${i}_1";
      //     String fName2 = "A8_1_${i}_2";
      //     String fName3 = "A8_1_${i}_3";
      //     if (fieldName == fName) {
      //       if (value != 1) {
      //         updateAnswerToDB(table, fName2, null);
      //         updateAnswerTblPhieuMau(fName2, null,table);
      //         updateAnswerToDB(table, fName3, null);
      //         updateAnswerTblPhieuMau(fName3, null,table);
      //       }
      //       break;
      //     }
      //   }
      //   for (var i = 1; i <= 4; i++) {
      //     String fName = "A8_1_1_${i}_1";
      //     String fName2 = "A8_1_1_${i}_2";
      //     String fName3 = "A8_1_1_${i}_3";
      //     if (fieldName == fName) {
      //       if (value != 1) {
      //         updateAnswerToDB(table, fName2, null);
      //         updateAnswerTblPhieuMau(fName2, null,table);
      //         updateAnswerToDB(table, fName3, null);
      //         updateAnswerTblPhieuMau(fName3, null,table);
      //       }
      //       break;
      //     }
      //   }
      // }
      // if (maCauHoi == columnPhieuMauA9_1) {
      //   if (value != 1) {
      //     updateAnswerToDB(table, "A9_2", null);
      //     updateAnswerTblPhieuMau("A9_2", null,table);
      //   }
      // }
      // if (maCauHoi == "A9_4" && fieldName == columnPhieuMauA9_4_1) {
      //   if (value != 1) {
      //     updateAnswerToDB(table, "A9_5", null);
      //     updateAnswerTblPhieuMau("A9_5", null);
      //   }
      // }
      // if (maCauHoi == "A9_4" && fieldName == columnPhieuMauA9_4_2) {
      //   if (value != 1) {
      //     updateAnswerToDB(table, "A9_8", null);
      //     updateAnswerTblPhieuMau("A9_8", null,table);
      //   }
      // }
      // if (maCauHoi == columnPhieuMauA9_7) {
      //   if (value != 1) {
      //     updateAnswerToDB(table, "A9_7_1", null);
      //     updateAnswerTblPhieuMau("A9_7_1", null,table);
      //     //Bỏ vì 9.8 luôn luôn hiển thị và phải luôn có giá trị vì 9.7 có chọn =1 hay =2 thì 9.8 luôn luôn hiện thị
      //     // updateAnswerToDB(table, "A9_8", null);
      //     // updateAnswerTblPhieuMau("A9_8", null,table);
      //   }
      // }
      // if (maCauHoi == columnPhieuMauA9_9) {
      //   if (value != 1) {
      //     updateAnswerToDB(table, "A9_10", null);
      //     updateAnswerTblPhieuMau("A9_10", null,table);
      //     // onNext();
      //   }
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  getDanhMucByTenDm(String tenDanhMuc) {
    // if (tenDanhMuc == tableDmCap) {
    //   return tblDmCap;
    // } else
    if (tenDanhMuc == tableCTDmDiaDiemSXKD) {
      return tblDmDiaDiemSXKD;
    } else if (tenDanhMuc == tableCTDmHoatDongLogistic) {
      return tblDmHoatDongLogistic;
    } else if (tenDanhMuc == tableCTDmLinhVuc) {
      return tblDmLinhVuc;
    } else if (tenDanhMuc == tableCTDmLoaiDiaDiem) {
      return tblDmLoaiDiaDiem;
    } else if (tenDanhMuc == tableDmQuocTich) {
      return tblDmQuocTich;
    } else if (tenDanhMuc == tableCTDmTinhTrangDKKD) {
      return tblDmTinhTrangDKKD;
    } else if (tenDanhMuc == tableCTDmTrinhDoCm) {
      return tblDmTrinhDoChuyenMon;
    } else if (tenDanhMuc == tableDmGioiTinh) {
      return tblDmGioiTinh;
    } else if (tenDanhMuc == tableDmCoKhong) {
      return tblDmCoKhong;
    }
    return null;
  }

  parseDmLogisticToChiTieuModel() {
    return TableCTDmHoatDongLogistic.toListChiTieuIntModel(
        tblDmHoatDongLogistic);
  }

  hasDanhMucGhiRoByTenDm(String tenDanhMuc) {
    if (tenDanhMuc == tableDiaBanCoSoSXKD) {
      return true;
    }
    return false;
  }

  onChangeGhiRoDm(QuestionCommonModel question, String? value, dmItem,
      {String? fieldNameGhiRo}) {
    log('onChangeGhiRoDm Mã câu hỏi ${question.maCauHoi} ${question.bangChiTieu}');
    String fieldName = '${question.maCauHoi}_GhiRo';
    if (question.maCauHoi == "A1_7" || question.maCauHoi == "A7_1") {
      fieldName = fieldNameGhiRo!;
    }
    updateAnswerToDB(question.bangDuLieu!, fieldName, value);
    updateAnswerTblPhieuMau(fieldName, value, question.bangDuLieu!);
  }

  Future<Iterable<TableDmDanToc?>> onSearchDmDanToc(String search) async {
    keywordDanToc.value = search;
    if (search.length >= 1) {
      List<Map> danTocItems = await dmDanTocProvider.searchDmDanToc(search);
      var result = danTocItems.map((e) => TableDmDanToc.fromJson(e));
      tblDmDanTocSearch.value = result.toList();
      log('SEARCH RESULT: ${danTocItems.length}');
      //  await Future.delayed(const Duration(milliseconds: 1000));
      var res = tblDmDanTocSearch
          .where((x) => (x.maDanToc == search || x.tenDanToc == search))
          .firstOrNull;
      if (res != null) {}
      return result;
    }
    return [];
  }

  onValidateInputDanToc(String table, String maCauHoi, String? fieldName,
      String? valueInput, int? loaiCauHoi) {
    if (valueInput == null || valueInput == '' || valueInput == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
    return null;
  }

  onChangeInputDanToc(
      String table, String maCauHoi, String? fieldName, value) async {
    log('ON onChangeInputDanToc: $fieldName $value');
    try {
      if (table == tablePhieuMauTB) {
        String maDanToc = '';
        String tenDanToc = '';
        if (value is TableDmDanToc) {
          TableDmDanToc valueInput = value;
          if (valueInput != null) {
            maDanToc = valueInput.maDanToc!;
            tenDanToc = valueInput.tenDanToc!;
          }
        } else if (value is String) {
          maDanToc = value;
          tenDanToc = value;
        }
        updateAnswerToDB(table, fieldName!, maDanToc);
        updateAnswerTblPhieuMau(fieldName, maDanToc, table);
        updateAnswerTblPhieuMau('${fieldName}_tendantoc', tenDanToc, table);
        log('ON onChangeInputDanToc ĐÃ cập nhật mã dan toc');
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  getValueDanTocByFieldName(String table, String fieldName,
      {String? valueDataType}) {
    if (fieldName == null || fieldName == '') return null;
    var maDanToc = answerTblPhieuMau['${fieldName}_tendantoc'];
    //var maDanToc = answerTblPhieuMau['$fieldName'];
    if (maDanToc == null || maDanToc == '') {
      return '';
    }
    return maDanToc;
  }

  ///END: SELECT INT
/*******/

  ///
  onChangeYesNoQuestion(
    String table,
    String? maCauHoi,
    String? fieldName,
    value,
  ) async {
    log('ON onChangeYesNoQuestion: $fieldName $value');

    try {
      await updateAnswerToDB(table, fieldName ?? "", value);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  getValueDm(QuestionCommonModel question) {
    var res = answerTblPhieuMau[question.maCauHoi];
    return res;
  }

  getValueDmByFieldName(String fieldName) {
    var res = answerTblPhieuMau[fieldName];
    return res;
  }

/*******/
  ///BEGIN::Chi tieu dong cot
  ///
  getFieldNameByMaCauChiTieuDongCot(
      ChiTieuModel chiTieuCot, ChiTieuDongModel chiTieuDong) {
    var fieldName =
        '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}';
    if (chiTieuDong.maCauHoi == "A8_1") {
      if (chiTieuDong.maSo == '1.1' ||
          chiTieuDong.maSo == '1.2' ||
          chiTieuDong.maSo == '1.3' ||
          chiTieuDong.maSo == '1.4' ||
          chiTieuDong.maSo == '3.1' ||
          chiTieuDong.maSo == '5.1') {
        fieldName =
            '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!.replaceAll('.', '_')}_${chiTieuCot.maChiTieu}';
      }
    }
    return fieldName;
  }

  getFieldNameByMaCauChiTieuDongCotA9_4(ChiTieuDongModel chiTieuDong) {
    var fieldName = '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo}';

    return fieldName;
  }

  ///Chỉ tiêu con của câu 8.1 mục 1.Điện
  // getFieldNameByMaCauChiTieuDongCot2(
  //     ChiTieuModel chiTieuCot, ChiTieuDongModel chiTieuDong) {
  //   var fieldName =
  //       '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}';
  //   if (chiTieuDong.maSo == '1.1' ||
  //       chiTieuDong.maSo == '1.2' ||
  //       chiTieuDong.maSo == '1.3' ||
  //       chiTieuDong.maSo == '1.4' ||
  //       chiTieuDong.maSo == '3.1' ||
  //       chiTieuDong.maSo == '5.1') {
  //     fieldName =
  //         '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!.replaceAll('.', '_')}_${chiTieuCot.maChiTieu}';
  //   }

  //   return fieldName;
  // }

  getFieldNameByMaCauHoiMaSo(
      ChiTieuModel chiTieuCot, ChiTieuDongModel chiTieuDongModel) {
    var fieldName = '${chiTieuDongModel.maCauHoi!}_${chiTieuDongModel.maSo}';
    return fieldName;
  }

  onChangeChiTieuDongGhiRo(
      QuestionCommonModel question, String? value, fieldName) {
    log('onChangeChiTienDongGhiRo Mã câu hỏi ${question.maCauHoi} ${question.bangChiTieu}');

    updateAnswerToDB(question.bangDuLieu!, fieldName, value);
    updateAnswerTblPhieuMau(fieldName, value, question.bangDuLieu!);
  }

  onChangeInputChiTieuDongCot(
      String table, String? maCauHoi, String? fieldName, value,
      {QuestionCommonModel? question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong}) async {
    log('ON onChangeInputChiTieuDongCot: $fieldName $value');

    try {
      if (table == tablePhieuMauTB) {
        if (maCauHoi == "A3_1") {
          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNameA3_1T,
              fieldNameTotal: colPhieuMauTBA3_1T,
              maCauHoi: maCauHoi);

          var fieldNamesA3T = [colPhieuMauTBA3_1T, colPhieuMauTBA3_2];

          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNamesA3T,
              fieldNameTotal: colPhieuMauTBA3T,
              maCauHoi: maCauHoi);
        }
        //   // else if (maCauHoi == "A4_7") {
        //   //   var fieldNameTotalA4_7_0 = "A4_7_0";
        //   //   var fieldNamesA4_7_0 = [
        //   //     'A4_7_1_2',
        //   //     'A4_7_2_2',
        //   //     'A4_7_3_2',
        //   //     'A4_7_4_2',
        //   //     'A4_7_5_2',
        //   //     'A4_7_6_2',
        //   //     'A4_7_7_2',
        //   //     'A4_7_8_2'
        //   //   ];
        //   //   await updateAnswerDongCotToDB(table, fieldName!, value,
        //   //       fieldNames: fieldNamesA4_7_0,
        //   //       fieldNameTotal: fieldNameTotalA4_7_0,
        //   //       maCauHoi: maCauHoi);
        //   // }
        //   if (maCauHoi == "A7_1") {
        //     if (a7_1FieldWarning.contains(fieldName)) {
        //       await warningA7_1_X3SoPhongTangMoi(chiTieuDong!.maSo!);
        //     }
        //   }
        //   List<String> fieldNames = [];
        //   String fieldNameTotal = "";
        //   await updateAnswerDongCotToDB(table, fieldName!, value,
        //       fieldNames: fieldNames,
        //       fieldNameTotal: fieldNameTotal,
        //       maCauHoi: maCauHoi);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  updateAnswerDongCotToDB(String table, String fieldName, value,
      {List<String>? fieldNames,
      String? fieldNameTotal,
      String? maCauHoi}) async {
    if (fieldName == '') return;
    if (table == tablePhieuMauTB) {
      await phieuMauTBProvider.updateValue(fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
      if (fieldNameTotal != null &&
          fieldNameTotal != '' &&
          fieldNames != null &&
          fieldNames.isNotEmpty) {
        if (maCauHoi == "A3_1" || maCauHoi == "A3_2") {
          var total = await phieuMauTBProvider.totalDoubleByMaCauHoi(
              currentIdCoSo!, fieldNames!);
          await phieuMauTBProvider.updateValue(
              fieldNameTotal!, total, currentIdCoSo);
          await updateAnswerTblPhieuMau(fieldNameTotal, total, table);
        } else if (maCauHoi == colPhieuMauTBA4_1 ||
            maCauHoi == colPhieuMauTBA4_2) {
          var total = await phieuMauTBProvider.totalSubtractDoubleByMaCauHoi(
              currentIdCoSo!, fieldNames!);
          await phieuMauTBProvider.updateValue(
              fieldNameTotal!, total, currentIdCoSo);
          await updateAnswerTblPhieuMau(fieldNameTotal, total, table);
        }
        // if (maCauHoi == "A6_3" || maCauHoi == "A6_4") {
        //   var total = await phieuMauProvider.totalSubtractIntByMaCauHoi(
        //       currentIdCoSo!, fieldNames!);
        //   await phieuMauProvider.updateValue(
        //       fieldNameTotal!, total, currentIdCoSo);
        //   await updateAnswerTblPhieuMau(fieldNameTotal, total);
        // } else if (maCauHoi == "A4_1" ||
        //     maCauHoi == "A4_2" ||
        //     maCauHoi == "A6_10" ||
        //     maCauHoi == "A6_11" ||
        //     maCauHoi == "A6_12") {
        //   var total = await phieuMauProvider.totalSubtractDoubleByMaCauHoi(
        //       currentIdCoSo!, fieldNames!);
        //   await phieuMauProvider.updateValue(
        //       fieldNameTotal!, total, currentIdCoSo);
        //   await updateAnswerTblPhieuMau(fieldNameTotal, total);
        // } else if (maCauHoi == "A6_5") {
        //   var total = await phieuMauProvider.totalSubtractDoubleByMaCauHoi(
        //       currentIdCoSo!, fieldNames!);
        //   var totalRounded = AppUtils.roundDouble(total, 2);
        //   await phieuMauProvider.updateValue(
        //       fieldNameTotal!, totalRounded, currentIdCoSo);
        //   await updateAnswerTblPhieuMau(fieldNameTotal, totalRounded);
        // } else if (maCauHoi == "A7_6" ||
        //     maCauHoi == "A7_7" ||
        //     maCauHoi == "A7_6_1" ||
        //     maCauHoi == "A7_7_1") {
        //   var total = await phieuMauProvider.totalIntByMaCauHoi(
        //       currentIdCoSo!, fieldNames!);
        //   await phieuMauProvider.updateValue(
        //       fieldNameTotal!, total, currentIdCoSo);
        //   await updateAnswerTblPhieuMau(fieldNameTotal, total);
        // } else {
        //   var total = await phieuMauTBProvider.totalDoubleByMaCauHoi(
        //       currentIdCoSo!, fieldNames!);
        //   await phieuMauTBProvider.updateValue(
        //       fieldNameTotal!, total, currentIdCoSo);
        //   await updateAnswerTblPhieuMau(fieldNameTotal, total);
        // }
      }
      //   if (maCauHoi == "A7_9") {
      //     await tinhCapNhatA8_M_A9_M_A10_M(value);

      //     var a7_12Value = getValueDmByFieldName('A7_12') ?? 0;
      //     await tinhUpdateA10M(a7_12Value);
      //     // var totalA5_2 = await phieuMauSanPhamProvider.totalA5_2ByMaVcpaCap2(
      //     //     currentIdCoSo!, vcpaCap2PhanVII);
      //     // //Tinh cho cau A7_10
      //     // var totalA7_10 = (value * totalA5_2) / 100;
      //     // if (totalA7_10 > 0) {
      //     //   totalA7_10 = AppUtils.roundDouble(totalA7_10, 2);
      //     // }

      //     // var fieldNameTotalA7_10 = "A7_10";
      //     // await phieuMauProvider.updateValue(
      //     //     fieldNameTotalA7_10!, totalA7_10, currentIdCoSo);
      //     // await updateAnswerTblPhieuMau(fieldNameTotalA7_10, totalA7_10);
      //     // //Tính cho câu A7_11
      //     // var totalA7_11 = totalA5_2 - totalA7_10;

      //     // if (totalA7_11 > 0) {
      //     //   totalA7_11 = AppUtils.roundDouble(totalA7_11, 2);
      //     // }
      //     // var fieldNameTotalA7_11 = "A7_11";
      //     // await phieuMauProvider.updateValue(
      //     //     fieldNameTotalA7_11!, totalA7_11, currentIdCoSo);
      //     // await updateAnswerTblPhieuMau(fieldNameTotalA7_11, totalA7_11);
      //   }
      //   if (maCauHoi == "A7_12") {
      //     await tinhUpdateA10M(value);
      //     // var a7_10Value = getValueDmByFieldName('A7_10');
      //     // if (a7_10Value >= 0 && value > 0) {
      //     //   var a7_13 = a7_10Value / value;
      //     //   await phieuMauProvider.updateValue('A7_13', a7_13, currentIdCoSo);
      //     //   await updateAnswerTblPhieuMau('A7_13', a7_13);
      //     // }
      //   }
      // } else {
      //   snackBar("dialog_title_warning".tr, "data_table_undefine".tr);
    }
  }

  tinhCapNhatA6_13_A6_14() async {
    var fieldNameTotalA6_14 = "A6_14";
    var fieldNamesA6_14 = ['A6_12', 'A6_13'];

    // var total = await phieuMauProvider.totalSubtractDoubleByMaCauHoi(
    //     currentIdCoSo!, fieldNamesA6_14!);
    // await phieuMauProvider.updateValue(
    //     fieldNameTotalA6_14, total, currentIdCoSo);
    // await updateAnswerTblPhieuMau(fieldNameTotalA6_14, total);
  }

  ///A8_M, A9_M, A10_M
  ///A8_M <=> A7_10
  ///A9_M <=> A7_11
  ///A10_M <=> A7_13
  ///tinhCapNhatA8_M_A9_M_A10_M
  tinhCapNhatA8_M_A9_M_A10_M(a8MValue) async {
    var totalA5_2 = await phieuMauTBSanPhamProvider.totalA5_2ByMaVcpaCap2(
        currentIdCoSo!, vcpaCap2PhanVII);
    //Tinh cho cau A8 (cũ A7_10)
    //8. DOANH THU KHÁCH NGỦ QUA ĐÊM (=CÂU 5.2 CỦA PHIẾU TB x Câu 5)/100)
    var totalA8M = (a8MValue * totalA5_2) / 100;
    if (totalA8M > 0) {
      totalA8M = AppUtils.roundDouble(totalA8M, 2);
    }

    // colPhieuNganhLTA8_M <=> var fieldNameTotalA7_10 = "A7_10";
    await phieuNganhLTProvider.updateValByIdCoSo(
        colPhieuNganhLTA8_M, totalA8M, currentIdCoSo);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA8_M, totalA8M, tablePhieuNganhLT);
    //Tính cho câu A9_M <=> A7_11
    //9. DOANH THU KHÁCH KHÔNG NGỦ QUA ĐÊM (= CÂU 5.2 CỦA PHIẾU TB - câu 8)
    var totalA9M = totalA5_2 - totalA8M;

    if (totalA9M > 0) {
      totalA9M = AppUtils.roundDouble(totalA9M, 2);
    }

    await phieuNganhLTProvider.updateValByIdCoSo(
        colPhieuNganhLTA9_M!, totalA9M, currentIdCoSo);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA9_M, totalA9M, tablePhieuNganhLT);
  }

  ///A10_M <=> A7_13
  tinhUpdateA10M(a6MValue) async {
    var a10MValue = getValueDmByFieldName('A7_10') ?? 0;

    var a6MVal = a6MValue ?? 0;
    if (a10MValue >= 0 && a6MVal >= 0) {
      var a10M = a10MValue / a6MVal;
      await phieuNganhLTProvider.updateValByIdCoSo(
          colPhieuNganhLTA10_M, a10M, currentIdCoSo);
      await updateAnswerTblPhieuMau(
          colPhieuNganhLTA10_M, a10M, tablePhieuNganhLT);
    }
  }

  onValidateInputChiTieuDongCot(
      QuestionCommonModel question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong,
      String? valueInput,
      {bool typing = true,
      String? fieldName}) {
    // var table = question.bangDuLieu;
    // var maCauHoi = question.maCauHoi;
    // // var minValue =chiTieuCot!=null? chiTieuCot!.giaTriNN;
    // // var maxValue = chiTieuCot!=null? chiTieuCot!.giaTriLN ;
    // var tblPhieuCT;
    // // tblPhieuTonGiao.value.toJson();
    // if (typing == false) {
    //   tblPhieuCT = tblPhieuMau.value.toJson();
    // } else {
    //   tblPhieuCT = answerTblPhieuMau;
    // }
    // if (question.maCauHoi == "A1_3") {
    //   if (fieldName != null && fieldName != '' && fieldName.contains('GhiRo')) {
    //     var a1_3Value = '';
    //     if (typing) {
    //       var phieuMau = answerTblPhieuMau['A1_3'];
    //       a1_3Value = phieuMau['A1_3'];
    //     } else {
    //       var phieuMau = tblPhieuMau.value.toJson();
    //       a1_3Value = phieuMau['A1_3'].toString();
    //     }
    //     if (a1_3Value.toString() == '5') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị Ghi rõ.';
    //       }
    //     }
    //     return null;
    //   }
    // } else if (question.maCauHoi == "A4_4") {
    //   if (typing) {
    //     var a4_3 = answerTblPhieuMau['A4_3'];
    //     if (a4_3.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a4_3 = phieuMau['A4_3'].toString();
    //     if (a4_3.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   }
    // }
    // if (maCauHoi == "A2_2") {
    //   var resValid = onValidateA2_2(
    //       question, chiTieuCot, chiTieuDong, valueInput,
    //       typing: typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A2_3") {
    //   var resValid = onValidateA2_3(
    //       question, chiTieuCot, chiTieuDong, valueInput,
    //       typing: typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A3_2") {
    //   var resValid = onValidateA3_2(
    //       question, chiTieuCot, chiTieuDong, valueInput,
    //       typing: typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }

    // if (maCauHoi == "A4_5") {
    //   var resValid = onValidateA4_5(
    //       question, chiTieuCot, chiTieuDong, fieldName, valueInput);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A4_7") {
    //   var resValid = onValidateA4_7(
    //       question, chiTieuCot, chiTieuDong, fieldName, valueInput,
    //       typing: typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_1") {
    //   var resValid = onValidateA7_1(
    //       question, chiTieuCot, chiTieuDong, fieldName, valueInput);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A8_1") {
    //   var resValid = onValidateA8_1(
    //       question, chiTieuCot, chiTieuDong, fieldName, valueInput);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A9_2") {
    //   if (typing) {
    //     var a9_1 = answerTblPhieuMau['A9_1'];
    //     if (a9_1.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a9_1 = phieuMau['A9_1'].toString();
    //     if (a9_1.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   }
    // } else {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    // }
  }

  onValidateA4_5(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? valueInput,
      {bool typing = false}) {
    // if (typing == false) {
    //   for (var i = 1; i <= 4; i++) {
    //     var fName = 'A4_5_${i.toString()}_1';
    //     if (fieldName == fName) {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    //   var tblPhieu = tblPhieuMau.value.toJson();
    //   for (var i = 1; i <= 4; i++) {
    //     var fName1 = 'A4_5_${i.toString()}_1';
    //     var fName2 = 'A4_5_${i.toString()}_2';
    //     var a4_5_x_1Value = tblPhieu[fName1];
    //     if (fieldName == fName2) {
    //       if (a4_5_x_1Value.toString() == '1') {
    //         if (valueInput == null ||
    //             valueInput == "null" ||
    //             valueInput == "") {
    //           return 'Vui lòng nhập giá trị.';
    //         }
    //       }
    //     }
    //   }
    // }
    return null;
  }

  onValidateA4_7(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? valueInput,
      {bool typing = false}) {
    // if (fieldName == columnPhieuMauA4_7_0) {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    // }
    // var tblPhieuCT;
    // // tblPhieuTonGiao.value.toJson();
    // if (typing == false) {
    //   tblPhieuCT = tblPhieuMau.value.toJson();
    // } else {
    //   tblPhieuCT = answerTblPhieuMau;
    // }
    // for (var i = 1; i <= 8; i++) {
    //   var fName = 'A4_7_1_${i.toString()}_1';
    //   if (fieldName == fName) {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    // }
    // for (var i = 1; i <= 8; i++) {
    //   var fName1 = 'A4_7_${i.toString()}_1';
    //   var fName2 = 'A4_7_${i.toString()}_2';
    //   var a4_7_x_1Value = tblPhieuCT[fName1];
    //   if (fieldName == fName2) {
    //     if (a4_7_x_1Value.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    // }
    // double totalA4_7_0 = 0;

    // for (var i = 1; i <= 8; i++) {
    //   var fName1 = 'A4_7_${i.toString()}_1';
    //   var fName2 = 'A4_7_${i.toString()}_2';
    //   var a4_7_x_1Value = tblPhieuCT[fName1];
    //   if (a4_7_x_1Value.toString() == '1') {
    //     var a4_7_x_2Value = tblPhieuCT[fName2] != null
    //         ? AppUtils.convertStringToDouble(tblPhieuCT[fName2].toString())
    //         : 0;

    //     double a4_7_x_2Val =
    //         AppUtils.convertStringToDouble(a4_7_x_2Value.toString());
    //     totalA4_7_0 += a4_7_x_2Val;
    //   }
    // }
    // var a4_7_0Value = tblPhieuCT[columnPhieuMauA4_7_0] != null
    //     ? AppUtils.convertStringToDouble(
    //         tblPhieuCT[columnPhieuMauA4_7_0].toString())
    //     : 0;

    // if (fieldName == columnPhieuMauA4_7_0) {
    //   var totalA4_7_0Tmp = AppUtils.convertStringAndFixedToDouble(totalA4_7_0);
    //   if (a4_7_0Value < totalA4_7_0Tmp) {
    //     return 'Tổng số tiền thuế đã nộp ($a4_7_0Value) phải >= Mã 1 + 2 + 3 + 4+ 5 + 6 + 7 + 8 = $totalA4_7_0Tmp';
    //   }
    // } else {
    //   for (var i = 1; i <= 8; i++) {
    //     var fName1 = 'A4_7_${i.toString()}_1';
    //     var fName2 = 'A4_7_${i.toString()}_2';
    //     var a4_7_x_1Value = tblPhieuCT[fName1];
    //     if (a4_7_x_1Value.toString() == '1') {
    //       var a4_7_x_2Value = tblPhieuCT[fName2] != null
    //           ? AppUtils.convertStringToDouble(tblPhieuCT[fName2].toString())
    //           : 0;
    //       if (fieldName == fName2) {
    //         var cp = a4_7_x_2Value > a4_7_0Value;
    //         if (a4_7_x_2Value > a4_7_0Value) {
    //           return '${chiTieuDong!.tenChiTieu} ($a4_7_x_2Value) phải < Tổng số tiền thuế đã nộp ($a4_7_0Value)';
    //         }
    //         return null;
    //       }
    //     }
    //   }
    // }

    return null;
  }

  onValidateA7_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? valueInput,
      {bool typing = false}) {
    // if (typing == false) {
    //   for (var i = 1; i <= 5; i++) {
    //     var fName = 'A7_1_${i.toString()}_0';
    //     if (fieldName == fName) {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    //   var tblPhieu = tblPhieuMau.value.toJson();
    //   for (var i = 1; i <= 5; i++) {
    //     var fName0 = 'A7_1_${i.toString()}_0';
    //     var fName1 = 'A7_1_${i.toString()}_1';
    //     var fName2 = 'A7_1_${i.toString()}_2';
    //     var fName3 = 'A7_1_${i.toString()}_3';
    //     var fName4 = 'A7_1_${i.toString()}_4';
    //     var fName5 = 'A7_1_${i.toString()}_5';
    //     var a7_1_x_0Value = tblPhieu[fName0];
    //     if (fieldName == fName2 ||
    //         fieldName == fName3 ||
    //         fieldName == fName4 ||
    //         fieldName == fName5) {
    //       if (a7_1_x_0Value.toString() == '1') {
    //         if (valueInput == null ||
    //             valueInput == "null" ||
    //             valueInput == "") {
    //           return 'Vui lòng nhập giá trị.';
    //         }
    //       }
    //     }
    //   }
    // }
    return null;
  }

  onValidateA8_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? valueInput,
      {bool typing = false}) {
    // if (typing == false) {
    //   for (var i = 1; i <= 4; i++) {
    //     var fName = 'A8_1_1_${i.toString()}_1';
    //     if (fieldName == fName) {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    //   for (var i = 1; i <= 11; i++) {
    //     var fName = 'A8_1_${i.toString()}_1';
    //     if (fieldName == fName) {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }

    //   var tblPhieu = tblPhieuMau.value.toJson();
    //   for (var i = 1; i <= 4; i++) {
    //     var fName1 = 'A8_1_1_${i.toString()}_1';
    //     var fName2 = 'A8_1_1_${i.toString()}_2';
    //     var fName3 = 'A8_1_1_${i.toString()}_3';
    //     var a8_1_x_1Value = tblPhieu[fName1];
    //     var a8_1_x_2Value = tblPhieu[fName2];
    //     var a8_1_x_3Value = tblPhieu[fName3];
    //     if (fieldName == fName2 || fieldName == fName3) {
    //       if (a8_1_x_1Value.toString() == '1') {
    //         if (valueInput == null ||
    //             valueInput == "null" ||
    //             valueInput == "") {
    //           return 'Vui lòng nhập giá trị.';
    //         }
    //       }
    //     }
    //   }
    //   for (var i = 1; i <= 11; i++) {
    //     var fName1 = 'A8_1_${i.toString()}_1';
    //     var fName2 = 'A8_1_${i.toString()}_2';
    //     var fName3 = 'A8_1_${i.toString()}_3';
    //     var a8_1_x_1Value = tblPhieu[fName1];
    //     var a8_1_x_2Value = tblPhieu[fName2];
    //     var a8_1_x_3Value = tblPhieu[fName3];
    //     if (fieldName == fName2 || fieldName == fName3) {
    //       // if (fieldName == "A8_1_3_1_2") {
    //       //   if (isCap1HPhanVI.value == true &&
    //       //       (isCap5VanTaiHanhKhachPhanVI.value == true ||
    //       //           isCap5DichVuHangHoaPhanVI.value)) {
    //       //     return 'Vui lòng nhập giá trị.';
    //       //   }
    //       // } else if (fieldName == "A8_1_5_1_2") {
    //       //   if (isCap1HPhanVI.value == true &&
    //       //       (isCap5VanTaiHanhKhachPhanVI.value == true ||
    //       //           isCap5DichVuHangHoaPhanVI.value)) {
    //       //     return 'Vui lòng nhập giá trị.';
    //       //   }
    //       // }
    //       if (a8_1_x_1Value.toString() == '1') {
    //         if (valueInput == null ||
    //             valueInput == "null" ||
    //             valueInput == "") {
    //           // if (fieldName == "A8_1_3_1_2") {
    //           //   if (isCap1HPhanVI.value == true &&
    //           //       (isCap5VanTaiHanhKhachPhanVI.value == true ||
    //           //           isCap5DichVuHangHoaPhanVI.value)) {
    //           //     return 'Vui lòng nhập giá trị.';
    //           //   }
    //           // } else if (fieldName == "A8_1_5_1_2") {
    //           //   if (isCap1HPhanVI.value == true &&
    //           //       (isCap5VanTaiHanhKhachPhanVI.value == true ||
    //           //           isCap5DichVuHangHoaPhanVI.value)) {
    //           //     return 'Vui lòng nhập giá trị.';
    //           //   }
    //           // } else {
    //           return 'Vui lòng nhập giá trị.';
    //           //   }
    //         }
    //       }
    //     }
    //   }
    //   if (fieldName == "A8_1_3_1_2") {
    //     var a8_1_3_1Value = tblPhieu['A8_1_3_1'];
    //     // if (a8_1_3_1Value.toString() == '1') {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       if (isCap1HPhanVI.value == true &&
    //           (isCap5VanTaiHanhKhachPhanVI.value == true ||
    //               isCap5DichVuHangHoaPhanVI.value)) {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //     //}
    //   }
    //   if (fieldName == "A8_1_5_1_2") {
    //     var a8_1_3_1Value = tblPhieu['A8_1_5_1'];
    //     //if (a8_1_3_1Value.toString() == '1') {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       if (isCap1HPhanVI.value == true &&
    //           (isCap5VanTaiHanhKhachPhanVI.value == true ||
    //               isCap5DichVuHangHoaPhanVI.value)) {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //     // }
    //   }
    return null;
    // }
  }

  ///END::::Chi tieu dong cot
  /*********/
  ///
  getValueByFieldName(String table, String fieldName, {String? valueDataType}) {
    if (fieldName == null || fieldName == '') return null;
    if (table == tablePhieuMauTB) {
      var res = answerTblPhieuMau[fieldName];
      // if (valueDataType == "double") {
      //   AppUtils.convertStringToDouble(res.toString());
      // }
      // if (fieldName == "A7_11" || fieldName == "A7_13") {
      //   return AppUtils.convertStringAndFixed2ToString(res.toString());
      // }
      return res;
    } else if (table == tablePhieuNganhLT) {
      var res = answerTblPhieuNganhLT[fieldName];
      // if (valueDataType == "double") {
      //   AppUtils.convertStringToDouble(res.toString());
      // }
      // if (fieldName == "A7_11" || fieldName == "A7_13") {
      //   return AppUtils.convertStringAndFixed2ToString(res.toString());
      // }
      return res;
    } else if (table == tablePhieuNganhVT) {
      var res = answerTblPhieuNganhVT[fieldName];
      // if (valueDataType == "double") {
      //   AppUtils.convertStringToDouble(res.toString());
      // }
      // if (fieldName == "A7_11" || fieldName == "A7_13") {
      //   return AppUtils.convertStringAndFixed2ToString(res.toString());
      // }
      return res;
    } else {
      return null;
    }
  }

  getValueByFieldNameFromDB(String table, String fieldName,
      {String? valueDataType, int? stt, int? id}) {
    if (fieldName == null || fieldName == '') return null;
    if (table == tablePhieuMauTB) {
      var tbl = tblPhieuMauTB.value.toJson();
      var res = tbl[fieldName];
      if (fieldName == "A7_11" || fieldName == "A7_13") {
        return AppUtils.convertStringAndFixed2ToString(
            tbl[fieldName].toString());
      }
      return res;
    } else if (table == tablePhieuNganhTM) {
      var tbl = tblPhieuNganhTM.toJson();

      if (tbl != null) {
        var res = tbl[fieldName];
        return res;
      }
    } else if (table == tablePhieuNganhTMSanPham) {
      TablePhieuNganhTMSanPham? tbl;
      if (id != null) {
        tbl = tblPhieuNganhTMSanPham.where((x) => x.id == id).firstOrNull;
      } else if (stt != null) {
        tbl = tblPhieuNganhTMSanPham
            .where((x) => x.sTT_SanPham == stt)
            .firstOrNull;
      }
      if (tbl != null) {
        var tblJson = tbl.toJson();
        var res = tblJson[fieldName];
        return res;
      }
    } else {
      return null;
    }
  }

  getValueByFieldNameStt(String table, String fieldName, int idValue) {
    // if (table == tablePhieuMauA61) {
    //   for (var item in tblPhieuMauA61) {
    //     if (item.id == idValue) {
    //       var tbl = item.toJson();
    //       return tbl[fieldName];
    //     }
    //   }
    // } else if (table == tablePhieuMauA68) {
    //   for (var item in tblPhieuMauA68) {
    //     if (item.id == idValue) {
    //       var tbl = item.toJson();
    //       return tbl[fieldName];
    //     }
    //   }
    // } else if (table == tablePhieuMauSanPham) {
    //   for (var item in tblPhieuMauSanPham) {
    //     if (item.id == idValue) {
    //       var tbl = item.toJson();
    //       return tbl[fieldName];
    //     }
    //   }
    // } else {
    //   return '';
    // }
    return '';
  }

  getValueDanhDauSP(String fieldName, {int? stt}) {
    if (stt != null) {
      if (answerDanhDauSanPham[stt] != null) {
        Map<dynamic, dynamic> ddSp = answerDanhDauSanPham[stt];
        if (ddSp != null) {
          return ddSp[fieldName];
        }
      }
    }
    return answerDanhDauSanPham[fieldName];
  }

  removeValueDanhDauSP(stt) {
    answerDanhDauSanPham.removeWhere((key, value) => key == stt);
  }

  getDoubleValue(val, String? valDataType) {
    if (valDataType == "double") {
      if (val == null || val == "") {
        return val;
      }
      return double.parse(val.toString().replaceAll(",", "."));
    }
    return val;
  }

  ///END::Get value by field name
  /*****/
  /*****/

  ///END::Logic
  /********/
  ///BEGIN::Validation
  String? onValidate(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    var tblPhieuCT;
    // if (typing == false) {
    //   tblPhieuCT = tblPhieuMau.value.toJson();
    // } else {
    //   tblPhieuCT = answerTblPhieuMau;
    // }

    // if (maCauHoi == "A1_1") {
    //   if (valueInput != null && valueInput.length < 15) {}
    // }
    // if (maCauHoi == "A1_5_3") {
    //   if (validateEmptyString(valueInput)) {
    //     return 'Vui lòng nhập Năm sinh.';
    //   }
    //   var nSinh = valueInput!.replaceAll(' ', '');
    //   //nam sinh
    //   if (nSinh.length != 4) {
    //     return 'Vui lòng nhập năm sinh 4 chũ số';
    //   }
    //   int namSinh = AppUtils.convertStringToInt(nSinh);
    //   if (namSinh < 1935 || namSinh > 2007) {
    //     return "Năm sinh phải >= 1935 và <= 2007";
    //   }
    // }
    // if (maCauHoi == "A1_7_1") {
    //   var a1_7Value = '';
    //   if (typing) {
    //     a1_7Value = answerTblPhieuMau['A1_7'];
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     a1_7Value = phieuMau['A1_7'].toString();
    //   }
    //   if (a1_7Value.toString() == '1') {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       return 'Vui lòng nhập giá trị Mã số thuế.';
    //     }
    //   } else {
    //     return null;
    //   }
    // } else if (maCauHoi == "A4_1") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var a4_1 = AppUtils.convertStringToInt(valueInput.replaceAll(' ', ''));
    //   if (a4_1 > 12) {
    //     return 'Vui lòng nhập giá trị 1 - 12.';
    //   }
    // } else if (maCauHoi == "A4_4_1") {
    //   if (typing) {
    //     var a4_3s = answerTblPhieuMau['A4_4'];
    //     if (a4_3s != null && a4_3s != '') {
    //       var arrA4_3 = a4_3s.toString().split(';');
    //       if (arrA4_3.isNotEmpty) {
    //         if (arrA4_3.contains('1')) {
    //           if (valueInput == null ||
    //               valueInput == "null" ||
    //               valueInput == "") {
    //             return 'Vui lòng nhập giá trị.';
    //           }
    //         } else {
    //           return null;
    //         }
    //       }
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a4_3s = phieuMau['A4_4'].toString();
    //     if (a4_3s != null && a4_3s != '') {
    //       var arrA4_3 = a4_3s.toString().split(';');
    //       if (arrA4_3.isNotEmpty) {
    //         if (arrA4_3.contains('1')) {
    //           if (valueInput == null ||
    //               valueInput == "null" ||
    //               valueInput == "") {
    //             return 'Vui lòng nhập giá trị.';
    //           }
    //         } else {
    //           return null;
    //         }
    //       }
    //     }
    //     return null;
    //   }
    // } else if (maCauHoi == "A4_4_2") {
    //   if (typing) {
    //     var a4_3s = answerTblPhieuMau['A4_4'];
    //     if (a4_3s != null && a4_3s != '') {
    //       var arrA4_3 = a4_3s.toString().split(';');
    //       if (arrA4_3.isNotEmpty && arrA4_3.length > 1) {
    //         if (arrA4_3.contains('2')) {
    //           if (valueInput == null ||
    //               valueInput == "null" ||
    //               valueInput == "") {
    //             return 'Vui lòng nhập giá trị.';
    //           }
    //         } else {
    //           return null;
    //         }
    //       }
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a4_3s = phieuMau['A4_4'].toString();
    //     if (a4_3s != 'null' && a4_3s != '') {
    //       var arrA4_3 = a4_3s.toString().split(';');
    //       if (arrA4_3.isNotEmpty && arrA4_3.length > 1) {
    //         if (arrA4_3.contains('2')) {
    //           if (valueInput == null ||
    //               valueInput == "null" ||
    //               valueInput == "") {
    //             return 'Vui lòng nhập giá trị.';
    //           }
    //         } else {
    //           return null;
    //         }
    //       }
    //     }
    //     return null;
    //   }
    // } else if (maCauHoi == "A4_6") {
    //   ///Bổ sung logic cho câu A4.6 ngày 19/02/2025
    //   ///Nếu câu A1.4=1 => 4.6 phải lớn hơn 0
    //   var a1_4Value =
    //       tblPhieuCT['A1_4'] != null ? tblPhieuCT['A1_4'].toString() : '';

    //   if (!validateEmptyString(a1_4Value) && a1_4Value == '2') {
    //     var a4_6Value = tblPhieuCT['A4_6'] != null
    //         ? AppUtils.convertStringToDouble(tblPhieuCT['A4_6'].toString())
    //         : null;
    //     if (!validateEmptyString(a4_6Value.toString()) && a4_6Value > 0) {
    //       return 'Câu 1.4 Địa điểm thuộc sở hữu của chủ cơ sở nên câu 4.6 Tiền thuê địa điểm SXKD phải = 0';
    //     }
    //   } else {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //     if (validate0InputValue(valueInput)) {
    //       return 'Câu 1.4 đã chọn "Địa điểm đi thuê/mượn" nên giá trị câu 4.6 giá trị lớn hơn 0.';
    //     }
    //   }
    // } else if (maCauHoi == "A7_9") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var a7_9 = AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //   if (a7_9 > 100) {
    //     return 'Vui lòng nhập giá trị 0 - 100.';
    //   }
    // } else if (maCauHoi == "A9_5") {
    //   if (typing) {
    //     var a9_4_1 = answerTblPhieuMau['A9_4_1'];
    //     if (a9_4_1.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //       var a7_9 =
    //           AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //       if (a7_9 > 100) {
    //         return 'Vui lòng nhập giá trị 0 - 100.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a9_4_1 = phieuMau['A9_4_1'].toString();
    //     if (a9_4_1.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //       var a7_9 =
    //           AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //       if (a7_9 > 100) {
    //         return 'Vui lòng nhập giá trị 0 - 100.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   }
    // } else if (maCauHoi == "A9_6") {
    //   if (typing) {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //     var a9_6 =
    //         AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //     if (a9_6 > 100) {
    //       return 'Vui lòng nhập giá trị 0 - 100.';
    //     }
    //   } else {
    //     if (valueInput == null || valueInput == "null" || valueInput == "") {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //     var a9_6 =
    //         AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //     if (a9_6 > 100) {
    //       return 'Vui lòng nhập giá trị 0 - 100.';
    //     }
    //   }
    // } else if (maCauHoi == "A9_7_1") {
    //   if (typing == false) {
    //     var a9_7 = answerTblPhieuMau['A9_7'];
    //     if (a9_7.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //       return null;
    //     } else {
    //       return null;
    //     }
    //   }
    // } else if (maCauHoi == "A9_8") {
    //   if (typing) {
    //     var a9_4_2 = answerTblPhieuMau['A9_4_2'];
    //     if (a9_4_2.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //       var a9_8 =
    //           AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //       if (a9_8 > 100) {
    //         return 'Vui lòng nhập giá trị 0 - 100.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a9_4_2 = phieuMau['A9_4_2'].toString();
    //     if (a9_4_2.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //       var a9_8 =
    //           AppUtils.convertStringToDouble(valueInput.replaceAll(' ', ''));
    //       if (a9_8 > 100) {
    //         return 'Vui lòng nhập giá trị 0 - 100.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   }
    // } else if (maCauHoi == "A9_10") {
    //   if (typing) {
    //     var a9_9 = answerTblPhieuMau['A9_9'];
    //     if (a9_9.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     var a9_9 = phieuMau['A9_9'].toString();
    //     if (a9_9.toString() == '1') {
    //       if (valueInput == null || valueInput == "null" || valueInput == "") {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     } else {
    //       return null;
    //     }
    //   }
    // }
    // if (maCauHoi == "A2_1" ||
    //     maCauHoi == "A2_1_1" ||
    //     maCauHoi == "A2_1_2" ||
    //     maCauHoi == "A2_1_3") {
    //   var resValid = onValidateA2_1(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A3_3" || maCauHoi == "A3_3_1") {
    //   var resValid = onValidateA3_3(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }

    // if (maCauHoi == "A7_2") {
    //   var resValid = onValidateA7_2(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_2_1") {
    //   var resValid = onValidateA7_2_1(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_4") {
    //   var resValid = onValidateA7_4(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_4_1") {
    //   var resValid = onValidateA7_4_1(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_5") {
    //   var resValid = onValidateA7_5(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_6" || maCauHoi == "A7_6_1") {
    //   var resValid = onValidateA7_6_1(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (maCauHoi == "A7_7" || maCauHoi == "A7_7_1") {
    //   var resValid = onValidateA7_7_1(table, maCauHoi, fieldName, valueInput,
    //       minValue, maxValue, loaiCauHoi, typing);
    //   if (resValid != null && resValid != '') {
    //     return resValid;
    //   }
    //   return null;
    // }
    // if (valueInput == null || valueInput == "" || valueInput == "null") {
    //   if ((loaiCauHoi == AppDefine.loaiCauHoi_1 ||
    //           loaiCauHoi == AppDefine.loaiCauHoi_5) &&
    //       !fieldName!.contains('_GhiRo')) {
    //     return 'Vui lòng chọn giá trị.';
    //   }
    //   return !fieldName!.contains('_GhiRo')
    //       ? 'Vui lòng nhập giá trị.'
    //       : 'Ghi rõ. Vui lòng nhập giá trị.';
    // }
    // return ValidateQuestionNo07.onValidate(
    //     table, maCauHoi, fieldName, valueInput, minValue, maxValue, loaiCauHoi);
  }

  String? onValidateA2_1(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (valueInput == null || valueInput == "null" || valueInput == "") {
    //   return 'Vui lòng nhập giá trị.';
    // }
    // var tblPhieuCT;
    // if (typing == false) {
    //   tblPhieuCT = tblPhieuMau.value.toJson();
    // } else {
    //   tblPhieuCT = answerTblPhieuMau;
    // }

    // int a2_1Value = tblPhieuCT['A2_1'] != null
    //     ? AppUtils.convertStringToInt(tblPhieuCT['A2_1'].toString())
    //     : 0;
    // int a2_1_1Value = tblPhieuCT['A2_1_1'] != null
    //     ? AppUtils.convertStringToInt(tblPhieuCT['A2_1_1'].toString())
    //     : 0;
    // int a2_1_2Value = tblPhieuCT['A2_1_2'] != null
    //     ? AppUtils.convertStringToInt(tblPhieuCT['A2_1_2'].toString())
    //     : 0;
    // int a2_1_3Value = tblPhieuCT['A2_1_3'] != null
    //     ? AppUtils.convertStringToInt(tblPhieuCT['A2_1_3'].toString())
    //     : 0;
    // int tongCon = a2_1_1Value + a2_1_2Value + a2_1_3Value;
    // if (fieldName == columnPhieuMauA2_1) {
    //   // if (a2_1Value < tongCon) {
    //   //   return 'Câu 2.1 >= 2.1.1 + 2.1.2 + 2.1.3';
    //   // }
    //   //Ktra A2_1 va 2_2 va A2_3
    //   var validA2_1nA2_2 = validateA2_1nA2_2("A2_1", typing);
    //   if (validA2_1nA2_2 != null && validA2_1nA2_2 != '') {
    //     return validA2_1nA2_2;
    //   }
    //   var validA2_1nA2_3 = validateA2_1nA2_3("A2_1", typing);
    //   if (validA2_1nA2_3 != null && validA2_1nA2_3 != '') {
    //     return validA2_1nA2_3;
    //   }
    // } else if (fieldName == columnPhieuMauA2_1_1) {
    //   if (a2_1Value < a2_1_1Value) {
    //     return 'Câu 2.1.1 < Câu 2.1';
    //   }
    // } else if (fieldName == columnPhieuMauA2_1_2) {
    //   if (a2_1Value < a2_1_2Value) {
    //     return 'Câu 2.1.2 < Câu 2.1';
    //   }
    // } else if (fieldName == columnPhieuMauA2_1_3) {
    //   if (a2_1Value < a2_1_3Value) {
    //     return 'Câu 2.1.3 < Câu 2.1';
    //   }
    // }
    return null;
  }

  String? validateA2_1nA2_2(String maCauHoi, bool typing) {
    var tblPhieuCT;
    // if (typing == false) {
    //   tblPhieuCT = tblPhieuMau.value.toJson();
    // } else {
    //   tblPhieuCT = answerTblPhieuMau;
    // }
    // int a2_1Value = tblPhieuCT['A2_1'] != null
    //     ? AppUtils.convertStringToInt(tblPhieuCT['A2_1'].toString())
    //     : 0;
    // int a2_2Total = 0;
    // for (var i = 1; i <= 10; i++) {
    //   String fieldNameTs = 'A2_2_${i}_1';
    //   int a2_2_1_xValue = tblPhieuCT[fieldNameTs] != null
    //       ? AppUtils.convertStringToInt(tblPhieuCT[fieldNameTs].toString())
    //       : 0;
    //   a2_2Total += a2_2_1_xValue;
    // }
    // if (a2_1Value != a2_2Total) {
    //   if (maCauHoi == "A2_1") {
    //     return 'Tổng A2.1 ($a2_1Value) phải bằng tổng chi tiết A2.2 ($a2_2Total)';
    //   } else if (maCauHoi == "A2_2") {
    //     return 'Tổng chi tiết A2.2 ($a2_2Total) phải bằng tổng A2.1 ($a2_1Value)';
    //   }
    // }
    return '';
  }

  String? validateA2_1nA2_3(String maCauHoi, bool typing) {
    var tblPhieuCT;
    // if (typing == false) {
    //   tblPhieuCT = tblPhieuMau.value.toJson();
    // } else {
    //   tblPhieuCT = answerTblPhieuMau;
    // }
    // int a2_1Value = tblPhieuCT['A2_1'] != null
    //     ? AppUtils.convertStringToInt(tblPhieuCT['A2_1'].toString())
    //     : 0;
    // int a2_3Total = 0;
    // for (var i = 1; i <= 6; i++) {
    //   String fieldNameTs = 'A2_3_${i}_1';
    //   int a2_2_1_xValue = tblPhieuCT[fieldNameTs] != null
    //       ? AppUtils.convertStringToInt(tblPhieuCT[fieldNameTs].toString())
    //       : 0;
    //   a2_3Total += a2_2_1_xValue;
    // }
    // if (a2_1Value != a2_3Total) {
    //   if (maCauHoi == "A2_1") {
    //     return 'Tổng A2.1 ($a2_1Value) phải bằng tổng chi tiết A2.3 ($a2_3Total)';
    //   } else if (maCauHoi == "A2_3") {
    //     return 'Tổng chi tiết A2.3 ($a2_3Total) phải bằng tổng A2.1 ($a2_1Value)';
    //   }
    // }
    return '';
  }

  String? onValidateA2_2(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? valueInput,
      {bool typing = true, String? fieldName}) {
    // if (question.maCauHoi == "A2_2") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var tblPhieuCT;
    //   if (typing == false) {
    //     tblPhieuCT = tblPhieuMau.value.toJson();
    //   } else {
    //     tblPhieuCT = answerTblPhieuMau;
    //   }
    //   String fieldNameTs = 'A2_2_${chiTieuDong!.maSo}_1';
    //   String fieldNameNu = 'A2_2_${chiTieuDong!.maSo}_2';

    //   int a2_2_1_1Value = tblPhieuCT[fieldNameTs] != null
    //       ? AppUtils.convertStringToInt(tblPhieuCT[fieldNameTs].toString())
    //       : 0;
    //   int a2_2_1_2Value = tblPhieuCT[fieldNameNu] != null
    //       ? AppUtils.convertStringToInt(tblPhieuCT[fieldNameNu].toString())
    //       : 0;

    //   ///Lấy a1_5_6 trình độ chuyên môn của chủ sở hữu => Kiểm tra giá trị đã nhập nằm trong chỉ tiêu trình độ chuyên môn của câu a2_2 hay không.
    //   var a1_5_6Val = tblPhieuCT[columnPhieuMauA1_5_6];
    //   if (chiTieuCot!.maChiTieu == '1') {
    //     if (a2_2_1_1Value < a2_2_1_2Value) {
    //       return 'Tổng số > Trong đó: nữ';
    //     }
    //     var validA2_1nA2_2 = validateA2_1nA2_2("A2_2", typing);
    //     if (validA2_1nA2_2 != null && validA2_1nA2_2 != '') {
    //       return validA2_1nA2_2;
    //     }
    //   } else if (chiTieuCot!.maChiTieu == '2') {
    //     if (a2_2_1_1Value < a2_2_1_2Value) {
    //       return 'Trong đó: nữ < Tổng số';
    //     }
    //   }

    //   if (a1_5_6Val.toString() == chiTieuDong.maSo) {
    //     if (a2_2_1_1Value == 0) {
    //       return 'Câu 1.5.6 chọn mã $a1_5_6Val, giá trị của câu C2.2 mã ${chiTieuDong.maSo} = $a2_2_1_1Value. Vui lòng kiểm tra lại.';
    //     }
    //   }

    //   return null;
    // }
    return null;
  }

  String? onValidateA2_3(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? valueInput,
      {bool typing = true, String? fieldName}) {
    // if (question.maCauHoi == "A2_3") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var tblPhieuCT;
    //   if (typing == false) {
    //     tblPhieuCT = tblPhieuMau.value.toJson();
    //   } else {
    //     tblPhieuCT = answerTblPhieuMau;
    //   }

    //   int a2_3_1_1Value = tblPhieuCT['A2_3_${chiTieuDong!.maSo}_1'] != null
    //       ? AppUtils.convertStringToInt(
    //           tblPhieuCT['A2_3_${chiTieuDong!.maSo}_1'])
    //       : 0;
    //   int a2_3_1_2Value = tblPhieuCT['A2_3_${chiTieuDong!.maSo}_2'] != null
    //       ? AppUtils.convertStringToInt(
    //           tblPhieuCT['A2_3_${chiTieuDong!.maSo}_2'])
    //       : 0;
    //   if (chiTieuCot!.maChiTieu == '1') {
    //     if (a2_3_1_1Value < a2_3_1_2Value) {
    //       return 'Tổng số > Trong đó: nữ';
    //     }
    //     var validA2_1nA2_3 = validateA2_1nA2_3("A2_3", typing);
    //     if (validA2_1nA2_3 != null && validA2_1nA2_3 != '') {
    //       return validA2_1nA2_3;
    //     }
    //   } else if (chiTieuCot!.maChiTieu == '2') {
    //     if (a2_3_1_2Value > a2_3_1_1Value) {
    //       return 'Trong đó: nữ < Tổng số';
    //     }
    //   }

    //   return null;
    // }
    return null;
  }

  String? onValidateA3_2(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? valueInput,
      {bool typing = true, String? fieldName}) {
    // if (question.maCauHoi == "A3_2") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var tblPhieuCT;
    //   if (typing == false) {
    //     tblPhieuCT = tblPhieuMau.value.toJson();
    //   } else {
    //     tblPhieuCT = answerTblPhieuMau;
    //   }
    //   double a3_2_x_1Value = tblPhieuCT['A3_2_${chiTieuDong!.maSo}_1'] != null
    //       ? AppUtils.convertStringToDouble(
    //           tblPhieuCT['A3_2_${chiTieuDong!.maSo}_1'])
    //       : 0;
    //   double a3_2_x_2Value = tblPhieuCT['A3_2_${chiTieuDong!.maSo}_2'] != null
    //       ? AppUtils.convertStringToDouble(
    //           tblPhieuCT['A3_2_${chiTieuDong!.maSo}_2'])
    //       : 0;
    //   if (chiTieuCot!.maChiTieu == '1') {
    //     if (a3_2_x_1Value > 0 && a3_2_x_1Value < 9.0) {
    //       return 'a. Tổng số giá trị TSCĐ theo giá mua phải >= 9';
    //     }
    //   }
    //   // if (chiTieuCot!.maChiTieu == '2') {
    //   //   if (a3_2_x_2Value > 0 && a3_2_x_2Value < 9.0) {
    //   //     return 'b. Trong đó: Giá trị mua/xây dựng mới từ trong năm 2024 phải >= 9';
    //   //   }
    //   // }
    //   if (a3_2_x_1Value < a3_2_x_2Value) {
    //     return 'a. Tổng số giá trị TSCĐ theo giá mua phải > b. Trong đó: Giá trị mua/xây dựng mới từ trong năm 2024';
    //   }
    //   return null;
    // }
    return null;
  }

  String? onValidateA3_3(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A3_3" || maCauHoi == "A3_3_1") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   var tblPhieuCT;
    //   if (typing == false) {
    //     tblPhieuCT = tblPhieuMau.value.toJson();
    //   } else {
    //     tblPhieuCT = answerTblPhieuMau;
    //   }
    //   double a3_3Value = tblPhieuCT[columnPhieuMauA3_3] != null
    //       ? AppUtils.convertStringToDouble(tblPhieuCT[columnPhieuMauA3_3])
    //       : 0;
    //   double a3_3_1Value = tblPhieuCT[columnPhieuMauA3_3_1] != null
    //       ? AppUtils.convertStringToDouble(tblPhieuCT[columnPhieuMauA3_3_1])
    //       : 0;
    //   if (maCauHoi == "A3_3") {
    //     if (a3_3Value < a3_3_1Value) {
    //       return 'Giá trị câu 3.3 phải >= câu 3.3.1';
    //     }
    //   } else if (maCauHoi == "A3_3_1") {
    //     if (a3_3_1Value > a3_3Value) {
    //       return 'Giá trị câu 3.3.1 phải nhỏ hơn câu 3.3';
    //     }
    //   }

    //   return null;
    // }
    return null;
  }

  String? onValidateA7_2(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_2") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     int a7_2Value = answerTblPhieuMau[columnPhieuMauA7_2] != null
    //         ? AppUtils.convertStringToInt(answerTblPhieuMau[columnPhieuMauA7_2])
    //         : 0;
    //     int a7_1_1_2Val = answerTblPhieuMau[columnPhieuMauA7_1_1_2] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_1_2])
    //         : 0;
    //     int a7_1_2_2Val = answerTblPhieuMau[columnPhieuMauA7_1_2_2] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_2_2])
    //         : 0;
    //     int a7_1_3_2Val = answerTblPhieuMau[columnPhieuMauA7_1_3_2] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_3_2])
    //         : 0;
    //     int a7_1_4_2Val = answerTblPhieuMau[columnPhieuMauA7_1_4_2] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_4_2])
    //         : 0;
    //     int a7_1_5_2Val = answerTblPhieuMau[columnPhieuMauA7_1_5_2] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_5_2])
    //         : 0;
    //     var aSum_7_1_x_2Value =
    //         a7_1_1_2Val + a7_1_2_2Val + a7_1_3_2Val + a7_1_4_2Val + a7_1_5_2Val;
    //     if (a7_2Value != aSum_7_1_x_2Value) {
    //       return 'Giá trị câu 7.2 ($a7_2Value) phải = Tổng của 7.1.2.Số phòng tại thời điểm 31/12/2024 ($aSum_7_1_x_2Value)';
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     int a7_2Value = phieuMau[columnPhieuMauA7_2] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_2])
    //         : 0;
    //     int a7_1_1_2Val = phieuMau[columnPhieuMauA7_1_1_2] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_1_2])
    //         : 0;
    //     int a7_1_2_2Val = phieuMau[columnPhieuMauA7_1_2_2] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_2_2])
    //         : 0;
    //     int a7_1_3_2Val = phieuMau[columnPhieuMauA7_1_3_2] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_3_2])
    //         : 0;
    //     int a7_1_4_2Val = phieuMau[columnPhieuMauA7_1_4_2] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_4_2])
    //         : 0;
    //     int a7_1_5_2Val = phieuMau[columnPhieuMauA7_1_5_2] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_5_2])
    //         : 0;
    //     var aSum_7_1_x_2Value =
    //         a7_1_1_2Val + a7_1_2_2Val + a7_1_3_2Val + a7_1_4_2Val + a7_1_5_2Val;
    //     if (a7_2Value != aSum_7_1_x_2Value) {
    //       return 'Giá trị câu 7.2 ($a7_2Value) phải = Tổng của 7.1.2.Số phòng tại thời điểm 31/12/2024 ($aSum_7_1_x_2Value)';
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  String? onValidateA7_2_1(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_2_1") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     int a7_2_1Value = answerTblPhieuMau[columnPhieuMauA7_2_1] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_2_1])
    //         : 0;
    //     int a7_1_1_3Val = answerTblPhieuMau[columnPhieuMauA7_1_1_3] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_1_3])
    //         : 0;
    //     int a7_1_2_3Val = answerTblPhieuMau[columnPhieuMauA7_1_2_3] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_2_3])
    //         : 0;
    //     int a7_1_3_3Val = answerTblPhieuMau[columnPhieuMauA7_1_3_3] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_3_3])
    //         : 0;
    //     int a7_1_4_3Val = answerTblPhieuMau[columnPhieuMauA7_1_4_3] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_4_3])
    //         : 0;
    //     int a7_1_5_3Val = answerTblPhieuMau[columnPhieuMauA7_1_5_3] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_5_3])
    //         : 0;
    //     var aSum_7_1_x_3Value =
    //         a7_1_1_3Val + a7_1_2_3Val + a7_1_3_3Val + a7_1_4_3Val + a7_1_5_3Val;
    //     if (a7_2_1Value != aSum_7_1_x_3Value) {
    //       return 'Giá trị câu 7.2.1 ($a7_2_1Value) phải = Tổng của 7.1.3. Số phòng tăng mới trong năm 2024 ($aSum_7_1_x_3Value)';
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     int a7_2_1Value = phieuMau[columnPhieuMauA7_2_1] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_2_1])
    //         : 0;
    //     int a7_1_1_3Val = phieuMau[columnPhieuMauA7_1_1_3] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_1_3])
    //         : 0;
    //     int a7_1_2_3Val = phieuMau[columnPhieuMauA7_1_2_3] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_2_3])
    //         : 0;
    //     int a7_1_3_3Val = answerTblPhieuMau[columnPhieuMauA7_1_3_3] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_3_3])
    //         : 0;
    //     int a7_1_4_3Val = phieuMau[columnPhieuMauA7_1_4_3] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_4_3])
    //         : 0;
    //     int a7_1_5_3Val = phieuMau[columnPhieuMauA7_1_5_3] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_5_3])
    //         : 0;
    //     var aSum_7_1_x_3Value =
    //         a7_1_1_3Val + a7_1_2_3Val + a7_1_3_3Val + a7_1_4_3Val + a7_1_5_3Val;
    //     if (a7_2_1Value != aSum_7_1_x_3Value) {
    //       return 'Giá trị câu 7.2.1 ($a7_2_1Value) phải = Tổng của 7.1.3. Số phòng tăng mới trong năm 2024 ($aSum_7_1_x_3Value)';
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  String? onValidateA7_4(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_4") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     int a7_4Value = answerTblPhieuMau[columnPhieuMauA7_4] != null
    //         ? AppUtils.convertStringToInt(answerTblPhieuMau[columnPhieuMauA7_4])
    //         : 0;
    //     int a7_1_1_4Val = answerTblPhieuMau[columnPhieuMauA7_1_1_4] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_1_4])
    //         : 0;
    //     int a7_1_2_4Val = answerTblPhieuMau[columnPhieuMauA7_1_2_4] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_2_4])
    //         : 0;
    //     int a7_1_3_4Val = answerTblPhieuMau[columnPhieuMauA7_1_3_4] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_3_4])
    //         : 0;
    //     int a7_1_4_4Val = answerTblPhieuMau[columnPhieuMauA7_1_4_4] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_4_4])
    //         : 0;
    //     int a7_1_5_4Val = answerTblPhieuMau[columnPhieuMauA7_1_5_4] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_5_4])
    //         : 0;
    //     var aSum_7_1_x_4Value =
    //         a7_1_1_4Val + a7_1_2_4Val + a7_1_3_4Val + a7_1_4_4Val + a7_1_5_4Val;
    //     if (a7_4Value != aSum_7_1_x_4Value) {
    //       return 'Giá trị câu 7.4 ($a7_4Value) phải = Tổng của 7.1.4. Số giường tại thời điểm 31/12/2024 ($aSum_7_1_x_4Value)';
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     int a7_4Value = phieuMau[columnPhieuMauA7_4] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_4])
    //         : 0;
    //     int a7_1_1_4Val = phieuMau[columnPhieuMauA7_1_1_4] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_1_4])
    //         : 0;
    //     int a7_1_2_4Val = phieuMau[columnPhieuMauA7_1_2_4] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_2_4])
    //         : 0;
    //     int a7_1_3_4Val = phieuMau[columnPhieuMauA7_1_3_4] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_3_4])
    //         : 0;
    //     int a7_1_4_4Val = phieuMau[columnPhieuMauA7_1_4_4] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_4_4])
    //         : 0;
    //     int a7_1_5_4Val = phieuMau[columnPhieuMauA7_1_5_4] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_5_4])
    //         : 0;
    //     var aSum_7_1_x_4Value =
    //         a7_1_1_4Val + a7_1_2_4Val + a7_1_3_4Val + a7_1_4_4Val + a7_1_5_4Val;
    //     if (a7_4Value != aSum_7_1_x_4Value) {
    //       return 'Giá trị câu 7.4 ($a7_4Value) phải = Tổng của 7.1.4. Số giường tại thời điểm 31/12/2024 ($aSum_7_1_x_4Value)';
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  String? onValidateA7_4_1(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_4_1") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     int a7_4_1Value = answerTblPhieuMau[columnPhieuMauA7_4_1] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_4_1])
    //         : 0;
    //     int a7_1_1_5Val = answerTblPhieuMau[columnPhieuMauA7_1_1_5] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_1_5])
    //         : 0;
    //     int a7_1_2_5Val = answerTblPhieuMau[columnPhieuMauA7_1_2_5] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_2_5])
    //         : 0;
    //     int a7_1_3_5Val = answerTblPhieuMau[columnPhieuMauA7_1_3_5] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_3_5])
    //         : 0;
    //     int a7_1_4_5Val = answerTblPhieuMau[columnPhieuMauA7_1_4_5] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_4_5])
    //         : 0;
    //     int a7_1_5_5Val = answerTblPhieuMau[columnPhieuMauA7_1_5_5] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_1_5_5])
    //         : 0;
    //     var aSum_7_1_x_5Value =
    //         a7_1_1_5Val + a7_1_2_5Val + a7_1_3_5Val + a7_1_4_5Val + a7_1_5_5Val;
    //     if (a7_4_1Value != aSum_7_1_x_5Value) {
    //       return 'Giá trị câu 7.4.1 ($a7_4_1Value) phải = Tổng của 7.1.5. Số giường tăng mới trong năm 2024 ($aSum_7_1_x_5Value)';
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     int a7_4_1Value = phieuMau[columnPhieuMauA7_4_1] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_4_1])
    //         : 0;
    //     int a7_1_1_5Val = phieuMau[columnPhieuMauA7_1_1_5] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_1_5])
    //         : 0;
    //     int a7_1_2_5Val = phieuMau[columnPhieuMauA7_1_2_5] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_2_5])
    //         : 0;
    //     int a7_1_3_5Val = phieuMau[columnPhieuMauA7_1_3_5] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_3_5])
    //         : 0;
    //     int a7_1_4_5Val = phieuMau[columnPhieuMauA7_1_4_5] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_4_5])
    //         : 0;
    //     int a7_1_5_5Val = phieuMau[columnPhieuMauA7_1_5_5] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_1_5_5])
    //         : 0;
    //     var aSum_7_1_x_5Value =
    //         a7_1_1_5Val + a7_1_2_5Val + a7_1_3_5Val + a7_1_4_5Val + a7_1_5_5Val;
    //     if (a7_4_1Value != aSum_7_1_x_5Value) {
    //       return 'Giá trị câu 7.4.1 ($a7_4_1Value) phải = Tổng của 7.1.5. Số giường tăng mới trong năm 2024 ($aSum_7_1_x_5Value)';
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  String? onValidateA7_5(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_5") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     double a7_5Value = answerTblPhieuMau[columnPhieuMauA7_5] != null
    //         ? AppUtils.convertStringToDouble(
    //             answerTblPhieuMau[columnPhieuMauA7_5])
    //         : 0;

    //     if (a7_5Value > 30 || a7_5Value > 30.0) {
    //       return 'Giá trị câu 7.5 ($a7_5Value) phải <=30. Vui lòng kiểm tra lại.';
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     double a7_5Value = phieuMau[columnPhieuMauA7_5] != null
    //         ? AppUtils.convertStringToDouble(phieuMau[columnPhieuMauA7_5])
    //         : 0;
    //     if (a7_5Value > 30 || a7_5Value > 30.0) {
    //       return 'Giá trị câu 7.5 ($a7_5Value) phải <=30. Vui lòng kiểm tra lại.';
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  String? onValidateA7_6_1(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_6" || maCauHoi == "A7_6_1") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     int a7_6Value = answerTblPhieuMau[columnPhieuMauA7_6] != null
    //         ? AppUtils.convertStringToInt(answerTblPhieuMau[columnPhieuMauA7_6])
    //         : 0;
    //     int a7_6_1Value = answerTblPhieuMau[columnPhieuMauA7_6_1] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_6_1])
    //         : 0;

    //     if (a7_6Value < a7_6_1Value) {
    //       if (maCauHoi == "A7_6") {
    //         return 'Giá trị câu 7.6 ($a7_6Value) phải >= câu 7.6.1 ($a7_6_1Value). Vui lòng kiểm tra lại.';
    //       } else if (maCauHoi == "A7_6_1") {
    //         return 'Giá trị câu 7.6.1 ($a7_6_1Value) phải <= câu 7.6 ($a7_6Value). Vui lòng kiểm tra lại.';
    //       }
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     int a7_6Value = phieuMau[columnPhieuMauA7_6] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_6])
    //         : 0;
    //     int a7_6_1Value = phieuMau[columnPhieuMauA7_6_1] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_6_1])
    //         : 0;
    //     if (a7_6Value < a7_6_1Value) {
    //       if (maCauHoi == "A7_6") {
    //         return 'Giá trị câu 7.6 ($a7_6Value) phải >= câu 7.6.1 ($a7_6_1Value). Vui lòng kiểm tra lại.';
    //       } else if (maCauHoi == "A7_6_1") {
    //         return 'Giá trị câu 7.6.1 ($a7_6_1Value) phải <= câu 7.6 ($a7_6Value). Vui lòng kiểm tra lại.';
    //       }
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  String? onValidateA7_7_1(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_7" || maCauHoi == "A7_7_1") {
    //   if (valueInput == null || valueInput == "null" || valueInput == "") {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   if (typing) {
    //     int a7_7Value = answerTblPhieuMau[columnPhieuMauA7_7] != null
    //         ? AppUtils.convertStringToInt(answerTblPhieuMau[columnPhieuMauA7_7])
    //         : 0;
    //     int a7_7_1Value = answerTblPhieuMau[columnPhieuMauA7_7_1] != null
    //         ? AppUtils.convertStringToInt(
    //             answerTblPhieuMau[columnPhieuMauA7_7_1])
    //         : 0;

    //     if (a7_7Value < a7_7_1Value) {
    //       if (maCauHoi == "A7_7") {
    //         return 'Giá trị câu 7.7 ($a7_7Value) phải >= câu 7.7.1 ($a7_7_1Value). Vui lòng kiểm tra lại.';
    //       } else if (maCauHoi == "A7_7_1") {
    //         return 'Giá trị câu 7.7.1 ($a7_7_1Value) phải <= câu 7.7 ($a7_7Value). Vui lòng kiểm tra lại.';
    //       }
    //     }

    //     return null;
    //   } else {
    //     var phieuMau = tblPhieuMau.value.toJson();
    //     int a7_7Value = phieuMau[columnPhieuMauA7_7] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_7])
    //         : 0;
    //     int a7_7_1Value = phieuMau[columnPhieuMauA7_7_1] != null
    //         ? AppUtils.convertStringToInt(phieuMau[columnPhieuMauA7_7_1])
    //         : 0;
    //     if (a7_7Value < a7_7_1Value) {
    //       if (maCauHoi == "A7_7") {
    //         return 'Giá trị câu 7.7 ($a7_7Value) phải >= câu 7.7.1 ($a7_7_1Value). Vui lòng kiểm tra lại.';
    //       } else if (maCauHoi == "A7_7_1") {
    //         return 'Giá trị câu 7.7.1 ($a7_7_1Value) phải <= câu 7.7 ($a7_7Value). Vui lòng kiểm tra lại.';
    //       }
    //     }
    //     return null;
    //   }
    // }
    return null;
  }

  ///VALIDATE KHI NHẤN NÚT Tiếp tục V2
  Future<String> validateAllFormV2() async {
    String result = '';
// ? Tỷ lệ gia công Câu 11 thêm giá trị lớn nhất nhỏ nhất vì nó tính %
    // var fieldNames = await getListFieldToValidate();
    // var tblP08 = tblPhieuMau.value.toJson();

    // for (var item in fieldNames) {
    //   if (currentScreenNo.value == item.manHinh) {
    //     if (item.tenTruong != null && item.tenTruong != '') {
    //       if (item.bangDuLieu == tablePhieuMau) {
    //         if (tblP08.isNotEmpty) {
    //           if (tblP08.containsKey(item.tenTruong)) {
    //             var val = tblP08[item.tenTruong];
    //             if (item.bangChiTieu == "2" ||
    //                 (item.bangChiTieu != null &&
    //                     item.bangChiTieu != '' &&
    //                     (item.bangChiTieu!.contains('CT_DM') ||
    //                         item.bangChiTieu!.contains('KT_DM')))) {
    //               var validRes = onValidateInputChiTieuDongCot(item.question!,
    //                   item.chiTieuCot, item.chiTieuDong, val.toString(),
    //                   fieldName: item.tenTruong, typing: false);
    //               if (validRes != null && validRes != '') {
    //                 result = await generateMessageV2(item.mucCauHoi, validRes);
    //                 break;
    //               }
    //             } else if (item.tenTruong == columnPhieuMauA1_5_4) {
    //               var validRes = onValidateInputDanToc(
    //                   item.bangDuLieu!,
    //                   item.maCauHoi!,
    //                   item.maCauHoi,
    //                   val.toString(),
    //                   item.loaiCauHoi!);
    //               if (validRes != null && validRes != '') {
    //                 result = await generateMessageV2(item.mucCauHoi, validRes);
    //                 break;
    //               }
    //               // }
    //               // //Bỏ không kiểm tra B, C, E
    //               // else if (item.tenTruong == 'A3_1_1' ||
    //               //     item.tenTruong == 'A3_1_2') {
    //               //   if (isNhomNganhCap1BCE == '0') {}
    //             } else {
    //               var validRes = onValidate(
    //                   item.bangDuLieu!,
    //                   item.maCauHoi!,
    //                   item.tenTruong,
    //                   val.toString(),
    //                   item.giaTriNN,
    //                   item.giaTriLN,
    //                   item.loaiCauHoi!,
    //                   false);
    //               if (validRes != null && validRes != '') {
    //                 result = await generateMessageV2(item.mucCauHoi, validRes);
    //                 break;
    //               }
    //             }
    //           }
    //         } else {
    //           /// todo thì làm chi đây  ???
    //           /// Không có trường hợp này: Vì đã insert 1 record trước khi vào bảng hỏi
    //         }
    //       }
    //     }
    //   }
    // }
    // var fieldNamesTableA5 = fieldNames
    //     .where((c) =>
    //         c.bangDuLieu == tablePhieuMauSanPham &&
    //         c.maCauHoi != 'A5_1' &&
    //         c.tenTruong != 'STT_Sanpham' &&
    //         c.tenTruong != 'STT')
    //     .toList();
    // if (fieldNamesTableA5.isNotEmpty) {
    //   if (tblPhieuMauSanPham.isNotEmpty) {
    //     var isReturn = false;
    //     for (var itemC8 in tblPhieuMauSanPham) {
    //       var tblA5 = itemC8.toJson();
    //       for (var fieldA5 in fieldNamesTableA5) {
    //         if (tblA5.containsKey(fieldA5.tenTruong)) {
    //           var val = tblA5[fieldA5.tenTruong];
    //           int sttSanPham =
    //               int.parse(tblA5[columnPhieuMauSanPhamSTTSanPham].toString());
    //           var validRes = onValidateInputA5(
    //               fieldA5.bangDuLieu!,
    //               fieldA5.maCauHoi!,
    //               fieldA5.tenTruong,
    //               tblA5[columnId],
    //               val.toString(),
    //               0,
    //               0,
    //               fieldA5.giaTriNN,
    //               fieldA5.giaTriLN,
    //               fieldA5.loaiCauHoi!,
    //               sttSanPham,
    //               false);
    //           if (validRes != null && validRes != '') {
    //             result = await generateMessageV2(
    //                 '${fieldA5.mucCauHoi}: STT=${tblA5[columnPhieuMauSanPhamSTTSanPham]}',
    //                 validRes);
    //             isReturn = true;
    //             break;
    //           }
    //         }
    //         if (isReturn) return result;
    //       }
    //     }
    //     var validRes = onValidateInputA5T(tablePhieuMauSanPham, "", false);
    //     if (validRes != null && validRes != '') {
    //       return validRes;
    //     }
    //   }
    // }
    // var fieldNamesTableA61 =
    //     fieldNames.where((c) => c.bangDuLieu == tablePhieuMauA61).toList();
    // if (fieldNamesTableA61.isNotEmpty) {
    //   if (tblPhieuMauA61.isEmpty) {
    //     result = await generateMessageV2('Câu 6.1', 'Vui lòng nhập giá trị.');
    //     return result;
    //   }
    //   if (tblPhieuMauA61.isNotEmpty) {
    //     var isReturn = false;
    //     for (var itemC8 in tblPhieuMauA61.value) {
    //       var tblC8 = itemC8.toJson();
    //       for (var fieldC8 in fieldNamesTableA61) {
    //         if (tblC8.containsKey(fieldC8.tenTruong)) {
    //           var val = tblC8[fieldC8.tenTruong];
    //           var validRes = onValidateInputA6_1(
    //               fieldC8.bangDuLieu!,
    //               fieldC8.maCauHoi!,
    //               fieldC8.tenTruong,
    //               tblC8[columnId],
    //               val.toString(),
    //               0,
    //               0,
    //               fieldC8.giaTriNN,
    //               fieldC8.giaTriLN,
    //               fieldC8.loaiCauHoi!);
    //           if (validRes != null && validRes != '') {
    //             result = await generateMessageV2(
    //                 '${fieldC8.mucCauHoi}: STT=${tblC8[columnSTT]}', validRes);
    //             isReturn = true;
    //             break;
    //           }
    //         }
    //         if (isReturn) return result;
    //       }
    //     }
    //   }
    // }
    // var fieldNamesTableA68 =
    //     fieldNames.where((c) => c.bangDuLieu == tablePhieuMauA68).toList();
    // if (fieldNamesTableA68.isNotEmpty) {
    //   if (tblPhieuMauA68.isEmpty) {
    //     result = await generateMessageV2('Câu 6.8', 'Vui lòng nhập giá trị.');
    //     return result;
    //   }
    //   if (tblPhieuMauA68.isNotEmpty) {
    //     var isReturn = false;
    //     for (var itemC8 in tblPhieuMauA68.value) {
    //       var tblC8 = itemC8.toJson();
    //       for (var fieldC8 in fieldNamesTableA68) {
    //         if (tblC8.containsKey(fieldC8.tenTruong)) {
    //           var val = tblC8[fieldC8.tenTruong];
    //           var validRes = onValidateInputA6_8(
    //               fieldC8.bangDuLieu!,
    //               fieldC8.maCauHoi!,
    //               fieldC8.tenTruong,
    //               tblC8[columnId],
    //               val.toString(),
    //               0,
    //               0,
    //               fieldC8.giaTriNN,
    //               fieldC8.giaTriLN,
    //               fieldC8.loaiCauHoi!);
    //           if (validRes != null && validRes != '') {
    //             result = await generateMessageV2(
    //                 '${fieldC8.mucCauHoi}: STT=${tblC8[columnSTT]}', validRes);
    //             isReturn = true;
    //             break;
    //           }
    //         }
    //         if (isReturn) return result;
    //       }
    //     }
    //   }
    // }
    return result;
  }

  Future<String> generateMessageV2(
      String? mucCauHoi, String? validResultMessage,
      {int? loaiCauHoi, String? maCauHoi}) async {
    String result = '';
    if (maCauHoi == 'E') {
      return 'Vui lòng kiểm tra lại phần E:\r\n${validResultMessage!}';
    }
    result = '$mucCauHoi: Vui lòng nhập giá trị.';
    if (loaiCauHoi == AppDefine.loaiCauHoi_1) {
      result = '$mucCauHoi: Vui lòng chọn giá trị.';
    }
    if (validResultMessage != null && validResultMessage != '') {
      result = '$mucCauHoi: \r\n$validResultMessage';
    }
    return result;
  }

  /// ? loaiSoSanh='empty': Empty; ==: So sánh bằng: ==; So sánh lớn hơn: >,....
  ///  minValue; maxValue
  ///
  Future<String> generateMessage(
      int loaiCauHoi, String tenNganCauHoi, String? mucCauHoi,
      {String? loaiSoSanh, minValue, maxValue, giaTriSoSanh}) async {
    String result = '';

    if (loaiSoSanh == "empty") {
      result = '$mucCauHoi: Vui lòng nhập giá trị.';
    }
    if (loaiSoSanh == "yesno") {
      result = '$mucCauHoi: Vui lòng chọn giá trị.';
    } else if (loaiSoSanh == "==") {
      result = '$mucCauHoi: Vui lòng kiểm tra lại giá trị.';
    } else if (loaiSoSanh == ">") {
      result = '$mucCauHoi: Vui lòng kiểm tra lại giá trị.';
    } else if (loaiSoSanh == "<") {
      result = '$mucCauHoi: Vui lòng kiểm tra lại giá trị.';
    }
    if (loaiCauHoi == AppDefine.loaiCauHoi_1) {
    } else if (loaiCauHoi == AppDefine.loaiCauHoi_2) {
    } else if (loaiCauHoi == AppDefine.loaiCauHoi_3) {
    } else if (loaiCauHoi == AppDefine.loaiCauHoi_4) {}
    return result;
  }

  ///

  ///END::Validation
  ///
  ///BEGIN::Tạo danh sách gồm các trường: ManHinh,MaCauHoi,TenTruong,...
  ///Mục đích: Dùng để lấy trường cho việc validate ở mỗi màn hình khi nhấn nút tiếp tục
  ///Danh sách trường này có thể chuyển qua lấy ở server ở chức năng lấy dữ liệu phỏng vấn.
  Future<List<QuestionFieldModel>> getListFieldToValidate() async {
    List<QuestionFieldModel> result = [];
    if (questions.isNotEmpty) {
      for (var item in questions) {
        QuestionFieldModel questionField = QuestionFieldModel(
            manHinh: item.manHinh,
            maCauHoi: item.maCauHoi,
            tenNganCauHoi: 'Câu ${item.maSo}',
            tenTruong: item.maCauHoi,
            loaiCauHoi: item.loaiCauHoi,
            giaTriLN: item.giaTriLN,
            giaTriNN: item.giaTriNN,
            bangChiTieu: item.bangChiTieu,
            bangDuLieu: item.bangDuLieu,
            question: item);
        result.add(questionField);
        //Trinh do chuyen mon
        if (item.maCauHoi == colPhieuMauTBA1_1) {
          QuestionFieldModel qField = QuestionFieldModel(
              manHinh: item.manHinh,
              maCauHoi: item.maCauHoi,
              tenNganCauHoi: 'Câu ${item.maSo}',
              mucCauHoi: 'Câu ${item.maSo}',
              tenTruong: '${item.maCauHoi}_GhiRo',
              loaiCauHoi: item.loaiCauHoi,
              giaTriLN: item.giaTriLN,
              giaTriNN: item.giaTriNN,
              bangChiTieu: item.bangChiTieu,
              bangDuLieu: item.bangDuLieu,
              question: item);
          result.add(qField);
        }

        if (item.bangChiTieu == '1') {
          if (item.danhSachChiTieu!.isNotEmpty) {
            var resCtCots = await getListFieldChiTieuCot(
                item.danhSachChiTieu!, questionField);
            if (resCtCots.isNotEmpty) {
              result.addAll(resCtCots);
            }
          }
        }
        if (item.bangChiTieu == '2') {
          var resCtDongIOs = await getListFieldChiTieuDong(
              item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
          if (resCtDongIOs.isNotEmpty) {
            result.addAll(resCtDongIOs);
          }
        }

        if (item.danhSachCauHoiCon!.isNotEmpty) {
          var res =
              await getListFieldToValidateCauHoiCon(item.danhSachCauHoiCon!);
          if (res.isNotEmpty) {
            result.addAll(res);
          }
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldToValidateCauHoiCon(
      List<QuestionCommonModel> questionsCon) async {
    List<QuestionFieldModel> result = [];
    if (questionsCon.isNotEmpty) {
      for (var item in questionsCon) {
        QuestionFieldModel questionField = QuestionFieldModel(
            manHinh: item.manHinh,
            maCauHoi: item.maCauHoi,
            tenNganCauHoi: 'Câu ${item.maSo}',
            mucCauHoi: 'Câu ${item.maSo}',
            tenTruong: item.maCauHoi,
            loaiCauHoi: item.loaiCauHoi,
            giaTriLN: item.giaTriLN,
            giaTriNN: item.giaTriNN,
            bangChiTieu: item.bangChiTieu,
            bangDuLieu: item.bangDuLieu,
            tenTruongKhoa: '',
            question: item);
        result.add(questionField);

        ///Trinh do chuyen mon
        if (item.maCauHoi == colPhieuMauTBA1_1) {
          QuestionFieldModel qField = QuestionFieldModel(
              manHinh: item.manHinh,
              maCauHoi: item.maCauHoi,
              tenNganCauHoi: 'Câu ${item.maSo}',
              mucCauHoi: 'Câu ${item.maSo}',
              tenTruong: '${item.maCauHoi}_GhiRo',
              loaiCauHoi: item.loaiCauHoi,
              giaTriLN: item.giaTriLN,
              giaTriNN: item.giaTriNN,
              bangChiTieu: item.bangChiTieu,
              bangDuLieu: item.bangDuLieu,
              question: item);
          result.add(qField);
        }
        if (item.bangChiTieu == '1') {
          if (item.danhSachChiTieu!.isNotEmpty) {
            var resCtCots = await getListFieldChiTieuCot(
                item.danhSachChiTieu!, questionField);
            if (resCtCots.isNotEmpty) {
              result.addAll(resCtCots);
            }
          }
        }
        if (item.bangChiTieu == '2') {
          var resCtDongIOs = await getListFieldChiTieuDong(
              item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
          if (resCtDongIOs.isNotEmpty) {
            result.addAll(resCtDongIOs);
          }
        }
        if (item.danhSachCauHoiCon!.isNotEmpty) {
          var res =
              await getListFieldToValidateCauHoiCon(item.danhSachCauHoiCon!);
          result.addAll(res);
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldChiTieuCot(
      List<ChiTieuModel> danhSachChiTieuCot,
      QuestionFieldModel questionModel) async {
    List<QuestionFieldModel> result = [];
    if (danhSachChiTieuCot.isNotEmpty) {
      for (var ctItem in danhSachChiTieuCot) {
        if (ctItem.loaiChiTieu.toString() == AppDefine.loaiChiTieu_1) {
          QuestionFieldModel qCtField = QuestionFieldModel(
              manHinh: questionModel.manHinh,
              maCauHoi: ctItem.maCauHoi,
              tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
              mucCauHoi:
                  '${questionModel.tenNganCauHoi}: Chỉ tiêu ${ctItem.tenChiTieu?.replaceAll('[sản phẩm]', '')}',
              tenTruong: '${ctItem.maCauHoi}_${ctItem.maChiTieu}',
              loaiCauHoi: ctItem.loaiCauHoi,
              giaTriLN: ctItem.giaTriLN,
              giaTriNN: ctItem.giaTriNN,
              bangChiTieu: questionModel.bangChiTieu,
              bangDuLieu: questionModel.bangDuLieu,
              tenTruongKhoa: '',
              question: questionModel.question,
              chiTieuCot: ctItem);
          result.add(qCtField);
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldChiTieuDong(
      List<ChiTieuModel> danhSachChiTieuCot,
      List<ChiTieuDongModel> danhSachChiTieuDong,
      QuestionFieldModel questionModel) async {
    List<QuestionFieldModel> result = [];
    if (danhSachChiTieuDong.isNotEmpty) {
      for (var ctDong in danhSachChiTieuDong) {
        if (ctDong.loaiCauHoi != AppDefine.loaiCauHoi_10 &&
            ctDong.maSo != AppDefine.maso_00 &&
            ctDong.maSo != AppDefine.maso_00) {}
        if (ctDong.loaiCauHoi != AppDefine.loaiCauHoi_10) {
          var ctCots = danhSachChiTieuCot
              .where((x) =>
                  x.maPhieu == ctDong.maPhieu &&
                  x.maCauHoi == ctDong.maCauHoi &&
                  (x.loaiChiTieu.toString() == AppDefine.loaiChiTieu_1))
              .toList();

          if (ctCots.isNotEmpty) {
            for (var ctCot in ctCots) {
              String fName = '${ctDong.maCauHoi}_${ctDong.maSo}';
              if (ctCot.maCauHoi == "A2_2" ||
                  ctCot.maCauHoi == "A2_3" ||
                  ctCot.maCauHoi == "A3_2" ||
                  ctCot.maCauHoi == "A4_5" ||
                  ctCot.maCauHoi == "A4_7" ||
                  ctCot.maCauHoi == "A7_1" ||
                  ctCot.maCauHoi == "A8_1") {
                if (ctCot.maCauHoi == "A4_7" && ctDong.maSo == '0') {
                  fName = '${ctDong.maCauHoi}_${ctDong.maSo}';
                } else {
                  fName = getFieldNameByMaCauChiTieuDongCot(ctCot, ctDong);
                }
              }
              String mucCauHoi =
                  '${questionModel.tenNganCauHoi} Mã số ${ctDong.maSo}';
              if (ctDong.maSo == '0') {
                mucCauHoi = '${questionModel.tenNganCauHoi}';
              }
              QuestionFieldModel qCtField = QuestionFieldModel(
                  manHinh: questionModel.manHinh,
                  maCauHoi: ctDong.maCauHoi,
                  tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
                  mucCauHoi: mucCauHoi,
                  tenTruong: fName,
                  loaiCauHoi: ctCot.loaiCauHoi,
                  giaTriLN: ctCot.giaTriLN,
                  giaTriNN: ctCot.giaTriNN,
                  bangChiTieu: questionModel.bangChiTieu,
                  bangDuLieu: questionModel.bangDuLieu,
                  tenTruongKhoa: '',
                  question: questionModel.question,
                  chiTieuCot: ctCot,
                  chiTieuDong: ctDong);
              result.add(qCtField);
              if (ctDong.maSo == '00' || ctDong.maSo == '10') {
                QuestionFieldModel qCtField = QuestionFieldModel(
                    manHinh: questionModel.manHinh,
                    maCauHoi: ctDong.maCauHoi,
                    tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
                    mucCauHoi:
                        '${questionModel.tenNganCauHoi} Mã số ${ctDong.maSo} Ghi rõ',
                    tenTruong: '${ctDong.maCauHoi}_${ctDong.maSo}_GhiRo',
                    loaiCauHoi: ctCot.loaiCauHoi,
                    giaTriLN: ctCot.giaTriLN,
                    giaTriNN: ctCot.giaTriNN,
                    bangChiTieu: questionModel.bangChiTieu,
                    bangDuLieu: questionModel.bangDuLieu,
                    tenTruongKhoa: '',
                    question: questionModel.question,
                    chiTieuCot: ctCot,
                    chiTieuDong: ctDong);
                result.add(qCtField);
              }
            }
          }
        }
      }
    }
    return result;
  }

  void onKetThucPhongVan() async {
    handleCompletedQuestion(
        tableThongTinNPV: completeInfo,
        onChangeName: (value) {
          onChangeCompleted(nguoiTraLoiBase, value);
        },
        onChangePhone: (value) {
          onChangeCompleted(soDienThoaiBase, value);
        },
        onChangeNameDTV: (value) {
          onChangeCompleted(hoTenDTVBase, value);
        },
        onChangePhoneDTV: (value) {
          onChangeCompleted(soDienThoaiDTVBase, value);
        },
        onUpdate: (Map updateValues) async {
          setLoading(true);
          await Future.wait(completeInfo.keys
              .map((e) => updateAnswerCompletedToDb(e, completeInfo[e])));
          await Future.wait(updateValues.keys
              .map((e) => updateAnswerCompletedToDb(e, updateValues[e])));
          if (glat == null && glng == null) {
            setLoading(false);
            var res = handleNoneLocation();
            return;
          }

          ///BEGIN::added by tuannb 06/082024: Cập nhật lại thời gian bắt đầu và kết thúc phỏng vấn phiếu
          if (generalInformationController.tblBkCoSoSXKD.value.maTrangThaiDT !=
              9) {
            await onChangeCompleted(ThoiGianBD, startTime.toIso8601String());
            await onChangeCompleted(
                ThoiGianKT, DateTime.now().toIso8601String());
          }
          bkCoSoSXKDProvider.updateTrangThai(currentIdCoSo!);
          AppPref.setQuestionNoStartTime = '';
          final sTimeLog = AppPref.getQuestionNoStartTime;
          log('AppPref.getQuestionNoStartTime $sTimeLog');

          ///END:: added
          ///
          setLoading(false);
          Get.offAllNamed(AppRoutes.mainMenu);
          //  onBackInterviewListDetail();
        });
  }

/***********/
  ///
  ///BEGIN::Kiểm tra ma ngành cho các phần III câu 3.1, Phần V, VI, VII
  ///
  // Future checkMaNganhCap1BCEByMaVCPA() async {
  //   var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
  //       .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
  //   if (maNganhs.isNotEmpty) {
  //     var res = await dmNhomNganhVcpaProvider.checkMaNganhCap1BCEByMaVCPA(maNganhs);
  //     return res;
  //   }
  //   return false;
  // }
  ///END::Kiểm tra ma ngành cho các phần III câu 3.1, Phần V, VI, VII
/***********/

  ///BEGIN:: PHẦN V
  // onOpenDialogSearchType(
  //     QuestionCommonModel question,
  //     String fieldName,
  //     TablePhieuMauTBSanPham product,
  //     int idValue,
  //     int stt,
  //     String motaSp,
  //     value) async {
  //   var sType = getSearchType();
  //   Get.dialog(DialogCustomizeWidget(
  //     onPressedNegative: () async {
  //       Get.back();
  //     },
  //     onPressedPositive: () async {
  //       if (searchVcpaType.value == 2) {
  //         if (NetworkService.connectionType == Network.none) {
  //           if (isInitializedEvaluator.value) {
  //             Get.key.currentState?.pop();
  //             await onFocusOpenDialogVcpa(
  //                 question, fieldName, product, idValue, stt, motaSp, value);
  //           } else {
  //             snackBar(
  //                 'Thông báo',
  //                 responseMessageAI.value == ''
  //                     ? 'Khởi tạo dữ liệu AI bị lỗi'
  //                     : responseMessageAI.value,
  //                 style: ToastSnackType.error);
  //           }
  //         } else {
  //           Get.key.currentState?.pop();
  //           await onFocusOpenDialogVcpa(
  //               question, fieldName, product, idValue, stt, motaSp, value);
  //         }
  //       } else {
  //         Get.key.currentState?.pop();
  //         await onFocusOpenDialogVcpa(
  //             question, fieldName, product, idValue, stt, motaSp, value);
  //       }
  //     },
  //     title: 'Chọn hình thức tìm kiếm',
  //     body: Obx(() => SelectOne(
  //         onChange: onChangeSearhType,
  //         listValue: sType,
  //         value: searchVcpaType.value)),
  //   ));
  // }

  onOpenDialogSearchType(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuMauTBSanPham product,
      int idValue,
      int stt,
      String motaSp,
      value) async {
    var sType = getSearchType();
    await onFocusOpenDialogVcpa(
        question, fieldName, product, idValue, stt, motaSp, value);
  }

  onChangeSearhType(int value) async {
    debugPrint('Search type: $value');
    searchVcpaType.value = value;
    if (searchVcpaType.value == 0) {
      if (NetworkService.connectionType == Network.none) {
        // return snackBar('Thông báo', 'no_connect_internet'.tr,
        //     style: ToastSnackType.error);
        debugPrint(
            'isInitializedEvaluator.value = ${isInitializedEvaluator.value}');
        if (isInitializedEvaluator.value == false) {
          setLoading(true);
          await initializeEvaluator();
          setLoading(false);
        }
      }
    }
  }

  // Initialization methods
  Future<void> initializeEvaluator() async {
    isInitializedEvaluator.value = false;
    log('Loading model and resources...');
    try {
      final currentFilePath =
          '${AppPref.dataModelAIFilePath}/${AppPref.dataModelAIVersionFileName}';
      final currentFile = File(currentFilePath);
      var isCurrentFileExist = await currentFile.exists();
      if (!isCurrentFileExist) {
        return snackBar('Thông báo',
            'Chưa có dữ liệu AI. Vui lòng thực hiện cập nhật dữ liệu AI',
            style: ToastSnackType.error);
      }

      final startTime = DateTime.now();
      await _evaluator.initialize();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      isInitializedEvaluator.value = true;
      log('Model ready! Initialization took ${duration.inMilliseconds}ms');
    } catch (e) {
      isInitializedEvaluator.value = false;
      log('Initialization failed: $e');
      responseMessageAI.value = 'Khởi tạo dữ liệu AI bị lỗi ${e.toString()}';
      snackBar('Thông báo', 'Khởi tạo dữ liệu AI bị lỗi ${e.toString()}',
          style: ToastSnackType.error);
    }
  }

  onFocusOpenDialogVcpa(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuMauTBSanPham product,
      int idValue,
      int stt,
      String motaSp,
      value) async {
    tblDmMoTaSanPhamSearch.clear();
    tblDmMoTaSanPhamSearch.refresh();
    sanPhamIdSelected.value = idValue;
    moTaSpSelected.value = motaSp;
    await getLinhVucSelected(product.a5_1_1 ?? '');

    if (searchVcpaType.value == 1) {
      //  await onSearchVcpaCap5(motaSp);
      await onStartSearchVcpaCap5(moTaSpSelected.value ?? '');
    } else {
      startSearch.value = false;
    }
    tblDmMoTaSanPhamSearch.refresh();
    String searchTypeText = searchVcpaType.value == 1 ? 'AI' : 'Danh mục';
    Get.dialog(Dialog.fullscreen(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
              //  width: Get.width,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              // decoration: const BoxDecoration(
              //   color: Colors.white70,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dialogHeaderContent(searchTypeText),
                  // const Divider(),
                  // Obx(() {
                  //   tblDmMoTaSanPhamSearch.refresh();
                  //   return tabContent(question, fieldName, product, idValue,
                  //       stt, motaSp, value);
                  //   //return tabContent(question, fieldName, product, idValue,  stt, motaSp, value);
                  // })
                  Obx(() {
                    tblDmMoTaSanPhamSearch.refresh();

                    return SearchVcpaTab(
                        aiTab: tabContent(question, fieldName, product, idValue,
                            stt, moTaSpSelected.value, value),
                        dmTab: tabContent(question, fieldName, product, idValue,
                            stt, moTaSpSelected.value, value),
                        onTabPress: (index) => onTabPress(index));
                  })
                ],
              ))
        ]))));
  }

  getLinhVucSelected(String maSp) async {
    if (maSp == '') {
      linhVucSelected.value = TableDmLinhvuc.defaultLinhVuc();
      return;
    }
    var mtSp = await dmMotaSanphamProvider.getByVcpaCap5(maSp);
    if (mtSp != null) {
      var mtSpItem = TableDmMotaSanpham.fromJson(mtSp);
      if (mtSpItem != null) {
        if (mtSpItem.maLV != null && mtSpItem.maLV != '') {
          var lv = dmLinhvucSpProvider.getByMaLV(mtSpItem.maLV!);
          if (lv != null) {
            var lvItem = TableDmLinhvuc.fromJson(mtSp);
            linhVucSelected.value = lvItem;
            maLVSelected.value = lvItem.maLV!;
          }
        }
      }
    }
  }

  dialogHeaderContent(String searchTypeText) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tìm kiếm ngành sản phẩm',
            style: styleMedium.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        // const Spacer(),
        ElevatedButton(
          onPressed: () {
            onCloseSearch();
          },
          // styling the button
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(0),
              // Button color
              backgroundColor: Colors.white,
              // Splash color
              foregroundColor: primaryColor,
              elevation: 1.0,
              side: const BorderSide(color: primaryColor)),
          child: const Text('Đóng'),
        ),
      ],
    );
  }

  tabContent(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuMauTBSanPham product,
      int idValue,
      int stt,
      String motaSp,
      value) {
    // return Obx(() {
    // tblDmMoTaSanPhamSearch.refresh();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Lĩnh vực', style: styleMedium),
        if (searchVcpaType.value == 0)
          Text(
            aIModeStatus.value,
            style: TextStyle(
                color: aIModeStatus.value == 'Online'
                    ? Colors.green
                    : Colors.grey),
          ),
      ]),
      InputDecorator(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          isEmpty: value == null || value == '',
          child: DropdownButtonHideUnderline(
              child: DropdownCategory(
            onLinhVucSelected: (item) => onLinhVucSelected(item),
            danhSachLinhVuc: tblLinhVucSp,
            linhVucItemSelected: linhVucSelected.value,
          ))),
      const SizedBox(
        height: 18,
      ),
      SearchSpVcpa(
        onChangeListViewItem: (item, product) =>
            onChangeListViewItem(item, product),
        value: motaSp,
        onChangeText: (inputValue) => onChangeSearchText(inputValue),
        onPressSearch: () => onPressSearch(),
        filteredList: tblDmMoTaSanPhamSearch,
        phieuMauSpItem: product,
        searchType: searchVcpaType.value,
        startSearch: startSearch.value,
        onChangeSlider: (value) => onChangeSlider(value),
        responseMessage: responseMessageAI.value,
      )
    ]);
    // });
  }

  onChangeSlider(value) async {
    limitNumSearchAI.value = value;
  }

  onTabPress(idx) async {
    debugPrint('Tab pressed $idx');
    tblDmMoTaSanPhamSearch.clear();
    tblDmMoTaSanPhamSearch.refresh();
    searchVcpaType.value = idx ?? 0;
    if (idx == 0) {
      await showDialogForAI();
    }
    await onStartSearchVcpaCap5(moTaSpSelected.value ?? '');
  }

  showDialogForAI() async {
    if (NetworkService.connectionType == Network.none) {
      if (isInitializedEvaluator.value) {
      } else {
        snackBar(
            'Thông báo',
            responseMessageAI.value == ''
                ? 'Khởi tạo dữ liệu AI bị lỗi'
                : responseMessageAI.value,
            style: ToastSnackType.error);
      }
    } else {}
  }

  onChangeListViewItem(
      TableDmMotaSanpham item, TablePhieuMauTBSanPham phieuMauSpItem) async {
    debugPrint(
        "onChangeListViewItem linh vuc ${item?.maSanPham} - ${item?.tenSanPham}");
    log('ON onChangeListViewItem id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected');
    try {
      if (sanPhamIdSelected.value == phieuMauSpItem.id) {}
      String vcpaCapx = '';
      String donViTinh = '';
      int idVal = phieuMauSpItem.id!;
      int stt = phieuMauSpItem.sTTSanPham!;
      vcpaCapx = item.maSanPham!;
      donViTinh = item.donViTinh ?? '';
      String mota = moTaSpSelected.value;
      var res = kiemTraMaVCPACap5(vcpaCapx);
      if (res) {
        await updateToDbSanPham(tablePhieuMauTBSanPham,
            colPhieuMauTBSanPhamA5_1_2, idVal, vcpaCapx);
        /**
             * todo  KIỂM TRA MÃ SẢN PHẨM CẤP 1 LÀ B, C, D, E:
             * => CT_Phieu_NganhCN phiếu 7.1 CN
             * todo   - Phải cập nhật thông sản phẩm đó cho bảng CT_Phieu_NganhCN
             * todo   - Ngược lại XOÁ thông tin sản phẩm đó ở bảng CT_Phieu_NganhCN
             * 
             */
        var hasBCDE = await hasA5_3BCDE(vcpaCapx);
        if (hasBCDE) {}
        /**
             * todo  KIỂM TRA MÃ SẢN PHẨM CẤP 1 LÀ G VÀ NGÀNH CẤP 4 LÀ 6810 (TRỪ CÁC MÃ 4513, 4520, 45413, 4542, 461)
             *  => CT_Phieu_NganhTM_SanPham
             * todo   - Phải cập nhật thông tin sản phẩm đó cho bảng CT_Phieu_NganhTM_Sanpham
             * todo   - Ngược lại XOÁ thông tin sản phẩm đó ở bảng CT_Phieu_NganhTM_Sanpham
             * 
             */
        ///Kiểm tra: [MÃ SẢN PHẨM CẤP 1 LÀ G VÀ NGÀNH L6810  (TRỪ CÁC MÃ 4513-4520-45413-4542-461)]
        var hasVcpa = await hasA5_5G_L6810(vcpaCapx);
        if (hasVcpa) {}

        Map<String, dynamic> ddSp = {
          ddSpId: idVal,
          ddSpMaSanPham: vcpaCapx,
          ddSpSttSanPham: stt,
          ddSpIsCap1GL: hasVcpa
        };
        await updateAnswerDanhDauSanPhamByMap(stt, ddSp);
        var hasCap2PhanV = await hasCap2_56PhanV(vcpaCapx, vcpaCap2PhanV);
        Map<String, dynamic> ddSpCap2PhanV = {
          ddSpId: idVal,
          ddSpMaSanPham: vcpaCapx,
          ddSpSttSanPham: stt,
          ddSpIsCap2_56: hasCap2PhanV
        };
        await updateAnswerDanhDauSanPhamByMap(stt, ddSpCap2PhanV);
        //   await updateToDbSanPham(tablePhieuMauSanPham,  columnPhieuMauSanPhamDonViTinh, idVal, donViTinh);

        await getTablePhieuMauTBSanPham();

        snackBar('Thông báo', 'Đã cập nhật');
        log('ON onChangeListViewItem ĐÃ cập nhật mã VCPA cấp 5 vào bảng $tablePhieuMauTBSanPham');
      } else {
        log('ON onChangeListViewItem chưa cập nhật mã VCPA cấp 5 vào bảng $tablePhieuMauTBSanPham');
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void onLinhVucSelected(TableDmLinhvuc item) async {
    //Goi search lại khi
    debugPrint(
        "onLinhVucSelected linh vuc ${item?.maLV} - ${item?.tenLinhVuc}");
    log('ON onLinhVucSelected id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected');
    maLVSelected.value = item.maLV!;
    String moTaSp = moTaSpSelected.value;
    await onSearchVcpaCap5(moTaSp);
  }

  void onPressSearch() async {
    debugPrint('onPressSearch ${moTaSpSelected.value}');
    await onStartSearchVcpaCap5(moTaSpSelected.value ?? '');
  }

  onCloseSearch() async {
    sanPhamIdSelected.value = 0;
    moTaSpSelected.value = '';
    tblDmMoTaSanPhamSearch.clear();
    tblDmMoTaSanPhamSearch.refresh();
    tblPhieuMauTBSanPham.refresh();
    update();
    log('ON onCloseSearch id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected $tblDmMoTaSanPhamSearch');

    Get.back();
    //
  }

  Future onStartSearchVcpaCap5(String keyword) async {
    debugPrint('onStartSearchVcpaCap5 $keyword');
    tblDmMoTaSanPhamSearch.clear();
    tblDmMoTaSanPhamSearch.refresh();
    keywordVcpaCap5.value = keyword;
    startSearch.value = true;
    responseMessageAI.value = '';
    EasyDebounce.debounce(
      'search_debounce',
      Duration(milliseconds: 400),
      () => onSearchVcpaCap5(moTaSpSelected.value ?? ''),
    );
    //  return await onSearchVcpaCap5(keyword);
  }

  Future<Iterable<TableDmMotaSanpham?>> onSearchVcpaCap5(String keyword) async {
    debugPrint('onSearchVcpaCap5 $keyword');
    // keywordVcpaCap5.value = keyword;
    // startSearch.value = true;
    // responseMessageAI.value = '';
    if (keyword.isEmpty) {
      tblDmMoTaSanPhamSearch.clear();
      tblDmMoTaSanPhamSearch.refresh();
    }
    if (keyword.isNotEmpty) {
      if (searchVcpaType.value == 1) {
        List<Map> vcpaCap5s = await dmMotaSanphamProvider
            .searchVcpaCap5ByLinhVuc(keyword, maLVSelected.value,5);
        var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));

        tblDmMoTaSanPhamSearch.value = result.toList();
        tblDmMoTaSanPhamSearch.refresh();
        log('SEARCH RESULT: ${vcpaCap5s.length}');
        startSearch.value = false;
        responseMessageAI.value = '';
        return result;
      } else if (searchVcpaType.value == 0) {
        ///Tìm kiếm offline với AI
        print('NetworkService.connectionType ${NetworkService.connectionType}');
        if (NetworkService.connectionType == Network.none) {
          debugPrint('OFFLINE onSearchVcpaCap5 $keyword');
          if (isInitializedEvaluator.value) {
            final predictions = await _evaluator
                .predict([keyword], topK: limitNumSearchAIValue);
            List<PredictionResult> _results =
                predictions.isNotEmpty ? predictions.first : [];
            List<Map> vcpaCap5s = await dmMotaSanphamProvider
                .mapResultAIToDmSanPhamOffline(_results, maLVSelected.value);
            var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));
            tblDmMoTaSanPhamSearch.value = result.toList();
            tblDmMoTaSanPhamSearch.refresh();
            debugPrint('OFFLINE SEARCH RESULT ${result.length}');
            startSearch.value = false;
            responseMessageAI.value = '';
            return result;
          }
        } else {
          ///Tìm kiếm online với AI
          var response = await vcpaVsicAIRepository.searchVcpaVsicByAI(
              'vcpa', keyword,
              limitNum: limitNumSearchAIValue);
          debugPrint('searchVcpaVsicByAI ${response.statusCode}.');
          if (response.statusCode == 200) {
            if (response.body != null) {
              if (response.body!.isNotEmpty) {
                var res = response.body!;
                List<Map> vcpaCap5s = await dmMotaSanphamProvider
                    .mapResultAIToDmSanPham(res, maLVSelected.value);
                var result =
                    vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));
                tblDmMoTaSanPhamSearch.value = result.toList();
                tblDmMoTaSanPhamSearch.refresh();
                log('SEARCH RESULT: ${result.length}');
                startSearch.value = false;
                responseMessageAI.value = '';
                return result;
              }
            }
          } else if (response.statusCode == ApiConstants.errorDisconnect) {
            responseMessageAI.value = 'no_connect_internet'.tr;
          } else if (response.statusCode.toString() ==
              ApiConstants.requestTimeOut) {
            responseMessageAI.value = 'Request timeout.';
          } else {
            responseMessageAI.value = response.message ?? '';
          }
        }
      }
    }
    startSearch.value = false;
    return [];
  }

  onChangeSearchText(text) async {
    debugPrint('ON onChangeSearchText: $text');
    moTaSpSelected.value = text;
  }

  onChangeSearchVCPACap5(String table, String maCauHoi, String? fieldName,
      idValue, stt, value) async {
    log('ON onChangeSearchVCPACap5: $fieldName $value');
    moTaSpSelected.value = value;
  }

  onChangeInputVCPACap5(String table, String maCauHoi, String? fieldName,
      idValue, stt, value) async {
    log('ON onChangeInputVCPACap5: $fieldName $value');
    // moTaSpSelected.value = value;
    log('ON onChangeInputVCPACap5 id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected');
    try {
      // if (table == tablePhieuMauSanPham) {
      //   String vcpaCap5 = '';
      //   String donViTinh = '';
      //   if (value is TableDmMotaSanpham) {
      //     TableDmMotaSanpham valueInput = value;
      //     if (valueInput != null) {
      //       vcpaCap5 = valueInput.maSanPham!;
      //       donViTinh = valueInput.donViTinh ?? '';
      //     }
      //   } else if (value is String) {
      //     vcpaCap5 = value;
      //   }
      //   var res = kiemTraMaVCPACap5(value);
      //   if (res) {
      //     await updateToDbSanPham(table, fieldName!, idValue, vcpaCap5);
      //     await updateToDbSanPham(
      //         table, columnPhieuMauSanPhamDonViTinh!, idValue, donViTinh);

      //     ///Kiểm tra: [MÃ SẢN PHẨM CẤP 1 LÀ G VÀ NGÀNH L6810  (TRỪ CÁC MÃ 4513-4520-45413-4542-461)] => HỎI CÂU 5.5
      //     var hasVcpa = await hasA5_5G_L6810(vcpaCap5);
      //     Map<String, dynamic> ddSp = {
      //       ddSpId: idValue,
      //       ddSpMaSanPham: vcpaCap5,
      //       ddSpSttSanPham: stt,
      //       ddSpIsCap1GL: hasVcpa
      //     };
      //     await updateAnswerDanhDauSanPhamByMap(stt, ddSp);
      //     var hasCap2PhanV = await hasCap2_56PhanV(vcpaCap5, vcpaCap2PhanV);
      //     Map<String, dynamic> ddSpCap2PhanV = {
      //       ddSpId: idValue,
      //       ddSpMaSanPham: vcpaCap5,
      //       ddSpSttSanPham: stt,
      //       ddSpIsCap2_56: hasCap2PhanV
      //     };
      //     await updateAnswerDanhDauSanPhamByMap(stt, ddSpCap2PhanV);
      //     // log('ON onChangeInputVCPACap5A4_3 ĐÃ cập nhật mã VCPA cấp 5 vào bảng $tablePhieuMauSanPham');
      //   } else {
      //     //log('ON onChangeInputVCPACap5A4_3 chưa cập nhật mã VCPA cấp 5 vào bảng $tablePhieuMauSanPham');
      //   }
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  kiemTraMaVCPACap5(valueInput) {
    if (valueInput is TableDmMotaSanpham) {
      if (valueInput != null) {
        if (valueInput.maSanPham != null && valueInput.maSanPham != '') {
          var res = tblDmMoTaSanPhamSearch
              .where((x) => x.maSanPham == valueInput.maSanPham!)
              .firstOrNull;
          if (res != null) {
            return res.maSanPham != '';
          }
        }
      }
    } else if (valueInput is String) {
      var res = tblDmMoTaSanPhamSearch
          .where((x) => x.maSanPham == valueInput!)
          .firstOrNull;
      if (res != null) {
        return res.maSanPham != '';
      }
    }

    return false;
  }

  bool allowDeleteProduct(TablePhieuMauTBSanPham product) {
    if (product != null) {
      if (product.sTTSanPham! != sttProduct.value) {
        return true;
      }
    }
    return false;
  }

  onSelectYesNoProduct(String table, String? maCauHoi, String? fieldName,
      int idValue, value) async {
    // if (table == tablePhieuMauSanPham) {
    //   await phieuMauSanPhamProvider.updateValue(
    //       fieldName!, value, currentIdCoSo);
    //   await getTablePhieuSanPham();
    //   // var a5_0Val = getValueA5_0(table, 'A5_0');
    //   var countItem = countProduct(table);
    //   if (countItem == 1 && value == 1) {
    //     await insertNewRecordSanPham();
    //   }
    //   if (value == 2 && countItem > 0) {
    //     ///delete san pham isdefault!=1;
    //     Get.dialog(DialogBarrierWidget(
    //       onPressedNegative: () async {
    //         await excueteSet1(fieldName!);
    //         Get.back();
    //       },
    //       onPressedPositive: () async {
    //         await excueteDeleteProductItem();
    //         Get.back();
    //       },
    //       title: 'dialog_title_warning'.tr,
    //       content: 'Bạn có chắc chắn xoá các sản phẩm thêm mới?',
    //     ));
    //   }
    //   await getTablePhieuSanPham();
    // }
  }

  excueteSet1(String fieldName) async {
    await phieuMauTBSanPhamProvider.updateValue(fieldName, 1, currentIdCoSo);
    await getTablePhieuMauTBSanPham();
  }

  excueteDeleteProductItem() async {
    await phieuMauTBSanPhamProvider.deleteNotIsDefault(currentIdCoSo!);
    await getTablePhieuMauTBSanPham();
  }

  onSelectDmPhanV(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, int idValue, value, dmItem) {
    log('ON CHANGE onSelectDmPhanV: $fieldName $value $dmItem');
    try {
      // updateToDbSanPham(table, fieldName!, idValue, value);
      // if (maCauHoi == columnPhieuMauSanPhamA5_6) {
      //   if (value != null && (value == 2 || value == '2')) {
      //     updateToDbSanPham(table, columnPhieuMauSanPhamA5_6_1, idValue, null);
      //   }
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  onChangeInputPhanV(
    String table,
    String? maCauHoi,
    String? fieldName,
    int idValue,
    value,
  ) async {
    log('ON onChangeInputPhanV: id= $idValue $fieldName $value');

    try {
      await updateToDbSanPham(table, fieldName!, idValue, value);
      if (maCauHoi == "A5_2") {
        var total5TValue = await total5T();
        await updateAnswerToDB(tablePhieuMauTB, colPhieuMauTBA5T, total5TValue);
        var a5MValue =
            getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA5_M);
        if (a5MValue != null) {
          await tinhCapNhatA8_M_A9_M_A10_M(a5MValue);
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  total5T() async {
    var a4_1Value = answerTblPhieuMau['A4_1'];
    var a4_1Val = 0.0;
    if (a4_1Value != null) {
      a4_1Val = AppUtils.convertStringToDouble(a4_1Value);
    }
    var sumA5_2 = await phieuMauTBSanPhamProvider.totalA5_2(currentIdCoSo);
    var total = a4_1Val * sumA5_2;

    return total;
  }

  totalA3TNganhtTM() async {
    var a4_1Value = answerTblPhieuMau['A4_1'];
    var a4_1Val = 0.0;
    if (a4_1Value != null) {
      a4_1Val = AppUtils.convertStringToDouble(a4_1Value);
    }

    var a3Value =
        getValueByFieldNameFromDB(tablePhieuNganhTM, colPhieuNganhTMA3);

    var a3Val = 0.0;
    if (a3Value != null) {
      a3Val = AppUtils.convertStringToDouble(a3Value);
    }
    var total = a3Val * a4_1Val;

    return total;
  }

  onDeleteProduct(id) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await executeConfirmDeleteProduct(id);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: 'Bạn có chắc muốn xoá sản phẩm này?',
    ));
  }

  executeConfirmDeleteProduct(id) async {
    await xacNhanLogicProvider.deleteByIdHoManHinh(
        currentIdCoSo!, currentScreenNo.value);
    await phieuMauTBSanPhamProvider.deleteById(id);

    ///Tính lại  A5T: 5T. Tổng doanh thu của các sản phẩm năm 2025 (Tổng các câu A5.2*A4.1)
    ///Tính lại A8: Doanh thu khách ngủ qua đêm(= câu 5.2 của phiếu TB * câu 5: Doanh thu từ khách ngủ qua đêm chiếm bao nhiêu phần trăm trong tổng doanh thu?)
    ///Tính lại A9: Doanh thu khách không ngủ qua đêm (=câu 5.2 - câu 8: doanh thu khách ngủ qua đêm)
    ///Tính lại A10: Số ngày khách do cơ sở lưu trú phục vụ = A8/A6(Giá bình quân 1 đêm/khách là bao nhiêu?)
    /// (cũ A5_7 và A7_10A7_11A7_13 )
    var total5TValue = await total5T();
    await updateAnswerToDB(tablePhieuMauTB, colPhieuMauTBA5T, total5TValue);
    var a5MValue = getValueByFieldName(
        tablePhieuMauTB, colPhieuNganhLTA5_M); //columnPhieuMauA7_9
    if (a5MValue != null) {
      await tinhCapNhatA8_M_A9_M_A10_M(a5MValue);
    }

    /**
     * todo Kiểm tra lại 
     * B,C,D,E => bảng ngàng NganhCN
     *  => Delete record nếu không thoả điều kiện
     * Vận tải hành khách, hàng hoá => Bảng NganhVT
     *  => Delete record nếu không thoả điều kiện 
     * Lưu trú => Bảng NganhLT
     *  => Delete record nếu không thoả điều kiện
     * Thương mại => NganhTM, NganhTMSanpham
     *  => Delete record nếu không thoả điều kiện
     * todo
      **/

    await getTablePhieuMauTBSanPham();
    await getTablePhieuNganhCN();
    await getTablePhieuNganhVT();
    await getTablePhieuNganhLT();
    await getTablePhieuNganhTM();
    await getTablePhieuNganhTMSanPham();

    await danhDauSanPhamPhanVI();
    await danhDauSanPhamPhanVII();
  }

  addNewRowProduct() async {
    await insertNewRecordSanPham();
    await getTablePhieuMauTBSanPham();
  }

  updateToDbSanPham(String table, String fieldName, idValue, value) async {
    var res = await phieuMauTBSanPhamProvider.isExistProductById(
        currentIdCoSo!, idValue);
    if (res) {
      await phieuMauTBSanPhamProvider.updateValueByIdCoso(
          fieldName, value, currentIdCoSo, idValue);
      if (value.toString().length >= 5) {
        var cap5 = value.toString().substring(0, 5);
        await phieuMauTBSanPhamProvider.updateValueByIdCoso(
            colPhieuMauTBSanPhamMaNganhC5, cap5, currentIdCoSo, idValue);
      }
    }
    await getTablePhieuMauTBSanPham();
  }

  Future<TablePhieuMauTBSanPham> createSanPhamItem() async {
    var maxStt =
        await phieuMauTBSanPhamProvider.getMaxSTTByIdCoso(currentIdCoSo!);
    maxStt = maxStt + 1;
    var tblSp = TablePhieuMauTBSanPham(
        iDCoSo: currentIdCoSo,
        sTTSanPham: maxStt,
        maDTV: AppPref.uid,
        isDefault: 0);
    return tblSp;
  }

  ///
  Future insertNewRecordSanPham() async {
    var tblSp = await createSanPhamItem();
    List<TablePhieuMauTBSanPham> tblSps = [];
    tblSps.add(tblSp);

    phieuMauTBSanPhamProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
  }

  getValueSanPham(String table, String fieldName, int id) {
    if (table == tablePhieuMauTBSanPham) {
      var tblTmp = tblPhieuMauTBSanPham.where((x) => x.id == id).firstOrNull;
      if (tblTmp != null) {
        var tbl = tblTmp.toJson();
        return tbl[fieldName];
      }
    } else if (table == tablePhieuNganhTMSanPham) {
      var tblTmp = tblPhieuNganhTMSanPham.where((x) => x.id == id).firstOrNull;
      if (tblTmp != null) {
        var tbl = tblTmp.toJson();
        return tbl[fieldName];
      }
    }
    return null;
  }

  getValueSanPhamByStt(String table, String fieldName, int stt) {
    if (table == tablePhieuMauTBSanPham) {
      var tblTmp = tblPhieuMauTBSanPham
          .where((x) => x.sTTSanPham == stt && x.iDCoSo == currentIdCoSo!)
          .firstOrNull;
      if (tblTmp != null) {
        var tbl = tblTmp.toJson();
        return tbl[fieldName];
      }
    } else if (table == tablePhieuNganhTMSanPham) {
      var tblTmp = tblPhieuNganhTMSanPham
          .where((x) => x.sTT_SanPham == stt && x.iDCoSo == currentIdCoSo!)
          .firstOrNull;
      if (tblTmp != null) {
        var tbl = tblTmp.toJson();
        return tbl[fieldName];
      }
    }
    return null;
  }

  getValueA5_0(String table, String fieldName) {
    if (table == tablePhieuMauTBSanPham) {
      var item =
          tblPhieuMauTBSanPham.where((x) => x.isDefault == 1).firstOrNull;
      if (item != null) {
        var tbl = item.toJson();
        return tbl[fieldName];
      }
    }
    return null;
  }

  countProduct(String table) {
    if (table == tablePhieuMauTBSanPham) {
      var countItem = tblPhieuMauTBSanPham.length;
      return countItem;
    }
    return 0;
  }

  countHasMoreProduct(String table) {
    if (table == tablePhieuMauTBSanPham) {
      var countItem = tblPhieuMauTBSanPham
          .where((x) =>
              x.maNganhC5 != null &&
              x.a5_1_1 != null &&
              x.a5_1_2 != null &&
              x.a5_2 != null &&
              x.iDCoSo == currentIdCoSo)
          .length;
      return countItem;
    }
    return 0;
  }

  ///V
  hasA5_3BCDE(String maSanPham) async {
    if (maSanPham == '') {
      return true;
    }
    var result =
        await dmMotaSanphamProvider.kiemTraMaNganhCap1BCDEByMaVCPA(maSanPham);
    return result;
  }

  hasAllSanPhamBCDE() async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      var result = await dmMotaSanphamProvider
          .kiemTraMaNganhCap1BCDEByMaVCPA(resMaSPs.join(';'));
      return result;
    }
    return false;
  }

  ///[MÃ SẢN PHẨM CẤP 1 LÀ G VÀ NGÀNH L6810  (TRỪ CÁC MÃ 4513-4520-45413-4542-461)] => HỎI CÂU 5.5
  ///maVCPAs: 42343;24234;...
  ///maSanPham: 42343x,42343xx;24234xxx;...
  ///Return: true => Hiển thị phần/câu hỏi; false: không hiển thị phần/câu hỏi
  hasA5_5G_L6810(String maSanPham) async {
    if (maSanPham == '') {
      return true;
    }

    var arrG_C5 = maVcpaLoaiTruG_C5.split(';');
    var arrG_C4 = maVcpaLoaiTruG_C4.split(';');
    var arrG_C3 = maVcpaLoaiTruG_C3.split(';');
    //var result = false;
    // var result = await dmNhomNganhVcpaProvider.hasA5_5G_L6810(
    //     maSanPham, arrG_C3, arrG_C4, arrG_C5, maVcpaL6810);
    var result = await dmMotaSanphamProvider.hasA5_5G_L6810(
        maSanPham, arrG_C3, arrG_C4, arrG_C5, maVcpaL6810);

    return result;
  }

  hasAll_5G_L6810() async {
    var arrG_C5 = maVcpaLoaiTruG_C5.split(';');
    var arrG_C4 = maVcpaLoaiTruG_C4.split(';');
    var arrG_C3 = maVcpaLoaiTruG_C3.split(';');
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      var result = await dmMotaSanphamProvider.hasAll_5G_L6810(
          resMaSPs.join(';'), arrG_C3, arrG_C4, arrG_C5, maVcpaL6810);
      return result;
    }
    return false;
  }

  // hasCap1(String maSanPhams, String capas) async {
  //   return await dmNhomNganhVcpaProvider.kiemTraMaNganhCap1ByMaSanPham5(
  //       maSanPhams, capas);
  // }

  ///[MÃ SẢN PHẨM CẤP 2 LÀ 56] => HỎI CÂU 5.6 và 5.6.1
  ///VII. NĂNG LỰC PHỤC VỤ CỦA CƠ SỞ KINH DOANH DỊCH VỤ LƯU TRÚ  => (HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 2 LÀ 55)
  ///maSanPham ở câu A5_1_2
  ///cap2: mã sản phẩm cấp 2: 56
  hasCap2_56PhanV(String maSanPhams, String maSPDieuKien) async {
    if (maSanPhams == '') {
      return true;
    }
    // return await dmNhomNganhVcpaProvider.kiemTraMaNganhCap2ByMaSanPham5(
    //     maSanPhams, maSPDieuKien);
    return await dmMotaSanphamProvider.kiemTraMaNganhCap2ByMaSanPham5(
        maSanPhams, maSPDieuKien);
  }

  ///VI. NĂNG LỰC PHỤC VỤ CỦA CƠ SỞ KINH DOANH DỊCH VỤ VẬN TẢI NĂM 2024
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 1 LÀ NGÀNH H)
  hasCap1PhanVI() async {
    // var resMaSPs =
    //     await phieuMauSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    // if (resMaSPs.isNotEmpty) {

    //   return await dmMotaSanphamProvider.kiemTraMaNganhCap1ByMaSanPham5(
    //       resMaSPs.join(';'), 'H');
    // }
    return false;
  }

  ///HOẠT ĐỘNG VẬN TẢI HÀNH KHÁCH
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 5 LÀ 49210-49220-49290-49312-49313-49319-49321-49329-50111-50112-50211-50212)
  ///HOẠT ĐỘNG VẬN TẢI HÀNG HÓA
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 5 LÀ 49331-49332-49333-49334-49339-50121-50122-50221-50222)
  hasCap5PhanVI(String maSanPhams) async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      // return await dmNhomNganhVcpaProvider.kiemTraMaNganhCap5ByMaSanPham5(
      //     maSanPhams, resMaSPs.join(';'));
      return await dmMotaSanphamProvider.kiemTraMaNganhCap5ByMaSanPham5(
          maSanPhams, resMaSPs.join(';'));
    }
    return false;
  }

  countCap5PhanVI(String maSanPhams) async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      // return await dmNhomNganhVcpaProvider.countMaNganhCap5ByMaSanPham5(
      //     maSanPhams, resMaSPs.join(';'));
      return await dmMotaSanphamProvider.countMaNganhCap5ByMaSanPham5(
          maSanPhams, resMaSPs.join(';'));
    }
    return false;
  }

  hasCap2PhanVII(String maSPCap2DieuKien) async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      // return await dmNhomNganhVcpaProvider.kiemTraMaNganhCap2ByMaSanPham5(
      //     resMaSPs.join(';'), maSPCap2DieuKien);
      return await dmMotaSanphamProvider.kiemTraMaNganhCap2ByMaSanPham5(
          resMaSPs.join(';'), maSPCap2DieuKien);
    }
    return false;
  }

  ///END:: PHẦN V
  /***********/
  ///BEGIN:: PHẦN VI
  ///maSanPham: 42343;24234;...
  ///Return: true => Hiển thị phần/câu hỏi; false: không hiển thị phần/câu hỏi
  kiemTraCauHoiThuocMaVCPA(String maSanPham) async {
    //1. Lấy các mã sản phẩm ở bảng phieuMauSanPham
    //2. So sánh với maVCPAs của phần/câu hỏi
    if (maSanPham == '') {
      return true;
    }
    List<String> arrMa = maSanPham.split(';');
    var res = await phieuMauTBSanPhamProvider.kiemTraMaNganhVCPA(arrMa);
    return res;
  }

  // excuteDeleteSanPhamVaDichVu(id) async {
  //   int countHK = await countCap5PhanVI(cap5VanTaiHanhKhach);
  //   int countHH = await countCap5PhanVI(cap5VanTaiHangHoa);
  //   if (countHK < 2) {
  //     ///Cảnh báo và xoá dữ liệu phần VI hành khách
  //     var hasP6HK = await hasMucVIHanhKhach();
  //     if (hasP6HK) {
  //       String warningMsg =
  //           'Thông tin về nhóm sản phẩm và dữ liệu mục VI hoạt động vận tải hành khách và hàng hoá sẽ bị xoá. Bạn có đồng ý?.';
  //       await showDialogValidNganhHPhanVIPhanVII('phanvihk', warningMsg, id);
  //     }
  //   }
  //   if (countHH < 2) {
  //     String warningMsg =
  //         'Thông tin về nhóm sản phẩm và dữ liệu mục VI hoạt động vận tải hàng hoá sẽ bị xoá. Bạn có đồng ý?.';
  //     await showDialogValidNganhHPhanVIPhanVII('phanvihh', warningMsg, id);
  //   }
  //   var validSpVII = await validateNganhHPhanVII();
  //   if (validSpVII == "phanvii") {
  //     String warningMsg =
  //         'Thông tin về nhóm sản phẩm và dữ liệu mục VII về kinh doanh dịch vụ lưu trú sẽ bị xoá. Bạn có đồng ý?.';
  //     await showDialogValidNganhHPhanVIPhanVII(validSpVII!, warningMsg, id);
  //   }
  //   if()
  //   String warningMsg = 'Thông tin về nhóm sản phẩm sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganhHPhanVIPhanVII(validSpVII!, warningMsg, id);
  // }

  ///Thêm mới record cho bảng CT_Phieu_NganhCN
  Future insertNewRecordNganhCN(String maVCPACap5) async {
    var maxStt = await phieuNganhCNProvider.getMaxSTTByIdCoso(currentIdCoSo!);
    maxStt = maxStt + 1;
    var tblSp = TablePhieuNganhCN(
        iDCoSo: currentIdCoSo,
        sTT_SanPham: maxStt,
        maNganhC5: maVCPACap5,
        maDTV: AppPref.uid);
    List<TablePhieuNganhCN> tblSps = [];
    tblSps.add(tblSp);

    phieuNganhCNProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
  }

  ///Thêm mới record cho bảng CT_Phieu_NganhCN
  Future insertNewRecordNganhTMSanpham(String maVCPACap5) async {
    var maxStt =
        await phieuNganhTMSanphamProvider.getMaxSTTByIdCoso(currentIdCoSo!);
    maxStt = maxStt + 1;
    var tblSp = TablePhieuNganhTMSanPham(
        iDCoSo: currentIdCoSo,
        sTT_SanPham: maxStt,
        maNganhC5: maVCPACap5,
        maDTV: AppPref.uid);
    List<TablePhieuNganhTMSanPham> tblSps = [];
    tblSps.add(tblSp);

    phieuNganhTMSanphamProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
  }

  ///END:: PHẦN VI
  /***********/
  ///
/***********/
  ///BEGIN::PHẦN VII
  onSelectDmA7_1(
    QuestionCommonModel question,
    String table,
    String? maCauHoi,
    String? fieldName,
    value,
    dmItem, {
    ChiTieuDongModel? chiTieuDong,
    ChiTieuModel? chiTieuCot,
  }) {
    log('ON CHANGE onSelectDmA7_1: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblPhieuMau(fieldName, value, table);

      if (maCauHoi == "A7_1") {
        if (value != 1) {
          Get.dialog(DialogBarrierWidget(
            onPressedNegative: () async {
              await backYesValueForYesNoQuestionA7_1(
                  table, maCauHoi, fieldName, 1, question);
            },
            onPressedPositive: () async {
              updateAnswerToDB(table, fieldName!, value);
              await executeOnChangeYesNoQuestionA7_1(
                  table, value, chiTieuDong!, chiTieuCot!);
              Get.back();
            },
            title: 'dialog_title_warning'.tr,
            content: 'dialog_content_warning_select_no_chitieu'.tr,
          ));
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  backYesValueForYesNoQuestionA7_1(
      String table, String? maCauHoi, String? fieldName, value, dmItem) async {
    updateAnswerToDB(table, fieldName!, 1);
    updateAnswerTblPhieuMau(fieldName, value, table);
    Get.back();
  }

  executeOnChangeYesNoQuestionA7_1(table, value, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) async {
    log('ON executeOnChangeYesNoQuestionA4_2:  $value');

    try {
      if (value != 1) {
        for (int i = 1; i <= 5; i++) {
          var fieldNameDel = '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_$i';
          updateAnswerToDB(table, fieldNameDel, null);
          updateAnswerTblPhieuMau(fieldNameDel, null, table);
        }
        updateAnswerToDB(table, 'A7_1_5_GhiRo', null);
        updateAnswerTblPhieuMau('A7_1_5_GhiRo', null, table);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  ///END::PHẦN VII
/***********/
  ///BEGIN:: WARNING
  warningA1_1TenCoSo() async {
    warningA1_1.value = '';
    // var a1_1Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA1_1);
    // if (a1_1Val != null && a1_1Val.toString().length < 15) {
    //   warningA1_1.value = 'Tên quá ngắn';
    //   return warningA1_1.value;
    // }
    warningA1_1.value = '';
  }

  warningA4_2DoanhThu() async {
    warningA4_2.value = '';
    // var a4_2Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA4_2);
    // if (a4_2Val != null && (a4_2Val > 99 || a4_2Val > 99.0)) {
    //   warningA4_2.value =
    //       'Cảnh báo: Doanh thu đang có giá trị > 99. Vui lòng kiểm tra lại.';
    //   return warningA4_2.value;
    // }
    warningA4_2.value = '';
  }

  warningA4_6TienThueDiaDiem() async {
    // warningA4_6.value = '';
    // var a4_6Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA4_6);
    // if (a4_6Val != null && (a4_6Val > 99 || a4_6Val > 99.0)) {
    //   warningA4_6.value =
    //       'Cảnh báo: Tiền thuê địa điểm đang có giá trị > 99. Vui lòng kiểm tra lại.';
    //   return warningA4_6.value;
    // }
    warningA4_6.value = '';
  }

  warningA6_4SoKhachBQ() async {
    warningA6_4.value = '';

    // var a6_4Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA6_4) ?? 0;
    // var a6_2_1Value =
    //     getValueByFieldName(tablePhieuMau, columnPhieuMauA6_2_1) ?? 0;
    // var a6_2_2Value =
    //     getValueByFieldName(tablePhieuMau, columnPhieuMauA6_2_2) ?? 0;

    // var res = 0.0;
    // if (a6_2_1Value > 0) {
    //   res = a6_2_2Value / a6_2_1Value;
    // }
    // if (a6_4Val > res) {
    //   warningA6_4.value =
    //       'Cảnh báo: Số khách đang lớn hơn A6.2.2/A6.2.1. Vui lòng kiểm tra lại.';
    //   return warningA6_4.value;
    // }
    warningA6_4.value = '';
  }

  warningA6_5SoKmBQ() async {
    warningA6_5.value = '';
    // var a6_5Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA6_5);
    // if (a6_5Val != null && (a6_5Val > 100 || a6_5Val > 100.0)) {
    //   warningA6_5.value =
    //       'Cảnh báo: Số km đang lớn hơn 100 km. Vui lòng kiểm tra lại.';
    //   return warningA6_5.value;
    // }
    warningA6_5.value = '';
  }

  warningA6_11KhoiLuongHHBQ() async {
    warningA6_11.value = '';

    // var a6_11Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA6_11) ?? 0;
    // var a6_9_1Value =
    //     getValueByFieldName(tablePhieuMau, columnPhieuMauA6_9_1) ?? 0;
    // var a6_9_2Value =
    //     getValueByFieldName(tablePhieuMau, columnPhieuMauA6_9_2) ?? 0;

    // var res = 0.0;
    // if (a6_9_1Value > 0) {
    //   res = a6_9_2Value / a6_9_1Value;
    // }
    // if (a6_11Val > res) {
    //   warningA6_11.value =
    //       'Cảnh báo: Khối lượng đang lớn hơn A6.9.2/A6.9.1. Vui lòng kiểm tra lại.';
    //   return warningA6_11.value;
    // }
    warningA6_11.value = '';
  }

  warningA6_12SoKmBQ() async {
    warningA6_12.value = '';
    // var a6_12Val = getValueByFieldName(tablePhieuMau, columnPhieuMauA6_12);
    // if (a6_12Val != null && (a6_12Val > 250 || a6_12Val > 250.0)) {
    //   warningA6_12.value =
    //       'Cảnh báo: Số km đang lớn hơn 250 km. Vui lòng kiểm tra lại.';
    //   return warningA6_12.value;
    // }
    warningA6_12.value = '';
  }

  warningA7_1_X3SoPhongTangMoi(String i) async {
    // String fieldNameA7_1_x_3 = 'A7_1_${i}_3';
    // String fieldNameA7_1_x_2 = 'A7_1_${i}_2';
    // setA7_1WarningValue(fieldNameA7_1_x_3, '');

    // var a7_1_x_2Val =
    //     getValueByFieldName(tablePhieuMau, fieldNameA7_1_x_2) ?? 0;
    // var a7_1_x_2Valxx = a7_1_x_2Val * 2;
    // if (i == '1') {
    //   a7_1_x_2Valxx = a7_1_x_2Val * 3;
    // }
    // var a7_1_x_3Val =
    //     getValueByFieldName(tablePhieuMau, fieldNameA7_1_x_3) ?? 0;
    // if (a7_1_x_3Val > a7_1_x_2Valxx) {
    //   setA7_1WarningValue(
    //       fieldNameA7_1_x_3,
    //       ''
    //       'Cảnh báo: Số phòng tăng mới ($a7_1_x_3Val) đang lớn hơn 7.1.2 (3*7.1.2 = $a7_1_x_2Valxx)	. Vui lòng kiểm tra lại.');

    //   return;
    // }
    // setA7_1WarningValue(fieldNameA7_1_x_3, '');
  }

  setA7_1WarningValue(String fieldName, String value) {
    if (fieldName == a7_1FieldWarning[0]) {
      warningA7_1_1_3.value = value;
    } else if (fieldName == a7_1FieldWarning[1]) {
      warningA7_1_2_3.value = value;
    } else if (fieldName == a7_1FieldWarning[2]) {
      warningA7_1_3_3.value = value;
    } else if (fieldName == a7_1FieldWarning[3]) {
      warningA7_1_4_3.value = value;
    } else if (fieldName == a7_1FieldWarning[4]) {
      warningA7_1_5_3.value = value;
    }
  }

  getA7_1WarningValue(String fieldName) {
    if (fieldName == a7_1FieldWarning[0]) {
      return warningA7_1_1_3.value;
    } else if (fieldName == a7_1FieldWarning[1]) {
      return warningA7_1_2_3.value;
    } else if (fieldName == a7_1FieldWarning[2]) {
      return warningA7_1_3_3.value;
    } else if (fieldName == a7_1FieldWarning[3]) {
      return warningA7_1_4_3.value;
    } else if (fieldName == a7_1FieldWarning[4]) {
      return warningA7_1_5_3.value;
    }
    return '';
  }

  // warningA7_1_X3SoPhongTangMoi(String i) async {
  //   String fieldNameA7_1_x_3 = 'A7_1_${i}_3';
  //   String fieldNameA7_1_x_2 = 'A7_1_${i}_2';
  //   await updateWarningMessage(fieldNameA7_1_x_3, '');
  //   var a7_1_x_2Val =
  //       getValueByFieldName(tablePhieuMau, fieldNameA7_1_x_2) ?? 0;
  //   var a7_1_x_2Valxx = a7_1_x_2Val * 2;
  //   if (i == '1') {
  //     a7_1_x_2Valxx = a7_1_x_2Val * 3;
  //   }
  //   var a7_1_x_3Val =
  //       getValueByFieldName(tablePhieuMau, fieldNameA7_1_x_3) ?? 0;
  //   if (a7_1_x_3Val > a7_1_x_2Valxx) {
  //     String warningA7_1_3_x =
  //         'Cảnh báo: Số phòng tăng mới ($a7_1_x_3Val) đang lớn hơn 7.1.2 (3*7.1.2 = $a7_1_x_2Valxx)	. Vui lòng kiểm tra lại.';
  //     await updateWarningMessage(fieldNameA7_1_x_3, warningA7_1_3_x);
  //     return getWarningMessageByFieldName(fieldNameA7_1_x_3);
  //   }
  //   await updateWarningMessage(fieldNameA7_1_x_3, '');
  // }

  // Future updateWarningMessage(fieldName, value) async {
  //   Map<String, dynamic> map = Map<String, dynamic>.from(warningMessage);
  //   map.update(fieldName, (val) => value, ifAbsent: () => value);
  //   warningMessage.value = map;
  //   warningMessage.refresh();
  // }

  // getWarningMessageByFieldName(String fieldName) {
  //   return warningMessage[fieldName];
  // }

  ///END::PHẦN VII
/***********/
/***********/

  ///
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
    //myFocusNode.dispose();
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
    log('onPaused currentScreenNo: ${currentScreenNo.value}');
    fetchData();
    var validateResult = validateAllFormV2();

    validateResult.then((value) {
      if (value != '') {
        insertUpdateXacNhanLogicWithoutEnable(
            currentScreenNo.value,
            currentIdCoSo!,
            int.parse(currentMaDoiTuongDT!),
            0,
            value,
            int.parse(currentMaTinhTrangDT!));
        // return showError(value);
      }
    });
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
  @override
  onClose() {
    // focusNode.dispose();
    super.onClose();
  }

  ///END::CÂU 32
  ///
}
