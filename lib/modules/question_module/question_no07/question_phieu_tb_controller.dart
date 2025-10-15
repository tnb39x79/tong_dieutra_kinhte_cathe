import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/formatter_utils.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/money_input_enums.dart';

import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/complete_interview.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/dialog_search_vcpa_tab.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/validation_no07.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/ct_dm_phieu_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau_dm.dart';

import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_phieu.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/danh_dau_sanpham_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/question_group.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/services/industry_code_evaluator.dart';

import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart';

class QuestionPhieuTBController extends BaseController with QuestionUtils {
  QuestionPhieuTBController({required this.vcpaVsicAIRepository});
  final HomeController homeController = Get.find();
  MainMenuController mainMenuController = Get.find();
  static const idCoSoKey = 'idCoSo';
  static const isNhomNganhCap1BCEKey = 'IsNhomNganhCap1BCE';

  String isNhomNganhCap1BCE = Get.parameters[isNhomNganhCap1BCEKey] ?? "";
  DateTime startTime = DateTime.now();
  //final FocusNode focusNode = FocusNode();

  /// param

  final scrollController = ScrollController();

  final generalInformationController = Get.find<GeneralInformationController>();

  ///search by AI
  final VcpaVsicAIRepository vcpaVsicAIRepository;

  String? currentIdHoDuPhong;
  String? currentIdCoSoDuPhong;
  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaDiaBan;
  String? currentIdCoSo;
  String? currentMaXa;
  String? currentMaTinhTrangDT;

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
  final dmPhieuProvider = DmPhieuProvider();

  ///table
  ///
  //final tblBkCoSoSXKD = TableBkCoSoSXKD().obs;
  final tblPhieu = TablePhieu().obs;
  final tblPhieuMauTB = TablePhieuMauTB().obs;
  final tblPhieuMauTBSanPham = <TablePhieuMauTBSanPham>[].obs;
  final tblPhieuNganhCN = <TablePhieuNganhCN>[].obs;
  final tblPhieuNganhCNDistinctCap5 = <TablePhieuNganhCNCap5>[].obs;
  final tblPhieuNganhLT = TablePhieuNganhLT().obs;

  final tblPhieuNganhTM = TablePhieuNganhTM().obs;
  final tblPhieuNganhTMSanPham = <TablePhieuNganhTMSanPham>[].obs;
  final tblPhieuNganhTMSanPhamView = <TablePhieuNganhTMSanPhamView>[].obs;

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
  final tblDmPhieu = <TableCTDmPhieu>[].obs;

  final questions = <QuestionCommonModel>[].obs;
  final currentScreenNo = 0.obs;
  final currentScreenIndex = 0.obs;
  final questionIndex = 0.obs;
  final currentTenPhieu = ''.obs;

  final keywordDanToc = ''.obs;
  final searchResult = false.obs;
  final keywordVcpaCap5 = ''.obs;
  final searchResultCap5 = false.obs;

  ///Chọn search từ danh mục hay AI
  final aISearchStatus = ''.obs;
  final limitNumSearchAIValue = 100;

  final tblDmDanTocSearch = <TableDmDanToc>[].obs;

//* Chứa các giá trị
  RxMap<dynamic, dynamic> answerTblPhieuMau = {}.obs;
  RxMap<dynamic, dynamic> answerTblPhieuNganhVT = {}.obs;
  RxMap<dynamic, dynamic> answerTblPhieuNganhLT = {}.obs;

  ///Chứa STT_Sanpham đầu tiên.
  final sttProduct = 0.obs;
  //final sttProductNganhCN = 0.obs;
  RxMap<dynamic, dynamic> answerDanhDauSanPham = {}.obs;
  final isBCDE = false.obs;
  final isCap2_56TM = false.obs;
  final isCap1H_VT = false.obs;
  final isCap5VanTaiHanhKhach = false.obs;
  final isCap5VanTaiHangHoa = false.obs;
  final isCap2_55LT = false.obs;
  final isCap2G_6810TM = false.obs;
  final tblPhieuMauTBSanPhamVTHanhKhach = <TablePhieuMauTBSanPham>[].obs;
  final tblPhieuMauTBSanPhamVTHangHoa = <TablePhieuMauTBSanPham>[].obs;
  final tblPhieuMauTBSanPhamLT = <TablePhieuMauTBSanPham>[].obs;
  final tblPhieuMauTBSanPhamTMGL6810 = <TablePhieuMauTBSanPham>[].obs;
  final tblPhieuMauTBSanPhamTM56 = <TablePhieuMauTBSanPham>[].obs;

//* Chứa danh sách nhóm câu hỏi
  final questionGroupList = <QuestionGroupByMaPhieu>[].obs;
//* Chứa thông tin hoàn thành phiếu
  final completeInfo = {}.obs;
  String subTitleBar = '';
  String silderTitleBar = '';

  ///56
  String vcpaCap2TM = "56";

  ///"49210;49220;49290;49312;49313;49319;49321;49329;50111;50112;50211;50212"
  String vcpaCap5VanTaiHanhKhach =
      "49210;49220;49290;49312;49313;49319;49321;49329;50111;50112;50211;50212";

  ///"49331;49332;49333;49334;49339;50121;50122;50221;50222";
  String vcpaCap5VanTaiHangHoa =
      "49331;49332;49333;49334;49339;50121;50122;50221;50222";

  ///55
  String vcpaCap2LT = "55";

  ///"45413";
  String maVcpaLoaiTruG_C5 = "45413";

  ///"4513;4520;4542";
  String maVcpaLoaiTruG_C4 = "4513;4520;4542";

  ///"461";
  String maVcpaLoaiTruG_C3 = "461";

  String maVcpaL6810 = "6810";

  // final warningA7_1_1_3 = ''.obs;
  // final warningA7_1_2_3 = ''.obs;
  // final warningA7_1_3_3 = ''.obs;
  // final warningA7_1_4_3 = ''.obs;
  // final warningA7_1_5_3 = ''.obs;

  ///LinhVuc item đang chọn

  final linhVucSelected =
      TableDmLinhvuc(id: 0, maLV: '0', tenLinhVuc: "Chọn lĩnh vực").obs;

  final sanPhamIdSelected = 0.obs;
  final moTaSpSelected = ''.obs;
  final maLVSelected = ''.obs;

  ///Tìm kiếm vcpa offline AI
  final evaluator = IndustryCodeEvaluator(isDebug: true);
  final isInitializedEvaluator = false.obs;

  final a1_3_5TBMaTDCM = [6, 7, 8, 9, 10];
  final a1_1_DiaDiem = [1, 2, 3, 4, 5];

  ///Mã ngành >=10101001 và <=39000203
  final List<String> dsMaSanPhamNganhCN = [];

  ///Mã ngành >=141001111 và Mã ngành<=14300200
  final List<String> dsMaSanPhamNganhCN2 = [];

//A5.2
  final tongDoanhThuTatCaSanPham = 0.0.obs;
  //C5.2_Dthu tại Phiếu 7TB của các sản phẩm TM cho phiếu TM
  final tongDoanhThuSanPhamNganhTM = 0.0.obs;
  final tongTienVonBoRaC1TM = 0.0.obs;
  final doanhThuNganhVTHK = 0.0.obs;
  final doanhThuNganhVTHH = 0.0.obs;
  final doanhThuNganhLT = 0.0.obs;
  //Danh sách chỉ tiêu năng lượng cho câu A6_1_M phiếu Mẫu 7.5M
  final dsChiTieuDongA6_1TB = <ChiTieuDongModel>[].obs;

  //C1_Khối lượng tiêu dùng tất cả năng lượng mã 1+11 (ngoại trừ các mã trong đó)
  final tongKhoiLuongTieuDungNangLuong = 0.0.obs;
  //Mã ngành cấp 2 là ngành công nghiệp (mã ngành >=10 và <=39)
  final hasMaNganhCN10T039 = <String>[].obs;

  //Chứa mã ngành VTHK lấy từ bảng tablePhieuMauTBSanPham
  //Gồm Mã ngành Vận tải hành khách (49210-49220-49290-49312-49313-49319-49321-49329-50111-50112-50211-50212)
  final hasMaNganhVTHK = <String>[].obs;

  //Chứa mã ngành VTHH lấy từ bảng tablePhieuMauTBSanPham
  //Gồm Mã ngành vận tải hàng hóa thuộc mã 49331-49332-49333-49334-49339-50121-50122-50221-50222
  final hasMaNganhVTHH = <String>[].obs;

  @override
  void onInit() async {
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
        '${generalInformationController.tblBkCoSoSXKD.value.tenCoSo} Địa bàn.$currentMaDiaBan - ${generalInformationController.tblBkCoSoSXKD.value.tenDiaBan}'; // ${AppUtils.getXaPhuong(generalInformationController.tblBkCoSoSXKD.value.tenXa??'')}.$currentMaXa - ${generalInformationController.tblBkCoSoSXKD.value.tenXa}';
    silderTitleBar =
        '${generalInformationController.tblBkCoSoSXKD.value.tenCoSo}\nĐịa bàn.$currentMaDiaBan - ${generalInformationController.tblBkCoSoSXKD.value.tenDiaBan}'; //\n${AppUtils.getXaPhuong(generalInformationController.tblBkCoSoSXKD.value.tenXa ?? '')}.$currentMaXa - ${generalInformationController.tblBkCoSoSXKD.value.tenXa}';
    log('Màn hình ${currentScreenNo.value}');
    await updateNganhAll();
    await getDanhMuc();
    await fetchData();
    await getQuestionContent();
    await danhDauSanPhamCN();
    await danhDauSanPhamVT();
    await danhDauSanPhamLT();
    await danhDauSanPhamTM();
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
    await getDsMaSanPhamNganhCN();
    setLoading(false);
    super.onInit();
  }

  Future getDmPhieu() async {
    var res = await dmPhieuProvider.selectAll();
    var mtAll = TableCTDmPhieu.listFromJson(res);
    tblDmPhieu.assignAll(mtAll);
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

  Future getDsMaSanPhamNganhCN() async {
    var spNganhCNs =
        await dmMotaSanphamProvider.getMaSanPhamBetween('10101001', '39000203');
    if (dsMaSanPhamNganhCN.isNotEmpty) {
      dsMaSanPhamNganhCN.clear();
    }
    dsMaSanPhamNganhCN.addAll(spNganhCNs);

    //dsMaSanPhamNganhCN2
    var spNganhCNs2 = await dmMotaSanphamProvider.getMaSanPhamBetween(
        '141001111', '14300200');
    if (dsMaSanPhamNganhCN2.isNotEmpty) {
      dsMaSanPhamNganhCN2.clear();
    }
    dsMaSanPhamNganhCN2.addAll(spNganhCNs2);
  }

  /// Fetch Data các bảng của phiếu
  Future fetchData() async {
    Map questionPhieuMap = await phieuProvider.selectByIdCoSo(currentIdCoSo!);
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
    var rs = TablePhieuMauTBSanPham.fromListJson(questionSpMap) ?? [];
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
    var rs = TablePhieuNganhCN.fromListJson(questionCNMap) ?? [];
    tblPhieuNganhCN.assignAll(rs);
    tblPhieuNganhCN.refresh();

    List<Map> questionCNDistinctCap5Map =
        await phieuNganhCNProvider.selectDistinctCap5ByIdCoso(currentIdCoSo!);
    var rsCap5 =
        TablePhieuNganhCNCap5.fromListJson(questionCNDistinctCap5Map) ?? [];
    if (rsCap5.isNotEmpty) {
      for (var item in rsCap5) {
        item.isDefault = 1;
      }
    }
    tblPhieuNganhCNDistinctCap5.assignAll(rsCap5);
    tblPhieuNganhCNDistinctCap5.refresh();

    // var rsFirst = rs.firstOrNull;
    // if (rsFirst != null) {
    //   if (rsFirst.isDefault == 1) {
    //     sttProductNganhCN.value = rsFirst.sTT_SanPham!;
    //   } else {
    //     var ress = rs.where((x) => x.isDefault == 1).firstOrNull;
    //     if (ress != null) {
    //       sttProductNganhCN.value = ress.sTT_SanPham!;
    //     }
    //   }
    // }
  }

  Future getTablePhieuNganhVT() async {
    Map questionVTMap =
        await phieuNganhVTProvider.selectByIdCoSo(currentIdCoSo!);

    tblPhieuNganhVT.value = TablePhieuNganhVT.fromJson(questionVTMap)!;
    tblPhieuNganhVT.refresh();
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
        await phieuNganhTMSanphamProvider.selectA1TMByIdCoSo(currentIdCoSo!);

    tblPhieuNganhTMSanPham.assignAll(
        TablePhieuNganhTMSanPham.fromListJson(questionTMSanPhamMap)!);
    tblPhieuNganhTMSanPham.refresh();

    List<Map> questionTMSanPhamMapView =
        await phieuNganhTMSanphamProvider.selectA1TMByIdCoSo(currentIdCoSo!);

    tblPhieuNganhTMSanPhamView.assignAll(
        TablePhieuNganhTMSanPhamView.fromListJson(questionTMSanPhamMap)!);
    tblPhieuNganhTMSanPhamView.refresh();
  }

  ///Danh dau san pham
  danhDauSanPham() async {
    if (tblPhieuMauTBSanPham.isNotEmpty) {
      for (var item in tblPhieuMauTBSanPham) {
        bool isCap1BCDE = false;
        bool isCap1GL = false;
        bool isCap2_56TM = false;
        // bool isCap1H = false;
        // bool isCap5VanTaiHanhKhach = false;
        // bool isCap5VanTaiHangHoa = false;
        // bool isCap2_55 = false;
        if (item.a5_1_2 != null && item.a5_1_2 != '') {
          isCap1BCDE = await hasA5_3BCDE(item.a5_1_2!);
          isCap1GL = await hasA5_5G_L6810(item.a5_1_2!);
          isCap2_56TM = await hasCap2_56TM(vcpaCap2TM, item.a5_1_2!);
        }
        Map<String, dynamic> ddSP = {
          ddSpId: item.id,
          ddSpMaSanPham: item.a5_1_2,
          ddSpSttSanPham: item.sTTSanPham,
          ddSpIsCap1BCDE: isCap1BCDE,
          ddSpIsCap1GL: isCap1GL,
          ddSpIsCap2_56: isCap2_56TM
        };
        updateAnswerDanhDauSanPham(item.sTTSanPham, ddSP);
      }
    }
    await danhDauSanPhamCN();
    await danhDauSanPhamVT();
    await danhDauSanPhamLT();
    await danhDauSanPhamTM();
    await getMaSanPhamNganhVT(vcpaCap5VanTaiHanhKhach);
    await getMaSanPhamNganhVT(vcpaCap5VanTaiHangHoa);
    await getMaSanPhamNganhLT();
    await getMaSanPhamNganhTMGL6810();
    await getMaSanPhamNganhTM56();
  }

  danhDauSanPhamCN() async {
    if (tblPhieuMauTBSanPham.isNotEmpty) {
      isBCDE.value = await hasAllSanPhamBCDE();
    }
  }

  danhDauSanPhamVT() async {
    if (tblPhieuMauTBSanPham.isNotEmpty) {
      isCap1H_VT.value = await hasCap1NganhVT();
      isCap5VanTaiHanhKhach.value =
          await hasCap5NganhVT(vcpaCap5VanTaiHanhKhach);
      isCap5VanTaiHangHoa.value = await hasCap5NganhVT(vcpaCap5VanTaiHangHoa);
    }
  }

  danhDauSanPhamLT() async {
    if (tblPhieuMauTBSanPham.isNotEmpty) {
      isCap2_55LT.value = await hasCap2NganhLT('55');
    }
  }

  danhDauSanPhamTM() async {
    if (tblPhieuMauTBSanPham.isNotEmpty) {
      isCap2_56TM.value = await hasAllCap2_56TM();
      isCap2G_6810TM.value = await hasAll_5G_L6810();
    }
  }

  Future<List<QuestionCommonModel>> getQuestionContent() async {
    try {
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      dynamic question07 = tableData.toCauHoiPhieu07(currentMaDoiTuongDT!);

      List<QuestionCommonModel> questionsTemp =
          QuestionCommonModel.listFromJson(jsonDecode(question07));
      List<QuestionCommonModel> questionsTemp2 = [];
      if (questionsTemp.isNotEmpty) {
        questionsTemp2.addAll(questionsTemp);
        questions.clear();

        questionsTemp2.retainWhere((x) {
          return (x.manHinh == currentScreenNo.value);
        });
      }
      if (currentScreenNo.value == 5) {
        var hasBCDE = await hasAllSanPhamBCDE();
        if (hasBCDE) {
          questions.addAll(questionsTemp2);
          await getTenPhieu();
          return questions;
        } else {
          questions.clear();
          await getTenPhieu();
          return questions;
        }
      }
      //kiểm tra VCPA cấp 1 không phải là H thì remove câu hỏi phần 6
      // if (currentScreenNo.value == 6 || currentScreenNo.value == 7) {
      //   await danhDauSanPhamVT();
      //   await danhDauSanPhamVT();
      //   var questionByVcpa = await getQuestionContentFilterByVcpa(
      //       questionsTemp2,
      //       currentScreenNo.value,
      //       isCap1H_VT.value,
      //       isCap5VanTaiHanhKhach.value,
      //       isCap5VanTaiHangHoa.value,
      //       isCap2_55LT.value);
      //   questions.addAll(questionByVcpa);
      // } else {
      //   questions.addAll(questionsTemp2);
      // }
      questions.addAll(questionsTemp2);
      await getTenPhieu();
      return questions;
    } catch (e) {
      log('ERROR lấy danh sách câu hỏi phiếu: $e');
      return [];
    }
  }

  Future getTenPhieu() async {
    if (questions.isNotEmpty) {
      var q = questions.map((p) => p.maPhieu!).firstOrNull;
      if (q != null) {
        if (tblDmPhieu.isNotEmpty) {
          var p = tblDmPhieu.value.where((x) => x.maPhieu == q).firstOrNull;
          currentTenPhieu.value = p != null ? p.tenPhieu! : '';
        }
      }
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
      getDmPhieu()
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
    try {
      dynamic map = await dmQuocTichProvider.selectAll();
      tblDmQuocTich.value = TableCTDmQuocTich.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmQuocTich: $e');
    }
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

  Future assignAllQuestionGroup() async {
    // var s= await getQuestionGroupsV2(currentMaDoiTuongDT!, currentIdCoSo!,tblDmPhieu);
    // var qGroups = await getQuestionGroups(currentMaDoiTuongDT!, currentIdCoSo!);
    var qGroups = await getQuestionGroupsV2(
        currentMaDoiTuongDT!, currentIdCoSo!, tblDmPhieu);
    for (var item in qGroups) {
      //   if (item.fromQuestion == "6.1") {
      //     item.enable = (isCap1H_VT.value == true &&
      //             isCap5VanTaiHangHoa.value == true) ||
      //         (isCap1H_VT.value == true && isCap5VanTaiHanhKhach.value == true);
      //   } else if (item.fromQuestion == "7.1") {
      //     // if (isCap2_55LT.value == true) {
      //     item.enable = isCap2_55LT.value;
      //     // }
      //   }
    }
    questionGroupList.assignAll(qGroups);
  }

  Future onOpenDrawerQuestionGroup() async {
    scaffoldKey.currentState?.openDrawer();
  }

  Future onMenuPress(int idPhieus, int idManHinh) async {
    if (idManHinh == 4) {
      await getLoaiNangLuongA6_1();
    }
    if (idManHinh == 13) {
      await tongDoanhThuTatcaSanPhamA5_2();
      await getMaNganhCN10To39();
    }
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
    QuestionGroupByManHinh? qItem;
    var questionGroups = questionGroupList.where((x) => x.id == idPhieus).first;
    if (questionGroups.questionGroupByManHinh != null) {
      qItem = questionGroups.questionGroupByManHinh!
          .where((x) => x.id == idManHinh)
          .first;
    }

    if (qItem != null) {
      if (qItem.enable!) {
        qItem.isSelected = true;
        currentScreenNo.value = qItem.manHinh!;
        if (currentScreenNo.value > 0) {
          currentScreenIndex.value = currentScreenNo.value - 1;
        }
        await danhDauSanPhamCN();
        await danhDauSanPhamVT();
        await danhDauSanPhamLT();
        await danhDauSanPhamTM();
        await getQuestionContent();
        if (currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {}
      } else {
        snackBar('Thông báo', 'Danh sách cấu hỏi này chưa nhập');
      }
    }
    questionGroupList.refresh();
    scaffoldKey.currentState?.closeDrawer();
  }

  Future clearSelectedQuestionGroup() async {
    for (var item in questionGroupList) {
      if (item.questionGroupByManHinh != null) {
        for (var subItem in item.questionGroupByManHinh!) {
          subItem.isSelected = false;
        }
      }
    }
    questionGroupList.refresh();
  }

  Future setSelectedQuestionGroup() async {
    if (currentScreenNo.value > 0) {
      await clearSelectedQuestionGroup();
      for (var item in questionGroupList) {
        if (item.questionGroupByManHinh != null) {
          var questionGroupItem = item.questionGroupByManHinh!
              .where((x) => x.manHinh == currentScreenNo.value)
              .firstOrNull;
          if (questionGroupItem != null) {
            if (questionGroupItem.enable!) {
              questionGroupItem.isSelected = true;
              questionGroupList.refresh();
            }
          }
        }
      }
    }
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
      currentScreenNo(currentScreenNo.value - 1);
      currentScreenIndex(currentScreenIndex.value - 1);
      if (currentScreenNo.value == 0) {
        Get.back();
      }
      //   await getQuestionContent();
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
        if (currentScreenNo.value == 9) {
          currentScreenNo(currentScreenNo.value - 1);
          currentScreenIndex(currentScreenIndex.value - 1);
          //    await getQuestionContent();
        }
        if (currentScreenNo.value == 8) {
          if (isCap2_55LT.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 7) {
          if (isCap5VanTaiHangHoa.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 6) {
          if (isCap5VanTaiHanhKhach.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 5) {
          if (isBCDE.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
      } else if (currentMaDoiTuongDT ==
          AppDefine.maDoiTuongDT_07Mau.toString()) {
        if (currentScreenNo.value == 13) {
          currentScreenNo(currentScreenNo.value - 1);
          currentScreenIndex(currentScreenIndex.value - 1);
        }
        if (currentScreenNo.value == 12) {
          if (isCap2_56TM.value == false && isCap2G_6810TM.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 11) {
          if (isCap2_55LT.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 10) {
          if (isCap2_55LT.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 9) {
          if (isCap5VanTaiHangHoa.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 8) {
          if (isCap5VanTaiHangHoa.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 7) {
          if (isCap5VanTaiHanhKhach.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 6) {
          if (isCap5VanTaiHanhKhach.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
        if (currentScreenNo.value == 5) {
          if (isBCDE.value == false) {
            currentScreenNo(currentScreenNo.value - 1);
            currentScreenIndex(currentScreenIndex.value - 1);
          }
        }
      }
      await danhDauSanPhamCN();
      await danhDauSanPhamVT();
      await danhDauSanPhamLT();
      await danhDauSanPhamTM();
      await getQuestionContent();

      await scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      await setSelectedQuestionGroup();
    } else {
      currentScreenIndex.value = 0;
      Get.back();
    }
  }

  void onNext() async {
    if (currentScreenNo.value == 4) {
      await getLoaiNangLuongA6_1();
    }
    if (currentScreenNo.value == 3) {
      await updateNganhAll();
    }
    await fetchData();

    String validateResult = await validateAllFormV2();

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
    //Màn hình Phần V: NHÓM SẢN PHẨM VÀ KẾT QUẢ HOẠT ĐỘNG KDSX
    if (currentScreenNo.value == 3 ||
        currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {
      //Kiểm tra NganhCN
      //  var hasBDCE = await updateDataNganhCN();
      //Kiểm tra bảng NganhVT
      await danhDauSanPhamCN();
      await danhDauSanPhamVT();
      await danhDauSanPhamLT();
      await danhDauSanPhamTM();
      // var (hasC1VT, hasC5VTHK, hasC5VTHH) = await updateDataNganhVT();

      //Kiểm tra bảng NganhTM
      // var (hasC1TM, hasC5TM) = await updateDataNganhTM();

      var validResCN = await kiemTraNganhCN();
      var validResVT = await kiemTraNganhVT();
      var validResLT = await kiemTraNganhLT();
      var validResTM = await kiemTraNganhTM();

      if (validResCN == "nganhCN") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có hoạt động công nghiệp. Dữ liệu mục hoạt động công nghiệp sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResCN!, warningMsg);
      } else if (validResVT == "nganhVThh") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có hoạt động vận tải hàng hoá. Dữ liệu mục hoạt động vận tải hàng hoá sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResVT!, warningMsg);
      } else if (validResVT == "nganhVThk") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có hoạt động vận tải hành khách. Dữ liệu mục hoạt động vận tải hành khách sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResVT!, warningMsg);
      } else if (validResVT == "nganhVT") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có hoạt động vận tải. Dữ liệu mục hoạt động vận tải sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResVT!, warningMsg);
      } else if (validResLT == "nganhLT") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có hoạt động kinh doanh dịch vụ lưu trú. Dữ liệu mục hoạt động kinh doanh dịch vụ lưu trú sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResLT!, warningMsg);
      } else if (validResTM == "nganhTM56") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có thông tin về kết quả hoạt động ăn uống. Dữ liệu mục thông tin về kết quả hoạt động ăn uống sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResTM!, warningMsg);
      } else if (validResTM == "nganhTMG6810") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có thông tin về hoạt động buôn bán; bán lẻ,.... Dữ liệu mục thông tin về hoạt động buôn bán; bán lẻ,... sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResTM!, warningMsg);
      } else if (validResTM == "nganhTM") {
        String warningMsg =
            'Thông tin về nhóm sản phẩm không có thông tin về kết quả hoạt động ăn uống và oạt động buôn bán; bán lẻ,.... Dữ liệu mục thông tin về kết quả hoạt động ăn uống và oạt động buôn bán; bán lẻ,... sẽ bị xoá. Bạn có đồng ý?.';
        await showDialogValidNganh(validResTM!, warningMsg);
      } else {
        onNextContinue();
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
      await danhDauSanPhamCN();
      await danhDauSanPhamVT();
      await danhDauSanPhamLT();
      await danhDauSanPhamTM();
      await getQuestionContent();
      // await manHinhPhieuTB();
      // await manHinhPhieuMau();
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
        if (currentScreenNo.value == 5) {
          if (isBCDE.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //   await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 6) {
          if (isCap5VanTaiHanhKhach.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //  await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 7) {
          if (isCap5VanTaiHangHoa.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //  await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 8) {
          if (isCap2_55LT.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //  await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 9) {
          if (isCap2_56TM.value == false && isCap2G_6810TM.value == false) {
            //  await getQuestionContent();
            //   await setSelectedQuestionGroup();

            // var result = await validateCompleted();
            // if (result != null && result != '') {
            //   result = result.replaceAll('^', '\r\n');
            //   return showError(result);
            // }
            // onKetThucPhongVan();
          }
        }
      } else if (currentMaDoiTuongDT ==
          AppDefine.maDoiTuongDT_07Mau.toString()) {
        if (currentScreenNo.value == 5) {
          if (isBCDE.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //   await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 6) {
          if (isCap5VanTaiHanhKhach.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //   await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 7) {
          if (isCap5VanTaiHanhKhach.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              // await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 8) {
          if (isCap5VanTaiHangHoa.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //   await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 9) {
          if (isCap5VanTaiHangHoa.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //  await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 10) {
          if (isCap2_55LT.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //  await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 11) {
          if (isCap2_55LT.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //     await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 12) {
          if (isCap2_56TM.value == false && isCap2G_6810TM.value == false) {
            if (currentScreenIndex.value <
                generalInformationController.screenNos().length - 1) {
              currentScreenNo(currentScreenNo.value + 1);
              currentScreenIndex(currentScreenIndex.value + 1);
              //  await getQuestionContent();
            }
          }
        }
        if (currentScreenNo.value == 13) {
          await tongDoanhThuTatcaSanPhamA5_2();
          await getMaNganhCN10To39();
          // await getQuestionContent();
          // await setSelectedQuestionGroup();

          // scrollController.animateTo(0.0,
          //     duration: const Duration(milliseconds: 400),
          //     curve: Curves.fastOutSlowIn);
        }
      }
      await getQuestionContent();
      await setSelectedQuestionGroup();

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

  Future<String?> kiemTraNganhCN() async {
    await danhDauSanPham();
    var isCap1BCDE = await hasAllSanPhamBCDE();
    if (!isCap1BCDE) {
      var map = await phieuNganhCNProvider.selectByIdCoso(currentIdCoSo!);
      return map.isNotEmpty ? 'nganhCN' : '';
    }
    return "";
  }

  ///Nếu không có ngành H (isCap1H_VT.value==true) thì cảnh báo và xoá dữ liệu phần VI và VII
  ///Nếu có ngành H (isCap1H_VT.value==false ) nhưng  isCap5VanTaiHanhKhach.value == false
  ///Nếu có ngành H (isCap1H_VT.value==false )  isCap5VanTaiHangHoa.value == false
  ///thì sẽ xoá dữ liệu phần tương ứng
  Future<String?> kiemTraNganhVT() async {
    await danhDauSanPhamVT();

    if (isCap1H_VT.value == true) {
      if (isCap5VanTaiHanhKhach.value == false &&
          isCap5VanTaiHangHoa.value == true) {
        ///Cảnh báo và xoá dữ liệu phần VI hành khách
        //Kiểm tra dữ liệu phần VI có không?
        var hasP6HK = await hasMucVTHanhKhach();
        if (hasP6HK) {
          return "nganhVThk";
        }
      } else if (isCap5VanTaiHanhKhach.value == true &&
          isCap5VanTaiHangHoa.value == false) {
        ///Cảnh báo và xoá dữ liệu phần VI hàng hoá
        var hasP6HH = await hasMucVTHangHoa();
        if (hasP6HH) {
          return "nganhVThh";
        }
      } else if (isCap5VanTaiHangHoa.value == false &&
          isCap5VanTaiHanhKhach.value == false) {
        ///Cảnh báo và xoá dữ liệu phần VI hàng hoá, hành khách
        var hasP6HH = await hasMucVTHangHoa();
        var hasP6HK = await hasMucVTHanhKhach();
        if (hasP6HH || hasP6HK) {
          return "nganhVT";
        }
      }
    } else {
      ///Cảnh báo và xoá dữ liệu phần VI và VII
      var hasP6HH = await hasMucVTHangHoa();
      var hasP6HK = await hasMucVTHanhKhach();
      if (hasP6HH || hasP6HK) {
        return "nganhVT";
      }
    }
    return "";
  }

  Future<String?> kiemTraNganhLT() async {
    await danhDauSanPhamLT();
    if (!isCap2_55LT.value) {
      var map = await phieuNganhLTProvider.selectByIdCoSo(currentIdCoSo!);
      return map.isNotEmpty ? 'nganhLT' : '';
    }
    return "";
  }

  Future<String?> kiemTraNganhTM() async {
    await danhDauSanPhamTM();
    var res56 = await validateNganhTM56();
    var res6810 = await validateNganhTM6810();
    if (res56 != "" && res6810 != "") {
      return "nganhTM";
    } else if (res56 != "" && res6810 == "") {
      return "";
    } else if (res56 != "") {
      return res56;
    } else if (res6810 != "") {
      return res6810;
    }
    return "";
  }

  Future<String?> validateNganhTM56() async {
    await danhDauSanPhamTM();
    if (!isCap2_56TM.value) {
      var map = await phieuNganhTMProvider.selectByIdCoSo(currentIdCoSo!);
      return map.isNotEmpty ? 'nganhTM56' : '';
    }
    return "";
  }

  Future<String?> validateNganhTM6810() async {
    await danhDauSanPhamTM();
    if (!isCap2G_6810TM.value) {
      var map =
          await phieuNganhTMSanphamProvider.selectByIdCoSo(currentIdCoSo!);
      return map.isNotEmpty ? 'nganhTMG6810' : '';
    }
    return "";
  }

  Future showDialogValidNganh(String hoatDong, String warningMsg) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await excueteValidNganh(hoatDong);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: warningMsg,
    ));
  }

  Future excueteValidNganh(String hoatDong) async {
    if (hoatDong == "nganhCN") {
      ///Cảnh báo và xoá dữ liệu CN
      await excueteDeleteCNItem();

      ///Cập nhật lại bảng xacnhanlogic cho phần VI về null
      await insertUpdateXacNhanLogic(
          5,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhVT") {
      ///Cảnh báo và xoá dữ liệu VT
      await excueteDeleteVTItemHangHoa();
      await excueteDeleteVTItemHanhKhach();

      ///Cập nhật lại bảng xacnhanlogic cho phần VI về null
      await insertUpdateXacNhanLogic(
          6,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
      await insertUpdateXacNhanLogic(
          7,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhVThh") {
      await excueteDeleteVTItemHangHoa();
      await insertUpdateXacNhanLogic(
          7,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhVThk") {
      await excueteDeleteVTItemHanhKhach();
      await insertUpdateXacNhanLogic(
          6,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhLT") {
      await excueteDeleteLTItem();
      await insertUpdateXacNhanLogic(
          8,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhTM") {
      await excueteDeleteTM6810Item();
      await excueteDeleteTM56Item();
      await insertUpdateXacNhanLogic(
          9,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhTM6810") {
      await excueteDeleteTM6810Item();
      await insertUpdateXacNhanLogic(
          9,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          0,
          '',
          int.parse(currentMaTinhTrangDT!));
    } else if (hoatDong == "nganhTM56") {
      await excueteDeleteTM56Item();
      await insertUpdateXacNhanLogic(
          9,
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
    if (hoatDong != "nganhLT") {
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
    await danhDauSanPhamCN();
    await danhDauSanPhamVT();
    await danhDauSanPhamLT();
    await danhDauSanPhamTM();
  }

  Future<bool> hasMucVTHangHoa() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HHTB);
      //  var hasHH = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HHTB);
      // var hasHH = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI);
    } else {
      return false;
    }
  }

  Future<bool> hasMucVTHanhKhach() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      var hasHK = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HKTB);

      // var hasRecord = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasHK);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      var hasVI = await phieuNganhVTProvider.kiemTraPhanVIVIIValues(
          currentIdCoSo!, fieldNamesPhan6HKTB);
      // var hasHK = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      return (hasVI);
    } else {
      return false;
    }
  }

  Future excueteDeleteCNItem() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);
    }
  }

  Future excueteDeleteVTItemHangHoa() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HHTB);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HHMau);
    }
  }

  Future excueteDeleteVTItemHanhKhach() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HKTB);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhVTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan6HKMau);
    }
  }

  Future excueteDeleteLTItem() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhLTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan7LTTB);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhLTProvider.updateNullValues(
          currentIdCoSo!, fieldNamesPhan7LTMau);
    }
  }

  Future excueteDeleteTM6810Item() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhTMSanphamProvider.deleteByCoSoId(currentIdCoSo!);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhTMSanphamProvider.deleteByCoSoId(currentIdCoSo!);
    }
  }

  Future excueteDeleteTM56Item() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await phieuNganhTMProvider.deleteByCoSoId(currentIdCoSo!);
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      await phieuNganhTMProvider.deleteByCoSoId(currentIdCoSo!);
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

  onChangeInput(
      int maPhieu, String table, String? maCauHoi, String? fieldName, value,
      {String? fieldNameTotal}) async {
    log('ON onChangeInput: $fieldName $value');

    try {
      await updateAnswerToDB(table, fieldName ?? "", value);
      if (maCauHoi == colPhieuMauTBA3_2) {
        await updateAnswerDongCotToDB(table, fieldName!, value,
            fieldNames: fieldNameA3T,
            fieldNameTotal: colPhieuMauTBA3T,
            maCauHoi: maCauHoi);
      }
      if (maCauHoi == colPhieuTenCoSo) {}
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
        if (maCauHoi == colPhieuMauTBA4_1) {
          ///Hiển thị popup
          ///KIỂM TRA: CÂU 4T. TỔNG DOANH THU NĂM 2025 < 100 TRIỆU ĐỒNG
          ///VÀ CÂU 4.1_SỐ THÁNG CƠ SỞ CÓ HOẠT ĐỘNG SXKD < 3 THÁNG -> CƠ SỞ KHÔNG THUỘC ĐỐI TƯỢNG ĐIỀU TRA -> KẾT THÚC PHỎNG VẤN
          await kiemTraCau4T();
        } else if (maCauHoi == colPhieuMauTBA4_2) {
          ///Hiển thị popup
          ///KIỂM TRA: CÂU 4T. TỔNG DOANH THU NĂM 2025 < 100 TRIỆU ĐỒNG
          ///VÀ CÂU 4.1_SỐ THÁNG CƠ SỞ CÓ HOẠT ĐỘNG SXKD < 3 THÁNG -> CƠ SỞ KHÔNG THUỘC ĐỐI TƯỢNG ĐIỀU TRA -> KẾT THÚC PHỎNG VẤN
          await kiemTraCau4T();
        }
      }

      if (maCauHoi == colPhieuMauTBA4_3) {}
      //Van tai mẫu
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
        if (table == tablePhieuNganhVT) {
          if (maCauHoi == colPhieuNganhVTA1_M ||
              maCauHoi == colPhieuNganhVTA2_M) {
            await tinhSoLuotKhachVanChuyenA4VTMau();

            if (maCauHoi == colPhieuNganhVTA2_M) {}
          }

          if (maCauHoi == colPhieuNganhVTA3_M) {
            await tinhSoLuotKhachLuanChuyenA4VTMau();
          }

          if (maCauHoi == colPhieuNganhVTA6_M ||
              maCauHoi == colPhieuNganhVTA7_M) {
            await tinhKhoiLuongHangHoaVanChuyenA9MVTMau();

            if (maCauHoi == colPhieuNganhVTA7_M) {}
          }
          if (maCauHoi == colPhieuNganhVTA8_M) {
            await tinhKhoiLuongHangHoaLuanChuyenA9MVTMau();
          }
        } else if (table == tablePhieuNganhLT) {
          if (maCauHoi == colPhieuNganhLTA1_M ||
              maCauHoi == colPhieuNganhLTA2_M) {
            await tinhTongLuotKhachBQ1Thang();
          }
          if (maCauHoi == colPhieuNganhLTA1_1_M ||
              maCauHoi == colPhieuNganhLTA2_1_M) {
            await tinhTongLuotKhachBQ1ThangQuocTe();
          }
          if (maCauHoi == colPhieuNganhLTA5_M) {
            await tinhDoanhThuKhachNguQuaDem();
            await tinhDoanhThuKhachKhongNguQuaDem();
          }
          if (maCauHoi == colPhieuNganhLTA6_M) {
            await soNgayKhachDoCsPhucVu();
          }
        }
        if (maCauHoi == colPhieuNganhVTA1_M &&
            table == tablePhieuNganhVT &&
            maPhieu == AppDefine.maPhieuVTMau) {
          await tinhDoanhThuNganhVTHK();
        }
        if (maCauHoi == colPhieuNganhVTA6_M &&
            table == tablePhieuNganhVT &&
            maPhieu == AppDefine.maPhieuVTMau) {
          await tinhDoanhThuNganhVTHH();
        }
        if (maCauHoi == colPhieuNganhLTA2_M &&
            table == tablePhieuNganhLT &&
            maPhieu == AppDefine.maPhieuLTMau) {
          await tinhDoanhThuNganhLT();
        }
      }

      if (maCauHoi == colPhieuNganhTMA3 && table == tablePhieuNganhTM) {
        // var total3TValue = await totalA3TNganhtTM();
        // updateAnswerToDB(tablePhieuNganhTM, colPhieuNganhTMA3T, total3TValue);
        await tinhTongTriGiaVonCau3TNganhTM();
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  ///Hiển thị popup
  ///KIỂM TRA: CÂU 4T. TỔNG DOANH THU NĂM 2025 < 100 TRIỆU ĐỒNG
  ///VÀ CÂU 4.1_SỐ THÁNG CƠ SỞ CÓ HOẠT ĐỘNG SXKD < 3 THÁNG -> CƠ SỞ KHÔNG THUỘC ĐỐI TƯỢNG ĐIỀU TRA -> KẾT THÚC PHỎNG VẤN
  kiemTraCau4T() async {
    ///Lấy giá trị 4T
    var a4TValue = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA4T);
    var a4_1Value = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA4_1);
    if (a4TValue != null &&
        a4TValue < 100 &&
        a4_1Value != null &&
        a4_1Value < 3) {
      Get.dialog(DialogBarrierWidget(
          onPressedNegative: () async {
            Get.back();
          },
          onPressedPositive: () async {
            Future.delayed(const Duration(seconds: 2), () {
              onKetThucPhongVan(
                  lyDoKetThucPV: AppDefine.khongThuocDoiTuongDieuTra);
            });

            Get.back();
          },
          title: 'dialog_title_warning'.tr,
          content:
              'Câu 4T: Tổng doanh thu năm 2025 < 100 triệu và Câu 4.1: số tháng cơ sở có hoạt động SXKD < 3 tháng.',
          content2: 'Cơ sở không thuộc đối tượng điều tra.',
          content2StyleText: styleLargeBold.copyWith(color: warningColor)));
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
      await getTablePhieuMauTB();
    } else if (table == tablePhieuNganhVT) {
      await phieuNganhVTProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
      await getTablePhieuNganhVT();
    } else if (table == tablePhieuNganhLT) {
      await phieuNganhLTProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
      await getTablePhieuNganhLT();
    } else if (table == tablePhieuNganhTM) {
      await phieuNganhTMProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo!);
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
    } else if (table == tablePhieuNganhVT) {
      Map<String, dynamic> map =
          Map<String, dynamic>.from(answerTblPhieuNganhVT);
      map.update(fieldName, (val) => value, ifAbsent: () => value);
      answerTblPhieuNganhVT.value = map;
      answerTblPhieuNganhVT.refresh();
    } else if (table == tablePhieuNganhLT) {
      Map<String, dynamic> map =
          Map<String, dynamic>.from(answerTblPhieuNganhLT);
      map.update(fieldName, (val) => value, ifAbsent: () => value);
      answerTblPhieuNganhLT.value = map;
      answerTblPhieuNganhLT.refresh();
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
      int maPhieu,
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    if (fieldName == colPhieuMauTBSanPhamA5_1_1) {
      if (inputValue!.length > 250) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(1, 250)}';
      }
      return null;
    } else if (fieldName == colPhieuMauTBSanPhamA5_1_2) {
      var validRes = validateMaSanPhamPhanV(
          maPhieu,
          table,
          maCauHoi,
          fieldName,
          idValue,
          inputValue,
          minLen,
          maxLen,
          minValue,
          maxValue,
          loaiCauHoi,
          sttSanPham,
          typing);
      if (validRes != null && validRes != '') {
        return validRes;
      }
    } else if (fieldName == colPhieuMauTBSanPhamA5_2) {
      var validRes = onValidateInputA5_2(
          table,
          maCauHoi,
          fieldName,
          idValue,
          inputValue,
          minLen,
          maxLen,
          minValue,
          maxValue,
          loaiCauHoi,
          sttSanPham,
          typing);
      if (validRes != null && validRes != '') {
        return validRes;
      }
    } else if (fieldName == colPhieuMauTBA5T) {
      var validRes = onValidateInputA5T(maPhieu, table, maCauHoi, typing);
      if (validRes != null && validRes != '') {
        return validRes;
      }
    }

    return null;
  }

  validatePhanV() {}

  validateMaSanPhamPhanV(
      int maPhieu,
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    var c1_1Value =
        getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA1_1);
    if (tblPhieuMauTBSanPham.value.isNotEmpty) {
      var checkRes = isDuplicateVCPAA5_1_2(inputValue ?? '');
      if (checkRes) {
        return 'Mã sản phẩm này đã có. Vui lòng chọn mã sản phẩm khác.';
      }
      // var (resNganhCoSo, tenNganh) = hasVCPABangKeA5_1_2();
      // if (!resNganhCoSo) {
      //   return 'Chưa có mã ngành chính của cơ sở ($tenNganh).';
      // }

      if (tblPhieuMauTBSanPham.value.length == 1) {
        var maVcpaCap5 = tblPhieuMauTBSanPham.value
            .where((x) => x.a5_1_2 == inputValue)
            .firstOrNull;
        if (maVcpaCap5 != null) {
          if (maVcpaCap5.a5_1_2 != null) {
            ///- Chỉ có 1 ngành san phẩm và Mã VCPA cấp 2=68 và  C1.1=1|2|3|4|5; =>
            ///Cơ sở chỉ có 1 Ngành là 41. Dịch vụ kinh doanh Bất động sản (Mã ngành cấp 2=68) mà địa điểm tại C1.1 khác mã 6. Cơ sở không có địa điểm cố định ;
            var cap2 = maVcpaCap5.a5_1_2!.substring(0, 2);
            if (cap2 == '68') {
              if (c1_1Value != null && a1_1_DiaDiem.contains(c1_1Value)) {
                return 'Cơ sở chỉ có 1 Ngành là 68. Dịch vụ kinh doanh Bất động sản (Mã ngành cấp 2=68) mà địa điểm tại C1.1 khác mã 6. Cơ sở không có địa điểm cố định';
              }
            }
          }
        }
      }
      //- Chỉ có 1 hoặc nhiều ngành sản phẩm nhưng có mã ngành san phẩm và Mã ngành sản phẩm >=47811
      //và Mã ngành <=47899 mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định;
      //=> Cơ sở chỉ SXKD thuộc ngành Bán lẻ lương thực, thực phẩm, đồ uống, thuốc lá, thuốc lào lưu động
      //hoặc tại chợ (Mã ngành thuộc mã từ 47811 đến 47899) mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định
      var maVcpaCap5 = tblPhieuMauTBSanPham.value
          .where((x) =>
              TablePhieuMauTBSanPham.vcpaCap5Range47811To47899
                  .contains(x.a5_1_2) &&
              x.a5_1_2 == inputValue)
          .toList();
      if (maVcpaCap5.isNotEmpty) {
        if (c1_1Value != null && c1_1Value != 3) {
          return 'Cơ sở chỉ SXKD thuộc ngành Bán lẻ lương thực, thực phẩm, đồ uống, thuốc lá, thuốc lào lưu động hoặc tại chợ (Mã ngành thuộc mã từ 47811 đến 47899) mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định';
        }
      }

      //- Mã ngành=46492. Dịch vụ bán buôn dược phẩm và dụng cụ y tế hoặc mã ngành=47721.
      //Bán lẻ dược phẩm, dụng cụ y tế trong các cửa hàng chuyên doanh & C1.4=2|6
      var maVcpaCap546492 = tblPhieuMauTBSanPham.value
          .where((x) =>
              x.a5_1_2 != null &&
              (x.a5_1_2 == '46492' || x.a5_1_2 == '47721') &&
              x.a5_1_2 == inputValue)
          .toList();
      if (maVcpaCap5.isNotEmpty) {
        if ((c1_1Value != null && c1_1Value == 2) ||
            (c1_1Value != null && c1_1Value == 6)) {
          String msg =
              'Mã ngành=46492. Dịch vụ bán buôn dược phẩm và dụng cụ y tế hoặc mã ngành=47721. Bán lẻ dược phẩm, dụng cụ y tế trong các cửa hàng chuyên doanh phải đăng ký kinh doanh mà C1.4 =2|6 (Chưa có giấy ĐKKD/Không phải đăng ký kinh doanh)';

          return msg;
        }
      }
      // (Mã ngành sản phẩm>=86101 và Mã ngành<=86990.
      //Hoạt động y tế) hoặc (Mã ngành= 96310. Dịch vụ cắt tóc gội đầu)  hoặc ( mã ngành>=71101
      //và mã ngành<=71109. Hoạt động kiến trúc, kiểm tra và phân tích kỹ thuật) & C2.1_Tổng số =1 & C1.3.5=1. Chưa qua dào tạo?
      var c2_1Value =
          getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA2_1);
      var c1_3_5Value =
          getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA1_3_5);
      var maVcpaCap586101 = tblPhieuMauTBSanPham.value
          .where((x) =>
              TablePhieuMauTBSanPham.vcpaCap5Range86101To86990
                  .contains(x.a5_1_2) &&
              x.a5_1_2 == inputValue)
          .toList();
      if (maVcpaCap586101.isNotEmpty) {
        if (c2_1Value != null &&
            c2_1Value == 1 &&
            c1_3_5Value != null &&
            c1_3_5Value == 1) {
          return 'Cơ sở thuộc (Mã ngành sản phẩm>=86101 và Mã ngành<=86990. Hoạt động y tế) mà chỉ có 1 lao động là chủ cơ sở mà Trình độ CMKT chủ cơ sở=1. Chưa qua đào tạo';
        }
      }
      var maVcpaCap596310 = tblPhieuMauTBSanPham.value
          .where((x) => x.a5_1_2 == '96310' && x.a5_1_2 == inputValue)
          .toList();
      if (maVcpaCap596310.isNotEmpty) {
        if (c2_1Value != null &&
            c2_1Value == 1 &&
            c1_3_5Value != null &&
            c1_3_5Value == 1) {
          return 'Cơ sở thuộc (Mã ngành= 96310. Dịch vụ cắt tóc gội đầu) mà chỉ có 1 lao động là chủ cơ sở mà Trình độ CMKT chủ cơ sở=1. Chưa qua đào tạo';
        }
      }
      var maVcpaCap571101To71109 = tblPhieuMauTBSanPham.value
          .where((x) =>
              TablePhieuMauTBSanPham.vcpaCap5Range71101To71109
                  .contains(x.a5_1_2) &&
              x.a5_1_2 == inputValue)
          .toList();
      if (maVcpaCap571101To71109.isNotEmpty) {
        if (c2_1Value != null &&
            c2_1Value == 1 &&
            c1_3_5Value != null &&
            c1_3_5Value == 1) {
          return 'Cơ sở thuộc (mã ngành>=71101 và mã ngành<=71109. Hoạt động kiến trúc, kiểm tra và phân tích kỹ thuật) mà chỉ có 1 lao động là chủ cơ sở mà Trình độ CMKT chủ cơ sở=1. Chưa qua đào tạo';
        }
      }
    }

    return null;
  }

  isDuplicateVCPAA5_1_2(String value) {
    List<String> res = [];
    for (var item in tblPhieuMauTBSanPham) {
      if (item.a5_1_2 == value) {
        res.add(value);
      }
    }
    if (res.isNotEmpty && res.length >= 2) {
      return true;
    }
    return false;
  }

  isDuplicateVCPAA1_2CN(String value) {
    List<String> res = [];
    for (var item in tblPhieuNganhCN) {
      if (item.a1_2 == value) {
        res.add(value);
      }
    }
    if (res.isNotEmpty && res.length >= 2) {
      return true;
    }
    return false;
  }

  (bool, String) hasVCPABangKeA5_1_2() {
    List<String> res = [];
    var maNganhCoSo =
        generalInformationController.tblBkCoSoSXKDNganhSanPham.value;
    if (maNganhCoSo != null) {
      for (var item in tblPhieuMauTBSanPham) {
        if (item.a5_1_2 == maNganhCoSo.maNganh!) {
          res.add(item.a5_1_2!);
        }
      }
      if (res.isNotEmpty) {
        return (true, '${maNganhCoSo.maNganh} - ${maNganhCoSo.tenNganh}');
      }
    }
    return (false, '${maNganhCoSo.maNganh} - ${maNganhCoSo.tenNganh}');
  }

  validateAllMaSanPhamPhanV() {
    var c1_1Value =
        getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA1_1);
    if (tblPhieuMauTBSanPham.value.isNotEmpty) {
      if (tblPhieuMauTBSanPham.value.length == 1) {
        var maVcpaCap5 = tblPhieuMauTBSanPham.value.firstOrNull;
        if (maVcpaCap5 != null) {
          if (maVcpaCap5.a5_1_2 != null) {
            ///- Chỉ có 1 ngành san phẩm và Mã VCPA cấp 2=68 và  C1.1=1|2|3|4|5; =>
            ///Cơ sở chỉ có 1 Ngành là 41. Dịch vụ kinh doanh Bất động sản (Mã ngành cấp 2=68) mà địa điểm tại C1.1 khác mã 6. Cơ sở không có địa điểm cố định ;
            var cap2 = maVcpaCap5.a5_1_1!.substring(0, 2);
            if (cap2 == '68') {
              if (c1_1Value != null && a1_1_DiaDiem.contains(c1_1Value)) {
                return 'Cơ sở chỉ có 1 Ngành là 68. Dịch vụ kinh doanh Bất động sản (Mã ngành cấp 2=68) mà địa điểm tại C1.1 khác mã 6. Cơ sở không có địa điểm cố định';
              }
            }
          }
        }
      }
      //- Chỉ có 1 hoặc nhiều ngành sản phẩm nhưng có mã ngành san phẩm và Mã ngành sản phẩm >=47811
      //và Mã ngành <=47899 mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định;
      //=> Cơ sở chỉ SXKD thuộc ngành Bán lẻ lương thực, thực phẩm, đồ uống, thuốc lá, thuốc lào lưu động
      //hoặc tại chợ (Mã ngành thuộc mã từ 47811 đến 47899) mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định
      var maVcpaCap5 = tblPhieuMauTBSanPham.value
          .where((x) => TablePhieuMauTBSanPham.vcpaCap5Range47811To47899
              .contains(x.a5_1_2))
          .toList();
      if (maVcpaCap5.isNotEmpty) {
        if (c1_1Value != null && c1_1Value != 3) {
          return 'Cơ sở chỉ SXKD thuộc ngành Bán lẻ lương thực, thực phẩm, đồ uống, thuốc lá, thuốc lào lưu động hoặc tại chợ (Mã ngành thuộc mã từ 47811 đến 47899) mà Địa điểm cơ sở tại C1.1. Địa điểm khác mã 3. Tại chợ hoặc mã 6.Địa điểm không cố định';
        }
      }

      //- Mã ngành=46492. Dịch vụ bán buôn dược phẩm và dụng cụ y tế hoặc mã ngành=47721.
      //Bán lẻ dược phẩm, dụng cụ y tế trong các cửa hàng chuyên doanh & C1.4=2|6
      var maVcpaCap546492 = tblPhieuMauTBSanPham.value
          .where((x) =>
              x.a5_1_2 != null && x.a5_1_2 == '46492' || x.a5_1_2 == '47721')
          .toList();
      if (maVcpaCap5.isNotEmpty) {
        if ((c1_1Value != null && c1_1Value == 2) ||
            (c1_1Value != null && c1_1Value == 6)) {
          String msg =
              'Mã ngành=46492. Dịch vụ bán buôn dược phẩm và dụng cụ y tế hoặc mã ngành=47721. Bán lẻ dược phẩm, dụng cụ y tế trong các cửa hàng chuyên doanh phải đăng ký kinh doanh mà C1.4 =2|6 (Chưa có giấy ĐKKD/Không phải đăng ký kinh doanh)';

          return msg;
        }
      }
      // (Mã ngành sản phẩm>=86101 và Mã ngành<=86990.
      //Hoạt động y tế) hoặc (Mã ngành= 96310. Dịch vụ cắt tóc gội đầu)  hoặc ( mã ngành>=71101
      //và mã ngành<=71109. Hoạt động kiến trúc, kiểm tra và phân tích kỹ thuật) & C2.1_Tổng số =1 & C1.3.5=1. Chưa qua dào tạo?
      var c2_1Value =
          getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA2_1);
      var c1_3_5Value =
          getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA1_3_5);
      var maVcpaCap586101 = tblPhieuMauTBSanPham.value
          .where((x) => TablePhieuMauTBSanPham.vcpaCap5Range86101To86990
              .contains(x.a5_1_2))
          .toList();
      if (maVcpaCap586101.isNotEmpty) {
        if (c2_1Value != null &&
            c2_1Value == 1 &&
            c1_3_5Value != null &&
            c1_3_5Value == 1) {
          return 'Cơ sở thuộc (Mã ngành sản phẩm>=86101 và Mã ngành<=86990. Hoạt động y tế) mà chỉ có 1 lao động là chủ cơ sở mà Trình độ CMKT chủ cơ sở=1. Chưa qua đào tạo';
        }
      }
      var maVcpaCap596310 =
          tblPhieuMauTBSanPham.value.where((x) => x.a5_1_2 == '96310').toList();
      if (maVcpaCap596310.isNotEmpty) {
        if (c2_1Value != null &&
            c2_1Value == 1 &&
            c1_3_5Value != null &&
            c1_3_5Value == 1) {
          return 'Cơ sở thuộc (Mã ngành= 96310. Dịch vụ cắt tóc gội đầu) mà chỉ có 1 lao động là chủ cơ sở mà Trình độ CMKT chủ cơ sở=1. Chưa qua đào tạo';
        }
      }
      var maVcpaCap571101To71109 = tblPhieuMauTBSanPham.value
          .where((x) => TablePhieuMauTBSanPham.vcpaCap5Range71101To71109
              .contains(x.a5_1_2))
          .toList();
      if (maVcpaCap571101To71109.isNotEmpty) {
        if (c2_1Value != null &&
            c2_1Value == 1 &&
            c1_3_5Value != null &&
            c1_3_5Value == 1) {
          return 'Cơ sở thuộc (mã ngành>=71101 và mã ngành<=71109. Hoạt động kiến trúc, kiểm tra và phân tích kỹ thuật) mà chỉ có 1 lao động là chủ cơ sở mà Trình độ CMKT chủ cơ sở=1. Chưa qua đào tạo';
        }
      }
    }

    return null;
  }

  showErrorDialog(String message) {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {},
      onPressedPositive: () async {
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: message,
      isCancelButton: false,
    ));
  }

  onValidateInputA5_2(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    num minVal = minValue ?? 1;
    num maxVal = maxValue ?? 999999;
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    inputValue = inputValue!.replaceAll(' ', '');
    num intputVal =
        inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
    if (intputVal < minVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    } else if (intputVal > maxVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    }
    if (fieldName == colPhieuMauTBSanPhamA5_2) {}
    return null;
  }

  onValidateNganhCN(
      int maPhieu,
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    if (maCauHoi != 'A2_1') {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
    }
    if (fieldName == colPhieuNganhCNA1_1) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      if (inputValue!.length > 250) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(1, 250)}';
      }
      return null;
    } else if (fieldName == colPhieuNganhCNA1_2) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      var checkRes = isDuplicateVCPAA1_2CN(inputValue ?? '');
      if (checkRes) {
        return 'Mã sản phẩm này đã có. Vui lòng chọn mã sản phẩm khác.';
      }
    } else if (fieldName == colPhieuNganhCNA2_1) {
    } else if (fieldName == colPhieuNganhCNA2_2) {
      num minVal = minValue ?? 1;
      num maxVal = maxValue ?? 999999999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
      return null;
    }
    return null;
  }

  onValidateInputA5_5(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    // if (fieldName == columnPhieuMauSanPhamA5_5) {
    //   if (inputValue == null || inputValue == '' || inputValue == 'null') {
    //     return 'Vui lòng nhập giá trị.';
    //   }
    //   double a5_5Value =
    //       AppUtils.convertStringToDouble(inputValue.replaceAll(' ', ''));
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
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      int sttSanPham,
      bool typing) {
    // if (fieldName == columnPhieuMauSanPhamA5_6_1) {
    //   // if (inputValue == null || inputValue == '' || inputValue == 'null') {
    //   //   return 'Vui lòng nhập giá trị.';
    //   // }
    //   double a5_6_1Value = AppUtils.convertStringToDouble(inputValue);
    //   var a5_6Value = getValueSanPham(
    //       tablePhieuMauSanPham, columnPhieuMauSanPhamA5_6, idValue);
    //   if (a5_6Value == 1) {
    //     if (inputValue == null || inputValue == '' || inputValue == 'null') {
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
  onValidateInputA5T(int maPhieu, String table, String maCauHoi, bool typing) {
    if (maCauHoi == colPhieuMauTBA5T) {
      var a4TValue = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA4T);
      var a5TValue = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA5T);
      if (typing == false) {
        var a4TValue =
            getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA4T);
        var a5TValue =
            getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA5T);
      }

      double a4TVal = 0.0;
      double a5TVal = 0.0;

      if (a4TValue != null) {
        a4TVal = AppUtils.convertStringToDouble(a4TValue);
      }
      if (a5TValue != null) {
        a5TVal = AppUtils.convertStringToDouble(a5TValue);
      }
      String a4TValView = toCurrencyString(a4TVal.toString(),
          thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
          mantissaLength: 2);
      String a5TValView = toCurrencyString(a5TVal.toString(),
          thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
          mantissaLength: 2);
      if (a5TValue != null && a4TValue != null && a5TValue < a4TValue) {
        return 'Tổng doanh thu các sản phẩm năm 2025 ($a5TValView) < Tổng doanh thu của cơ sở năm 2025 (${a4TValView})';
      }
      if (a4TVal > 0) {
        var phanTramDT = (a5TVal / a4TVal) * 100;
        if (phanTramDT < 70) {
          return 'Tổng doanh thu các sản phẩm < 70% so với Tổng doanh thu của cơ sở tại câu 4T. Yêu cầu khai thác doanh thu các sản phẩm phải đạt từ 70% Tổng doanh thu của cơ sở trở lên';
        }
      }
    }
    //}
    return null;
  }

  ///

  onValidateInputA6_8(String table, String maCauHoi, String? fieldName, idValue,
      String? inputValue, minLen, maxLen, minValue, maxValue, int loaiCauHoi) {
    return ValidateQuestionNo07.onValidateInputA6_8(table, maCauHoi, fieldName,
        idValue, inputValue, minLen, maxLen, minValue, maxValue, loaiCauHoi);
  }

  onValidateInput(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? inputValue) {
    var table = question.bangDuLieu;
    var maCauHoi = question.maCauHoi;
    var minValue = chiTieuCot!.giaTriNN;
    var maxValue = chiTieuCot.giaTriLN;
  }

  ///END:: A6_8 event
/*******/

/*******/

  ///BEGIN::EVEN SELECT INT
  onSelect(String table, String? maCauHoi, String? fieldName, value) {
    log('ON CHANGE $maCauHoi: $fieldName $value');

    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblPhieuMau(fieldName, value, table);
      if (maCauHoi == colPhieuMauTBA10_M) {
        if (!value.toString().contains("1")) {
          updateAnswerToDB(table, colPhieuMauTBA10_1_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA10_1_M, null, table);
        } else if (!value.toString().contains("2")) {
          updateAnswerToDB(table, colPhieuMauTBA10_2_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA10_2_M, null, table);
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  onSelectDm(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, value, dmItem,
      {ChiTieuDongModel? chiTieuDong, ChiTieuModel? chiTieuCot}) {
    log('ON CHANGE onSelectDm: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblPhieuMau(fieldName, value, table);

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
      if (maCauHoi == colPhieuMauTBA1_3_5 &&
          question.maPhieu == AppDefine.maPhieuTB) {
        onValidateA1_3_5TB(question, table, maCauHoi, fieldName, value, dmItem);
      }
      if (maCauHoi == colPhieuMauTBA1_5) {
        if (value != 1) {
          updateAnswerToDB(table, colPhieuMauTBA1_5_1, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA1_5_1, null, table);
        }
      }
      if (table == tablePhieuNganhTM && maCauHoi == colPhieuNganhTMA2) {
        if (value == 2) {
          onKetThucPhongVan();
        }
      }
      if (table == tablePhieuMauTB &&
          maCauHoi == colPhieuMauTBA7_3_M &&
          question.maPhieu == AppDefine.maPhieuMau) {
        if (value != 1) {
          updateAnswerToDB(table, colPhieuMauTBA7_4_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA7_4_M, null, table);
        }
      }
      if (table == tablePhieuMauTB &&
          maCauHoi == colPhieuMauTBA7_5_M &&
          question.maPhieu == AppDefine.maPhieuMau) {
        if (value != 1) {
          updateAnswerToDB(table, colPhieuMauTBA7_6_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA7_6_M, null, table);
        }
      }
      if (table == tablePhieuMauTB &&
          maCauHoi == colPhieuMauTBA9_M &&
          question.maPhieu == AppDefine.maPhieuMau) {
        if (value != 1) {
          updateAnswerToDB(table, colPhieuMauTBA10_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA10_M, null, table);

          updateAnswerToDB(table, colPhieuMauTBA10_1_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA10_1_M, null, table);

          updateAnswerToDB(table, colPhieuMauTBA10_2_M, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA10_2_M, null, table);
        }

        if (value == 2) {
          var a7_3_MValue =
              getValueByFieldName(question.bangDuLieu!, colPhieuMauTBA7_3_M);
          var a7_5_MValue =
              getValueByFieldName(question.bangDuLieu!, colPhieuMauTBA7_5_M);
          if ((a7_3_MValue != null && a7_3_MValue == 1)) {
            String wrnText =
                'Cơ sở có hoạt động cung cấp sản phẩm dịch vụ qua website, ứng dụng trực tuyến, nền tảng trung gian (shoppee, booking,…) C3 = 1 mà lại không có hoạt động logistic (vận chuyển hàng hóa…) C9=2?';
            warningA9MDialog(wrnText);
          } else if ((a7_5_MValue != null && a7_5_MValue == 1)) {
            String wrnText =
                'Cơ sở có hoạt động cung cấp sản phẩm dịch vụ qua website, ứng dụng trực tuyến, nền tảng trung gian (shoppee, booking,…) C5=1 mà lại không có hoạt động logistic (vận chuyển hàng hóa…) C9=2?';
            warningA9MDialog(wrnText);
          } else {
            onKetThucPhongVan();
          }
        }
      }
      if (table == tablePhieuMauTB &&
          maCauHoi == "A7_1" &&
          question.maPhieu == AppDefine.maPhieuTB) {
        if (value == 2) {
          updateAnswerToDB(table, colPhieuMauTBA7_2, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA7_2, null, table);
          updateAnswerToDB(table, colPhieuMauTBA7_3, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA7_3, null, table);
        }
      }
      if (table == tablePhieuMauTB &&
          maCauHoi == "A7_2" &&
          question.maPhieu == AppDefine.maPhieuTB) {
        if (value == 2) {
          updateAnswerToDB(table, colPhieuMauTBA7_3, null);
          updateAnswerTblPhieuMau(colPhieuMauTBA7_3, null, table);
        }
      }
      if (table == tablePhieuMauTB &&
          maCauHoi == "A7_4" &&
          question.maPhieu == AppDefine.maPhieuTB) {
        if (value == 2) {
          String fieldName = 'A7_4_${chiTieuDong!.maSo}_2';
          updateAnswerToDB(table, fieldName, null);
          updateAnswerTblPhieuMau(fieldName, null, table);
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  onValidateA1_3_5TB(QuestionCommonModel question, String table,
      String? maCauHoi, String? fieldName, value, dmItem) {
    if (maCauHoi == colPhieuMauTBA1_3_5) {
      if (a1_3_5TBMaTDCM.contains(value)) {
        //Nam sinh
        var a1_3_2Value = answerTblPhieuMau[colPhieuMauTBA1_3_2];
        if (a1_3_2Value != null) {
          if (value == 6) {
            if (a1_3_2Value > 2008) {
              updateAnswerToDB(table, colPhieuMauTBA1_3_5, null);
              updateAnswerTblPhieuMau(colPhieuMauTBA1_3_5, null, table);
              return showError('Dưới 17 tuổi mà đã tốt nghiệp cao đẳng.');
            }
          }
          if (value == 7) {
            if (a1_3_2Value > 2006) {
              updateAnswerToDB(table, colPhieuMauTBA1_3_5, null);
              updateAnswerTblPhieuMau(colPhieuMauTBA1_3_5, null, table);
              return showError('Tuổi dưới 19 mà tốt nghiệp đại học.');
            }
          }
          if (value == 8) {
            if (a1_3_2Value > 2005) {
              updateAnswerToDB(table, colPhieuMauTBA1_3_5, null);
              updateAnswerTblPhieuMau(colPhieuMauTBA1_3_5, null, table);
              return showError('Dưới 20 tuổi mà đã tốt nghiệp thạc sỹ.');
            }
          }
          if (value == 9 || value == 10) {
            if (a1_3_2Value > 2002) {
              updateAnswerToDB(table, colPhieuMauTBA1_3_5, null);
              updateAnswerTblPhieuMau(colPhieuMauTBA1_3_5, null, table);
              return showError(
                  'Dưới 23 tuổi mà tốt nghiệp trình độ tiến sỹ hoặc sau tiến sỹ');
            }
          }
        }
      }
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
    if ((question.maCauHoi == "A1" &&
        question.maPhieu == AppDefine.maPhieuLT)) {
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
      String? inputValue, int? loaiCauHoi) {
    if (inputValue == null || inputValue == '' || inputValue == 'null') {
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
          TableDmDanToc inputValue = value;
          if (inputValue != null) {
            maDanToc = inputValue.maDanToc!;
            tenDanToc = inputValue.tenDanToc!;
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
        await updateAnswerDongCotToDB(table, fieldName!, value,
            maCauHoi: maCauHoi);
        if (maCauHoi == "A6_1_M" && question!.maPhieu == AppDefine.maPhieuMau) {
          await tongKhoiLuongNangLuong();
        }
      } else if (table == tablePhieuNganhVT) {
        if (isA1NganhVT(question!, chiTieuDong!, chiTieuCot!)) {
          await updateAnswerDongCotToDB(table, fieldName!, value,
              maCauHoi: maCauHoi);
          await tinhTongTaiTrongA1NganhVT(
              question, table, chiTieuDong, chiTieuCot);
          await tinhTongA5A6NganhVT(question);
        } else if (isA7NganhVT(question, chiTieuDong, chiTieuCot)) {
          await updateAnswerDongCotToDB(table, fieldName!, value,
              maCauHoi: maCauHoi);
          await tinhTongTaiTrongA7NganhVT(
              question, table, chiTieuDong, chiTieuCot);
          await tinhTongA11A12NganhVT(question);
        }
      } else if (table == tablePhieuNganhLT) {
        // if (maCauHoi == "A1" && question!.maPhieu == AppDefine.maPhieuLT) {
        //   if (a7_1FieldWarning.contains(fieldName)) {
        //     await warningA7_1_X3SoPhongTangMoi(chiTieuDong!.maSo!);
        //   }
        // }
        await updateAnswerDongCotToDB(table, fieldName!, value,
            maCauHoi: maCauHoi);
        await tinhTongSoPhongA5LT(question!);
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
        if (maCauHoi == "A3_1") {
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
      }
    } else if (table == tablePhieuNganhVT) {
      await phieuNganhVTProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
    } else if (table == tablePhieuNganhLT) {
      await phieuNganhLTProvider.updateValueByIdCoSo(
          fieldName, value, currentIdCoSo);
      await updateAnswerTblPhieuMau(fieldName, value, table);
    }
  }

  onValidateInputChiTieuDongCot(
      QuestionCommonModel question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong,
      String? inputValue,
      {bool typing = true,
      String? fieldName,
      TablePhieuNganhVTGhiRo? ghiRoItem}) {
    var tblPhieuCT = getTableByTableName(question.bangDuLieu!, typing);
    if (tblPhieuCT == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    if (question.maCauHoi == colPhieuMauTBA1_1 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_1) {
        var a1_1Value = tblPhieuCT[colPhieuMauTBA1_1];
        if (validateEmptyString(a1_1Value.toString())) {
          return 'Vui lòng chọn giá trị.';
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_1 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null && fieldName != '' && fieldName.contains('GhiRo')) {
        var a1_1Value = tblPhieuCT[colPhieuMauTBA1_1];
        if (a1_1Value.toString() == '5') {
          if (validateEmptyString(inputValue.toString())) {
            return 'Vui lòng nhập giá trị Ghi rõ.';
          }
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_2 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_2) {
        var a1_2Value = tblPhieuCT[colPhieuMauTBA1_2];
        if (validateEmptyString(a1_2Value.toString())) {
          return 'Vui lòng chọn giá trị.';
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_3_1 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_3_1) {
        var a1_2Value = tblPhieuCT[colPhieuMauTBA1_3_1];
        if (validateEmptyString(a1_2Value.toString())) {
          return 'Vui lòng chọn Giới tính';
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_3_3 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập Dân tộc.';
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_3_4 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_3_4) {
        var a1_2Value = tblPhieuCT[colPhieuMauTBA1_3_4];
        if (validateEmptyString(a1_2Value.toString())) {
          return 'Vui lòng chọn Quốc tịch';
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_3_5 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_3_5) {
        var a1_2Value = tblPhieuCT[colPhieuMauTBA1_3_5];
        if (validateEmptyString(a1_2Value.toString())) {
          return 'Vui lòng chọn Trình độ chuyên môn';
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_4 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_4) {
        var a1_2Value = tblPhieuCT[colPhieuMauTBA1_4];
        if (validateEmptyString(a1_2Value.toString())) {
          return 'Vui lòng chọn Tình trạng đăng ký kinh doanh';
        }
        return null;
      }
    }
    if (question.maCauHoi == colPhieuMauTBA1_5 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (fieldName != null &&
          fieldName != '' &&
          fieldName == colPhieuMauTBA1_5) {
        var a1_2Value = tblPhieuCT[colPhieuMauTBA1_5];
        if (validateEmptyString(a1_2Value.toString())) {
          return 'Vui lòng chọn Cơ sở có mã số thuế không?';
        }
        return null;
      }
    }
    if (question.maCauHoi == "A3_1" &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var resValid = onValidateA3_1(
          question, chiTieuCot, chiTieuDong, inputValue,
          typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (question.maCauHoi == "A6_1" &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var resValid = onValidateA6_1(
          question, chiTieuCot, chiTieuDong, fieldName, inputValue,
          typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (question.maCauHoi == "A7_4") {
      var resValid = onValidateA7_4(
          question, chiTieuCot, chiTieuDong, fieldName, inputValue,
          typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (question.maCauHoi == "A1" && question.maPhieu == AppDefine.maPhieuVT) {
      var resValid = onValidateA1VTHK(
          question, chiTieuCot, chiTieuDong, fieldName, inputValue,
          ghiRoItem: ghiRoItem, typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (question.maCauHoi == "A7" && question.maPhieu == AppDefine.maPhieuVT) {
      var resValid = onValidateA7VTHH(
          question, chiTieuCot, chiTieuDong, fieldName, inputValue,
          ghiRoItem: ghiRoItem, typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (question.maCauHoi == "A1" && question.maPhieu == AppDefine.maPhieuLT) {
      var resValid = onValidateA1LT(
          question, chiTieuCot, chiTieuDong, fieldName, inputValue,
          ghiRoItem: ghiRoItem, typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (question.maCauHoi == "A6_1_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var resValid = onValidateA6_1_MMau(
          question, chiTieuCot, chiTieuDong, fieldName, inputValue,
          ghiRoItem: ghiRoItem, typing: typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
  }

  onValidateA7_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false}) {
    // if (typing == false) {
    //   for (var i = 1; i <= 5; i++) {
    //     var fName = 'A7_1_${i.toString()}_0';
    //     if (fieldName == fName) {
    //       if (validateEmptyString(inputValue.toString())) {
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
    //         if (inputValue == null ||
    //             inputValue == "null" ||
    //             inputValue == "") {
    //           return 'Vui lòng nhập giá trị.';
    //         }
    //       }
    //     }
    //   }
    // }
    return null;
  }

  onValidateA6_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false}) {
    if (typing == false) {
      for (var i = 1; i <= 11; i++) {
        var fName = 'A6_1_${i.toString()}_1';
        if (fieldName == fName) {
          if (validateEmptyString(inputValue.toString())) {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }

      var tblPhieu = getTableByTableName(question.bangDuLieu!, typing);
      if (tblPhieu == null) {
        return 'khonglay_duoc_dulieu_kiemtra'.tr;
      }
      //Cơ sở thuộc ngành 49. Dịch vụ vận tải đường sắt, đường bộ và đường ống hoặc mã 50.
      //Dịch vụ vận tải đường thủy (trừ mã 49313 hoặc 49334) mà C6.1 mã 1 đến mã 9 đều =2. không;

      List<String> a6_1Cot1Val = [];
      for (var i = 1; i <= 9; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var a8_1_x_1Value = tblPhieu[fName1];

        if (a8_1_x_1Value != null) {
          if (a8_1_x_1Value.toString() == '2') {
            a6_1Cot1Val.add(a8_1_x_1Value.toString());
          }
        }
      }

      if (a6_1Cot1Val.isNotEmpty && a6_1Cot1Val.length == 9) {
        var vcpa49_50 = validateA6_1MaSanPhamPhanV();
        if (vcpa49_50 == '49') {
          return 'Cơ sở thuộc ngành 49. Dịch vụ vận tải đường sắt, đường bộ và đường ống mà không sử dụng năng lượng điện/than/xăng/các loại dầu (C6.1 mã 1 đến mã 5 đều chọn mã 2. Không)?';
        }
        if (vcpa49_50 == '50') {
          return 'Cơ sở thuộc ngành 50. Dịch vụ vận tải đường thủy (trừ mã 49313 hoặc 49334) mà không sử dụng năng lượng điện/than/xăng/các loại dầu (C6.1 mã 1 đến mã 5 đều chọn mã 2. Không)?';
        }
      }

      List<String> a6_1Cot1Val2 = [];
      for (var i = 1; i <= 11; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var a8_1_x_1Value = tblPhieu[fName1];
        // if (fieldName == fName1) {
        if (a8_1_x_1Value != null) {
          if (a8_1_x_1Value.toString() == '2') {
            a6_1Cot1Val2.add(a8_1_x_1Value.toString());
          }
        }
        //  }
      }
      if (a6_1Cot1Val2.isNotEmpty && a6_1Cot1Val2.length == 9) {
        var vcpa49_50 = validateA6_1MaSanPhamPhanV();
        if (vcpa49_50 == '50') {
          return 'Ngành là dịch vụ lưu trú (Mã ngành cấp 2 là 55) mà không sử dụng bất kỳ loại năng lượng nào?';
        }
      }
      return null;
    }
  }

  String validateA6_1MaSanPhamPhanV() {
    var c1_1Value =
        getValueByFieldNameFromDB(tablePhieuMauTB, colPhieuMauTBA1_1);
    if (tblPhieuMauTBSanPham.value.isNotEmpty) {
      var maVcpa49 = tblPhieuMauTBSanPham.value.where((x) =>
          x.a5_1_2 != null &&
          x.a5_1_2!.substring(0, 2) == '49' &&
          (x.a5_1_2 != '49313' && x.a5_1_2 != '49334'));
      if (maVcpa49.isNotEmpty) {
        return '49';
      }
      var maVcpa50 = tblPhieuMauTBSanPham.value
          .where((x) => x.a5_1_2 != null && x.a5_1_2!.substring(0, 2) == '50');
      if (maVcpa50.isNotEmpty) {
        return '50';
      }
      var maVcpa55 = tblPhieuMauTBSanPham.value
          .where((x) => x.a5_1_2 != null && x.a5_1_2!.substring(0, 2) == '55');
      if (maVcpa50.isNotEmpty) {
        return '55';
      }
      var maVcpaCN10To39 = tblPhieuMauTBSanPham.value.where((x) =>
          TablePhieuMauTBSanPham.vcpaCap2CN10To39
              .contains(x.a5_1_2!.substring(0, 2)));
      if (maVcpa50.isNotEmpty) {
        return 'cn10to39';
      }
      var maVcpa46and47 = tblPhieuMauTBSanPham.value.where((x) =>
          x.a5_1_2 != null && x.a5_1_2!.substring(0, 2) == '46' ||
          x.a5_1_2!.substring(0, 2) == '47');
      if (maVcpa50.isNotEmpty) {
        return '4647';
      }
      var maVcpa93290 = tblPhieuMauTBSanPham.value
          .where((x) => x.a5_1_2 != null && x.a5_1_2! == '93290');
      if (maVcpa50.isNotEmpty) {
        return '93290';
      }

      var maVcpa62010To62090 = tblPhieuMauTBSanPham.value.where((x) =>
          x.a5_1_2 != null &&
          TablePhieuMauTBSanPham.vcpaCap5Range62010To62090.contains(x.a5_1_2!));
      if (maVcpa50.isNotEmpty) {
        return '62010To62090';
      }
    }

    return '';
  }

  onValidateA7_4(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false}) {
    num minVal = chiTieuCot!.giaTriNN ?? 1;
    num maxVal = chiTieuCot!.giaTriLN ?? 999999;

    inputValue = inputValue!.replaceAll(' ', '');
    num intputVal =
        inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
    if (intputVal < minVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    } else if (intputVal > maxVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    }
    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName = 'A7_4_${i.toString()}_1';
      if (fieldName == fName) {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị.';
        }
      }
    }
    var tblPhieu = getTableByTableName(question.bangDuLieu!, typing);
    if (tblPhieu == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    for (var i = 1; i <= 4; i++) {
      var fName1 = 'A7_4_${i.toString()}_1';
      var fName2 = 'A7_4_${i.toString()}_2';
      var a4_5_x_1Value = tblPhieu[fName1];
      if (fieldName == fName2) {
        if (a4_5_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
    }

    return null;
  }

  onValidateA1VTHK(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false, TablePhieuNganhVTGhiRo? ghiRoItem}) {
    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName = 'A1_${i.toString()}_1';
      if (fieldName == fName) {
        if (validateEmptyString(inputValue.toString())) {
          return 'Vui lòng chọn giá trị.';
        }
      }
    }
    var tblPhieu = getTableByTableName(question.bangDuLieu!, typing);
    if (tblPhieu == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    if (chiTieuCot!.maChiTieu == "2" &&
        chiTieuDong!.maSo != "13" &&
        chiTieuDong!.maSo != "15") {
      num minVal = chiTieuCot.giaTriNN ?? 1;
      num maxVal = chiTieuCot.giaTriLN ?? 999;
      var fName1 = 'A1_${chiTieuDong.maSo}_1';
      var fName2 = 'A1_${chiTieuDong.maSo}_2';
      if (fName2 == fieldName) {
        var a1_x_1Value = tblPhieu[fName1];
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập giá trị.';
          }
          inputValue = inputValue!.replaceAll(' ', '');
          num intputVal = inputValue != null
              ? AppUtils.convertStringToDouble(inputValue)
              : 0;
          if (intputVal < minVal) {
            return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          } else if (intputVal > maxVal) {
            return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          }
        }
      }
      return null;
    }

    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName1 = 'A1_${i.toString()}_1';
      var fName2 = 'A1_${i.toString()}_2';
      var a1_x_1Value = tblPhieu[fName1];
      if (fieldName == fName2) {
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue.toString())) {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
    }
    var tblPhieuMauTBData = getTableByTableName(tablePhieuMauTB, typing);
    var a6_1Dien = tblPhieuMauTBData[colPhieuMauTBA6_1_1_1];
    var a6_1Xang = tblPhieuMauTBData[colPhieuMauTBA6_1_3_1];
    var a6_1Diezel = tblPhieuMauTBData[colPhieuMauTBA6_1_5_1];
    List<String> vt = [];
    for (var i = 1; i <= 12; i++) {
      var fName1 = 'A1_${i.toString()}_1';
      var fName2 = 'A1_${i.toString()}_2';
      var a1_x_1Value = tblPhieu[fName1];
      if (a1_x_1Value.toString() == '1') {
        if (fieldName == fName2) {
          if (inputValue == null ||
              inputValue == "null" ||
              inputValue == "" ||
              validateEqual0InputValue(inputValue)) {
            if (a6_1Dien != null &&
                a6_1Dien == 2 &&
                a6_1Diezel != null &&
                a6_1Diezel == 2 &&
                a6_1Xang != null &&
                a6_1Xang == 2) {
              return 'Cơ sở có loại xe từ 2 đến 45 chỗ mà không sử dụng năng lượng là xăng, dầu diezel, điện (C6.1_xăng/dầu diezel/điện=2)có đúng không?';
            }
          }
        }
      }
    }
    if (chiTieuDong!.maSo == "14") {
      var fName1 = 'A1_${chiTieuDong.maSo}_1';
      var fName3 = 'A1_${chiTieuDong.maSo}_3';
      var tenChiTieu = chiTieuDong.tenChiTieu ?? '';
      if (fieldName == fName3) {
        var a1_x_1Value = tblPhieu[fName1];
        if (a1_x_1Value.toString() == '1') {
          if (inputValue == null ||
              inputValue == "null" ||
              inputValue == "" ||
              validateEqual0InputValue(inputValue)) {
            return '$tenChiTieu có tải trọng phải lớn hơn 0';
          }
        }
      }
    }

    return null;
  }

  onValidateInputChiTieuDongCotGhiRo(
      QuestionCommonModel question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong,
      String? fieldName,
      String? inputValue,
      {bool typing = false,
      TablePhieuNganhVTGhiRo? ghiRoItem}) {
    if (chiTieuDong!.maSo == "13") {
      if (chiTieuCot!.maChiTieu == "2") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }
            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
        }
      }
      if (chiTieuCot!.maChiTieu == "3") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 9999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }

            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
          if (ghiRoItem != null) {
            var tenChiTieu = 'Phương tiện chở khách khác';
            if (fieldName == colPhieuNganhVTGhiRoC3) {
              if (ghiRoItem.c_1 != null && ghiRoItem.c_1 == 1) {
                if (inputValue == null ||
                    inputValue == "null" ||
                    inputValue == "" ||
                    validateEqual0InputValue(inputValue)) {
                  return '$tenChiTieu có tải trọng phải lớn hơn 0';
                }
              }
            }
          }
        }
      }
      if (fieldName == 'C_GhiRo') {
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập giá trị.';
          }
          if (inputValue != null && inputValue.length < 5) {
            return 'Ghi rõ quá ngắn.';
          }
        }
      }
    }
    if (chiTieuDong!.maSo == "15") {
      if (chiTieuCot!.maChiTieu == "2") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }
            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
        }
      }
      if (chiTieuCot!.maChiTieu == "3") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 9999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }

            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
          if (ghiRoItem != null) {
            var tenChiTieu = 'Xe ô tô khác';
            if (fieldName == colPhieuNganhVTGhiRoC3) {
              if (ghiRoItem.c_1 != null && ghiRoItem.c_1 == 1) {
                if (inputValue == null ||
                    inputValue == "null" ||
                    inputValue == "" ||
                    validateEqual0InputValue(inputValue)) {
                  return '$tenChiTieu có tải trọng phải lớn hơn 0';
                }
              }
            }
          }
        }
      }
      if (fieldName == 'C_GhiRo') {
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập giá trị.';
          }
          if (inputValue != null && inputValue.length < 5) {
            return 'Ghi rõ quá ngắn.';
          }
        }
      }
    }
    if (chiTieuDong!.maSo == "18") {
      if (chiTieuCot!.maChiTieu == "2") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }
            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
        }
      }
      if (chiTieuCot!.maChiTieu == "3") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 9999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }

            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
          if (ghiRoItem != null) {
            var tenChiTieu = 'Ô tô tải khác';
            if (fieldName == colPhieuNganhVTGhiRoC3) {
              if (ghiRoItem.c_1 != null && ghiRoItem.c_1 == 1) {
                if (inputValue == null ||
                    inputValue == "null" ||
                    inputValue == "" ||
                    validateEqual0InputValue(inputValue)) {
                  return '$tenChiTieu có tải trọng phải lớn hơn 0';
                }
              }
            }
          }
        }
      }
      if (fieldName == 'C_GhiRo') {
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập giá trị.';
          }
          if (inputValue != null && inputValue.length < 5) {
            return 'Ghi rõ quá ngắn.';
          }
        }
      }
    }
    if (chiTieuDong!.maSo == "17") {
      if (chiTieuCot!.maChiTieu == "2") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }
            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
        }
      }
      if (chiTieuCot!.maChiTieu == "3") {
        num minVal = chiTieuCot.giaTriNN ?? 1;
        num maxVal = chiTieuCot.giaTriLN ?? 9999;
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (fName2 == fieldName) {
          if (a1_x_1Value.toString() == '1') {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị.';
            }

            inputValue = inputValue!.replaceAll(' ', '');
            num intputVal = inputValue != null
                ? AppUtils.convertStringToDouble(inputValue)
                : 0;
            if (intputVal < minVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            } else if (intputVal > maxVal) {
              return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
            }
          }
          if (ghiRoItem != null) {
            var tenChiTieu = 'Phương tiện chở hàng khác';
            if (fieldName == colPhieuNganhVTGhiRoC3) {
              if (ghiRoItem.c_1 != null && ghiRoItem.c_1 == 1) {
                if (inputValue == null ||
                    inputValue == "null" ||
                    inputValue == "" ||
                    validateEqual0InputValue(inputValue)) {
                  return '$tenChiTieu có tải trọng phải lớn hơn 0';
                }
              }
            }
          }
        }
      }
      if (fieldName == 'C_GhiRo') {
        var fName1 = 'C_1';
        var fName2 = 'C_${chiTieuCot!.maChiTieu}';
        var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong!.maSo}';
        var a1_x_1Value = getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo, fName1, ghiRoItem!.maCauHoi!, ghiRoItem.sTT,
            id: ghiRoItem.id);
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập giá trị.';
          }
          if (inputValue != null && inputValue.length < 5) {
            return 'Ghi rõ quá ngắn.';
          }
        }
      }
    }
    return null;
  }

  onValidateInputGhiRo(TablePhieuNganhVTGhiRo ghiRoItem) {
    if (ghiRoItem == null) {
      return null;
    }
    String maso = ghiRoItem.maCauHoi!.split('_').last;
    var a1_x_1Value = ghiRoItem.c_1;

    if (maso == "13" || maso == "15") {
      String msg = 'Câu 1 mã số $maso';
      if (a1_x_1Value == 1) {
        if (ghiRoItem.c_2 == null) {
          return '$msg Số lượng xe (Xe/tàu): Vui lòng nhập giá trị.';
        } else {
          num minVal = 1;
          num maxVal = 999;
          num intputVal = ghiRoItem.c_2 ?? 0;
          if (intputVal < minVal) {
            return '$msg Số lượng xe (Xe/tàu): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          } else if (intputVal > maxVal) {
            return '$msg Số lượng xe (Xe/tàu): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          }
        }
        if (ghiRoItem.c_3 == null) {
          return '$msg TẢI TRỌNG (Số chỗ): Vui lòng nhập giá trị.';
        } else {
          num minVal = 1;
          num maxVal = 9999;
          num intputVal = ghiRoItem.c_2 ?? 0;
          if (intputVal < minVal) {
            return '$msg TẢI TRỌNG (Số chỗ): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          } else if (intputVal > maxVal) {
            return '$msg TẢI TRỌNG (Số chỗ): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          }
        }
        if (validateEmptyString(ghiRoItem.cGhiRo)) {
          return '$msg Ghi rõ: Vui lòng nhập giá trị.';
        }
        if (ghiRoItem.cGhiRo != null && ghiRoItem.cGhiRo!.length < 5) {
          return '$msg Ghi rõ: Ghi rõ quá ngắn.';
        }
      } else if (a1_x_1Value == 2) {
        return null;
      } else {
        return '$msg : Vui lòng nhập giá trị.';
      }
    }
    if (maso == "17" || maso == "18") {
      String msg = 'Câu 7 mã số $maso';
      if (a1_x_1Value == 1) {
        if (ghiRoItem.c_2 == null) {
          return '$msg Số lượng xe (Xe/tàu): Vui lòng nhập giá trị.';
        } else {
          num minVal = 1;
          num maxVal = 999;
          num intputVal = ghiRoItem.c_2 ?? 0;
          if (intputVal < minVal) {
            return '$msg Số lượng xe (Xe/tàu): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          } else if (intputVal > maxVal) {
            return '$msg Số lượng xe (Xe/tàu): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          }
        }
        if (ghiRoItem.c_3 == null) {
          return '$msg TẢI TRỌNG (Số chỗ): Vui lòng nhập giá trị.';
        } else {
          num minVal = 1;
          num maxVal = 9999;
          num intputVal = ghiRoItem.c_2 ?? 0;
          if (intputVal < minVal) {
            return '$msg TẢI TRỌNG (Tấn): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          } else if (intputVal > maxVal) {
            return '$msg TẢI TRỌNG (Tấn): Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
          }
        }
        if (validateEmptyString(ghiRoItem.cGhiRo)) {
          return '$msg Ghi rõ: Vui lòng nhập giá trị.';
        }
        if (ghiRoItem.cGhiRo != null && ghiRoItem.cGhiRo!.length < 5) {
          return '$msg Ghi rõ: Ghi rõ quá ngắn.';
        }
      } else if (a1_x_1Value == 2) {
        return null;
      } else {
        return '$msg : Vui lòng nhập giá trị.';
      }
    }
    return null;
  }

  onValidateA7VTHH(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false, TablePhieuNganhVTGhiRo? ghiRoItem}) {
    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName = 'A7_${i.toString()}_1';
      if (fieldName == fName) {
        if (validateEmptyString(inputValue.toString())) {
          return 'Vui lòng nhập giá trị.';
        }
      }
    }
    var tblPhieu = getTableByTableName(question.bangDuLieu!, typing);
    if (tblPhieu == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    if (chiTieuCot!.maChiTieu == "2" &&
        chiTieuDong!.maSo != "17" &&
        chiTieuDong!.maSo != "18") {
      num minVal = chiTieuCot.giaTriNN ?? 1;
      num maxVal = chiTieuCot.giaTriLN ?? 999;
      var fName1 = 'A7_${chiTieuDong.maSo}_1';
      var fName2 = 'A7_${chiTieuDong.maSo}_2';
      var a1_x_1Value = tblPhieu[fName1];
      if (a1_x_1Value.toString() == '1') {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị.';
        }
        inputValue = inputValue!.replaceAll(' ', '');
        num intputVal =
            inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
        if (intputVal < minVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        } else if (intputVal > maxVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        }
      }
      return null;
    }

    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName1 = 'A7_${i.toString()}_1';
      var fName2 = 'A7_${i.toString()}_2';
      var a1_x_1Value = tblPhieu[fName1];
      if (fieldName == fName2) {
        if (a1_x_1Value.toString() == '1') {
          if (validateEmptyString(inputValue.toString())) {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
    }

    ///C7. 7.1 =Có hoặc C7.7.2=Có hoặc ...C7.1.16 có mã có & C6.1_điện=2  và C6.1_xăng=2 và C6.1_dầu diezel=2
    var tblPhieuMauTBData = getTableByTableName(tablePhieuMauTB, typing);
    var a6_1Dien = tblPhieuMauTBData[colPhieuMauTBA6_1_1_1];
    var a6_1Xang = tblPhieuMauTBData[colPhieuMauTBA6_1_3_1];
    var a6_1Diezel = tblPhieuMauTBData[colPhieuMauTBA6_1_5_1];
    List<String> vt = [];
    for (var i = 1; i <= 16; i++) {
      var fName1 = 'A7_${i.toString()}_1';
      var fName2 = 'A7_${i.toString()}_2';
      var a1_x_1Value = tblPhieu[fName1];
      if (a1_x_1Value.toString() == '1') {
        if (fieldName == fName2) {
          if (inputValue == null ||
              inputValue == "null" ||
              inputValue == "" ||
              validateEqual0InputValue(inputValue)) {
            if (a6_1Dien != null &&
                a6_1Dien == 2 &&
                a6_1Diezel != null &&
                a6_1Diezel == 2 &&
                a6_1Xang != null &&
                a6_1Xang == 2) {
              return 'Cơ sở vận tải có các loại xe tải (C8.7.1 đến C8.8.16>0) mà không xử dụng năng lượng Xăng, điện, Dầu diezel (C6.1_1=2, C6.1_3=2, C6.1_5=2)?';
            }
          }
        }
      }
    }

    return null;
  }

  onValidateA1LT(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false, TablePhieuNganhVTGhiRo? ghiRoItem}) {
    // for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
    //   var fName = 'A1_${i.toString()}_1';
    //   if (fieldName == fName) {
    //     if (validateEmptyString(inputValue.toString())) {
    //       return 'Vui lòng nhập giá trị.';
    //     }
    //   }
    // }
    //Câu 1 để trống;
    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName = 'A1_${i.toString()}_1';
      if (fieldName == fName) {
        if (validateEmptyString(inputValue.toString())) {
          return 'Vui lòng nhập giá trị.';
        }
      }
    }
    var tblPhieu = getTableByTableName(question.bangDuLieu!, typing);
    if (tblPhieu == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    if (chiTieuCot!.maChiTieu == "2") {
      var fName1 = 'A1_${chiTieuDong!.maSo}_1';
      var fName2 = 'A1_${chiTieuDong!.maSo}_2';
      var a1_x_1Value = tblPhieu[fName1];
      num minVal = chiTieuCot.giaTriNN ?? 1;
      num maxVal = chiTieuCot.giaTriLN ?? 999;
      if (a1_x_1Value == 1) {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị.';
        }

        inputValue = inputValue!.replaceAll(' ', '');
        num intputVal =
            inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
        if (intputVal < minVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        } else if (intputVal > maxVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        }
      } else if (a1_x_1Value == 2) {
        return null;
      } else {
        return 'Vui lòng nhập giá trị. Số lượng cơ sở của ${chiTieuDong!.tenChiTieu} phải lớn hơn 0';
      }
    }
    if (chiTieuCot.maChiTieu == "3" ||
        chiTieuCot.maChiTieu == "4" ||
        chiTieuCot.maChiTieu == "5" ||
        chiTieuCot.maChiTieu == "6") {
      var fName1 = 'A1_${chiTieuDong!.maSo}_1';

      var a1_x_1Value = tblPhieu[fName1];
      num minVal = chiTieuCot.giaTriNN ?? 1;
      num maxVal = chiTieuCot.giaTriLN ?? 999;
      if (a1_x_1Value == 1) {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị.';
        }
        num minVal = chiTieuCot.giaTriNN ?? 0;
        num maxVal = chiTieuCot.giaTriLN ?? 999;
       
        inputValue = inputValue!.replaceAll(' ', '');
        num intputVal =
            inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
        if (intputVal < minVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        } else if (intputVal > maxVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        }
      }
      else if (a1_x_1Value == 2) {
        return null;
      }
      else{
        return 'Vui lòng nhập giá trị.';
      }
    }

    // //Tích chọn có mà số lượng C2=0
    // for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
    //   var fName1 = 'A1_${i.toString()}_1';
    //   var fName2 = 'A1_${i.toString()}_2';
    //   var a1_x_1Value = tblPhieu[fName1];
    //   if (fieldName == fName2) {
    //     if (a1_x_1Value.toString() == '1') {
    //       if (validateEmptyString(inputValue.toString())) {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    // }
    //Tích chọn mã 1.5 mà không nhập thông tin ghi rõ;
    if (chiTieuDong!.maSo == '5') {
      var a1_5_1Value = tblPhieu[colPhieuNganhLTA1_5_1];
      if (a1_5_1Value != null && a1_5_1Value == 1) {
        var a1_5GhiRoValue = tblPhieu[colPhieuNganhLTA1_5_GhiRo];
        if (a1_5GhiRoValue == null || a1_5GhiRoValue == '') {
          return 'Chưa nhập thông tin loại khác';
        }
      }
    }

    //C4<C3;
    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName1 = 'A1_${i.toString()}_1';
      var fName3 = 'A1_${i.toString()}_3';
      var fName4 = 'A1_${i.toString()}_4';
      var a1_x_1Value = tblPhieu[fName1];
      if (fieldName == fName3) {
        if (a1_x_1Value.toString() == '1') {
          int a1_5_4Value = tblPhieu[fName4] != null
              ? AppUtils.convertStringToInt(tblPhieu[fName4])
              : 0;
          int a1_5_3Value = tblPhieu[fName3] != null
              ? AppUtils.convertStringToInt(tblPhieu[fName3])
              : 0;

          if (a1_5_4Value < a1_5_3Value) {
            return 'Số giường tại C4 là [SỐ GIƯỜNG] < Số phòng C3 là [SỐ PHÒNG] -> (Số giường không thể < số phòng)';
          }
        }
      }
    }

    //Tổng số lượng cơ sở=0
    int a1_5_2TotalValue = 0;
    for (var i = 1; i <= question.danhSachChiTieuIO!.length; i++) {
      var fName1 = 'A1_${i.toString()}_1';
      var fName2 = 'A1_${i.toString()}_2';
      var a1_x_1Value = tblPhieu[fName1];
      if (a1_x_1Value.toString() == '1') {
        int a1_5_4Value = tblPhieu[fName2] != null
            ? AppUtils.convertStringToInt(tblPhieu[fName2])
            : 0;
        a1_5_2TotalValue += a1_5_4Value;
      }
    }
    if (a1_5_2TotalValue == 0) {
    //  return 'Cơ sở hoạt động trong ngành lưu trú (mã ngành 55) mà không có cơ sở lưu trú nào tại C2=0?';
    }
    return null;
  }

  onValidateA6_1_MMau(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false, TablePhieuNganhVTGhiRo? ghiRoItem}) {
    if (chiTieuCot!.maChiTieu == "1" && chiTieuDong!.maSo == "1") {
      num minVal = 1;
      num maxVal = 999999999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
    }
    if (chiTieuCot!.maChiTieu == "1" && chiTieuDong!.maSo != "1") {
      num minVal = 1;
      num maxVal = 999999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
    }
    if (chiTieuCot!.maChiTieu == "2") {
      num minVal = 1;
      num maxVal = 999999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
    }
    var tblPhieu = getTableByTableName(question.bangDuLieu!, typing);
    if (tblPhieu == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    // List<String> fieldName2=[];
    // List<String> fieldName3=[];
    // if (dsChiTieuDongA6_1TB.isNotEmpty) {
    //   for (var ct in dsChiTieuDongA6_1TB) {
    //     var fName2 = 'A6_1_${ct.maSo!}_2';
    //     var fName3 = 'A6_1_${ct.maSo!}_3';
    //     // fieldName2.add(fName2);
    //     // fieldName3.add(fName3);
    //     var a6_1_x_2Value = tblPhieu[fName2];
    //     var a6_1_x_3Value = tblPhieu[fName3];
    //     if (fieldName == fName2 || fieldName == fName3) {
    //       if (validateEmptyString(inputValue.toString())) {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    // }
    var fName2 = 'A6_1_${chiTieuDong!.maSo!}_2';

    var fName3 = 'A6_1_${chiTieuDong!.maSo!}_3';
    double a6_1_x_2Value = tblPhieu[fName2] != null
        ? AppUtils.convertStringToDouble(tblPhieu[fName2])
        : 0;
    double a6_1_x_3Value = tblPhieu[fName3] != null
        ? AppUtils.convertStringToDouble(tblPhieu[fName3])
        : 0;
    if (fieldName == fName2) {
      if (a6_1_x_2Value != null &&
          a6_1_x_2Value > 0 &&
          validateEqual0InputValue(a6_1_x_3Value)) {
        var a6_1_x_2ValueText = toCurrencyString(a6_1_x_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Khối lượng tiêu thụ tại C1 là $a6_1_x_2ValueText > 0 mà giá trị tiêu thụ C2=0?';
      }
      if (a6_1_x_3Value != null &&
          a6_1_x_3Value > 0 &&
          validateEqual0InputValue(a6_1_x_2Value)) {
        var a6_1_x_3ValueText = toCurrencyString(a6_1_x_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Giá trị tiêu thụ bình quân tại Câu2 $a6_1_x_3ValueText > 0 mà Khối lượng tiêu thụ bình quân tại Câu 1 = 0?';
      }
    }
    //"1.1>1_điện
    if (fieldName == colPhieuMauTBA6_1_1_1_2) {
      double a6_1_x_1_2Value = tblPhieu[colPhieuMauTBA6_1_1_1_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_1_2])
          : 0;
      double a6_1_x_2Value = tblPhieu[colPhieuMauTBA6_1_1_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_2])
          : 0;
      if (a6_1_x_1_2Value != null &&
          a6_1_x_2Value != null &&
          a6_1_x_1_2Value > a6_1_x_2Value) {
        String a6_1_x_2ValueText = toCurrencyString(a6_1_x_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_x_1_2ValueText = toCurrencyString(
            a6_1_x_1_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Khối lượng tiêu dùng bình quân tháng chi tiết ($a6_1_x_1_2ValueText) không thế lớn hơn tổng số ($a6_1_x_2ValueText)?';
      }
    }
    if (fieldName == colPhieuMauTBA6_1_1_1_3) {
      double a6_1_1_1_3Value = tblPhieu[colPhieuMauTBA6_1_1_1_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_1_3])
          : 0;
      double a6_1_1_3Value = tblPhieu[colPhieuMauTBA6_1_1_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_3])
          : 0;
      if (a6_1_1_1_3Value != null &&
          a6_1_1_3Value != null &&
          a6_1_1_1_3Value > a6_1_1_3Value) {
        String a6_1_1_3ValueText = toCurrencyString(a6_1_1_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_1_1_3ValueText = toCurrencyString(
            a6_1_1_1_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Giá trị tiêu thụ bình quân tháng chi tiết ($a6_1_1_1_3ValueText) không thế lớn hơn tổng số ($a6_1_1_3ValueText)?';
      }
    }
    //1.2>1_điện
    if (fieldName == colPhieuMauTBA6_1_1_2_2) {
      double a6_1_x_2_2Value = tblPhieu[colPhieuMauTBA6_1_1_2_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_2_2])
          : 0;
      double a6_1_x_2Value = tblPhieu[colPhieuMauTBA6_1_1_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_2])
          : 0;
      if (a6_1_x_2_2Value != null &&
          a6_1_x_2Value != null &&
          a6_1_x_2_2Value > a6_1_x_2Value) {
        String a6_1_x_2ValueText = toCurrencyString(a6_1_x_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_x_2_2ValueText = toCurrencyString(
            a6_1_x_2_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Khối lượng tiêu dùng bình quân tháng chi tiết ($a6_1_x_2_2ValueText) không thế lớn hơn tổng số ($a6_1_x_2ValueText)?';
      }
    }
    if (fieldName == colPhieuMauTBA6_1_1_2_3) {
      double a6_1_1_2_3Value = tblPhieu[colPhieuMauTBA6_1_1_2_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_2_3])
          : 0;
      double a6_1_1_3Value = tblPhieu[colPhieuMauTBA6_1_1_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_1_3])
          : 0;
      if (a6_1_1_2_3Value != null &&
          a6_1_1_3Value != null &&
          a6_1_1_2_3Value > a6_1_1_3Value) {
        String a6_1_1_3ValueText = toCurrencyString(a6_1_1_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_1_2_3ValueText = toCurrencyString(
            a6_1_1_2_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Giá trị tiêu thụ bình quân tháng chi tiết ($a6_1_1_2_3ValueText) không thế lớn hơn tổng số ($a6_1_1_3ValueText)?';
      }
    }
    //6.1>6_dầu hỏa
    if (fieldName == colPhieuMauTBA6_1_6_1_2) {
      double a6_1_6_1_2Value = tblPhieu[colPhieuMauTBA6_1_6_1_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_6_1_2])
          : 0;
      double a6_1_6_2Value = tblPhieu[colPhieuMauTBA6_1_6_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_6_2])
          : 0;
      if (a6_1_6_1_2Value != null &&
          a6_1_6_2Value != null &&
          a6_1_6_1_2Value > a6_1_6_2Value) {
        String a6_1_6_2ValueText = toCurrencyString(a6_1_6_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_6_1_2ValueText = toCurrencyString(
            a6_1_6_1_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Khối lượng tiêu dùng bình quân tháng chi tiết ($a6_1_6_1_2ValueText) không thế lớn hơn tổng số ($a6_1_6_2ValueText)?';
      }
    }
    if (fieldName == colPhieuMauTBA6_1_6_1_3) {
      double a6_1_6_1_3Value = tblPhieu[colPhieuMauTBA6_1_6_1_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_6_1_3])
          : 0;
      double a6_1_6_3Value = tblPhieu[colPhieuMauTBA6_1_6_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_6_3])
          : 0;
      if (a6_1_6_1_3Value != null &&
          a6_1_6_3Value != null &&
          a6_1_6_1_3Value > a6_1_6_3Value) {
        String a6_1_6_3ValueText = toCurrencyString(a6_1_6_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_6_1_3ValueText = toCurrencyString(
            a6_1_6_1_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Giá trị tiêu thụ bình quân tháng  chi tiết ($a6_1_6_1_3ValueText) không thế lớn hơn tổng số ($a6_1_6_3ValueText)?';
      }
    }
    // 7.1>7_Dầu nhờn
    if (fieldName == colPhieuMauTBA6_1_7_1_2) {
      double a6_1_7_1_2Value = tblPhieu[colPhieuMauTBA6_1_7_1_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_7_1_2])
          : 0;
      double a6_1_7_2Value = tblPhieu[colPhieuMauTBA6_1_7_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_7_2])
          : 0;
      if (a6_1_7_1_2Value != null &&
          a6_1_7_2Value != null &&
          a6_1_7_1_2Value > a6_1_7_2Value) {
        String a6_1_7_2ValueText = toCurrencyString(a6_1_7_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_7_1_2ValueText = toCurrencyString(
            a6_1_7_1_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Khối lượng tiêu dùng bình quân tháng chi tiết ($a6_1_7_1_2ValueText) không thế lớn hơn tổng số ($a6_1_7_2ValueText)?';
      }
    }
    if (fieldName == colPhieuMauTBA6_1_7_1_3) {
      double a6_1_7_1_3Value = tblPhieu[colPhieuMauTBA6_1_7_1_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_7_1_3])
          : 0;
      double a6_1_7_3Value = tblPhieu[colPhieuMauTBA6_1_7_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_7_3])
          : 0;
      if (a6_1_7_1_3Value != null &&
          a6_1_7_3Value != null &&
          a6_1_7_1_3Value > a6_1_7_3Value) {
        String a6_1_7_3ValueText = toCurrencyString(a6_1_7_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_7_1_3ValueText = toCurrencyString(
            a6_1_7_1_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Giá trị tiêu thụ bình quân tháng  chi tiết ($a6_1_7_1_3ValueText) không thế lớn hơn tổng số ($a6_1_7_3ValueText)?';
      }
    }

    //trong đó>10_Khí sinh học
    if (fieldName == colPhieuMauTBA6_1_10_1_2) {
      double a6_1_10_1_2Value = tblPhieu[colPhieuMauTBA6_1_10_1_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_10_1_2])
          : 0;
      double a6_1_10_2Value = tblPhieu[colPhieuMauTBA6_1_10_2] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_10_2])
          : 0;
      if (a6_1_10_1_2Value != null &&
          a6_1_10_2Value != null &&
          a6_1_10_1_2Value > a6_1_10_2Value) {
        String a6_1_10_2ValueText = toCurrencyString(a6_1_10_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_10_1_2ValueText = toCurrencyString(
            a6_1_10_1_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Khối lượng tiêu dùng bình quân tháng chi tiết ($a6_1_10_1_2ValueText) không thế lớn hơn tổng số ($a6_1_10_2ValueText)?';
      }
    }
    if (fieldName == colPhieuMauTBA6_1_10_1_3) {
      double a6_1_10_1_3Value = tblPhieu[colPhieuMauTBA6_1_10_1_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_10_1_3])
          : 0;
      double a6_1_10_3Value = tblPhieu[colPhieuMauTBA6_1_10_3] != null
          ? AppUtils.convertStringToDouble(tblPhieu[colPhieuMauTBA6_1_10_3])
          : 0;
      if (a6_1_10_1_3Value != null &&
          a6_1_10_3Value != null &&
          a6_1_10_1_3Value > a6_1_10_3Value) {
        String a6_1_10_3ValueText = toCurrencyString(a6_1_10_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a6_1_10_1_3ValueText = toCurrencyString(
            a6_1_10_1_3Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Giá trị tiêu thụ bình quân tháng  chi tiết ($a6_1_10_1_3ValueText) không thế lớn hơn tổng số ($a6_1_10_3ValueText)?';
      }
    }
  }

  onValidateA8_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? fieldName, String? inputValue,
      {bool typing = false}) {
    // if (typing == false) {
    //   for (var i = 1; i <= 4; i++) {
    //     var fName = 'A8_1_1_${i.toString()}_1';
    //     if (fieldName == fName) {
    //       if (validateEmptyString(inputValue.toString())) {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //   }
    //   for (var i = 1; i <= 11; i++) {
    //     var fName = 'A8_1_${i.toString()}_1';
    //     if (fieldName == fName) {
    //       if (validateEmptyString(inputValue.toString())) {
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
    //         if (inputValue == null ||
    //             inputValue == "null" ||
    //             inputValue == "") {
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
    //       //   if (isCap1H_VT.value == true &&
    //       //       (isCap5VanTaiHanhKhach.value == true ||
    //       //           isCap5VanTaiHangHoa.value)) {
    //       //     return 'Vui lòng nhập giá trị.';
    //       //   }
    //       // } else if (fieldName == "A8_1_5_1_2") {
    //       //   if (isCap1H_VT.value == true &&
    //       //       (isCap5VanTaiHanhKhach.value == true ||
    //       //           isCap5VanTaiHangHoa.value)) {
    //       //     return 'Vui lòng nhập giá trị.';
    //       //   }
    //       // }
    //       if (a8_1_x_1Value.toString() == '1') {
    //         if (inputValue == null ||
    //             inputValue == "null" ||
    //             inputValue == "") {
    //           // if (fieldName == "A8_1_3_1_2") {
    //           //   if (isCap1H_VT.value == true &&
    //           //       (isCap5VanTaiHanhKhach.value == true ||
    //           //           isCap5VanTaiHangHoa.value)) {
    //           //     return 'Vui lòng nhập giá trị.';
    //           //   }
    //           // } else if (fieldName == "A8_1_5_1_2") {
    //           //   if (isCap1H_VT.value == true &&
    //           //       (isCap5VanTaiHanhKhach.value == true ||
    //           //           isCap5VanTaiHangHoa.value)) {
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
    //     if (validateEmptyString(inputValue.toString())) {
    //       if (isCap1H_VT.value == true &&
    //           (isCap5VanTaiHanhKhach.value == true ||
    //               isCap5VanTaiHangHoa.value)) {
    //         return 'Vui lòng nhập giá trị.';
    //       }
    //     }
    //     //}
    //   }
    //   if (fieldName == "A8_1_5_1_2") {
    //     var a8_1_3_1Value = tblPhieu['A8_1_5_1'];
    //     //if (a8_1_3_1Value.toString() == '1') {
    //     if (validateEmptyString(inputValue.toString())) {
    //       if (isCap1H_VT.value == true &&
    //           (isCap5VanTaiHanhKhach.value == true ||
    //               isCap5VanTaiHangHoa.value)) {
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

  getTableByTableName(String table, bool typing) {
    var tblPhieuCT;
    if (typing == false) {
      if (table == tablePhieuMauTB) {
        tblPhieuCT = tblPhieuMauTB.value.toJson();
      } else if (table == tablePhieuNganhVT) {
        tblPhieuCT = tblPhieuNganhVT.value.toJson();
      } else if (table == tablePhieuNganhLT) {
        tblPhieuCT = tblPhieuNganhLT.value.toJson();
      }
    } else {
      if (table == tablePhieuMauTB) {
        tblPhieuCT = answerTblPhieuMau;
      } else if (table == tablePhieuNganhVT) {
        tblPhieuCT = answerTblPhieuNganhVT;
      } else if (table == tablePhieuNganhLT) {
        tblPhieuCT = answerTblPhieuNganhLT;
      }
    }
    if (table == tablePhieuMauTBSanPham) {
      tblPhieuCT = tblPhieuMauTBSanPham.value.toList();
    } else if (table == tablePhieuNganhCN) {
      tblPhieuCT = tblPhieuNganhCN.value.toList();
    } else if (table == tablePhieuNganhTM) {
      tblPhieuCT = tblPhieuNganhTM.value.toJson();
    } else if (table == tablePhieuNganhTMSanPham) {
      tblPhieuCT = tblPhieuNganhTMSanPham.value.toList();
    }
    return tblPhieuCT;
  }

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
    } else if (table == tablePhieuNganhTM) {
      var res = getValueByFieldNameFromDB(table, fieldName);
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
    } else if (table == tablePhieuNganhVTGhiRo) {
      TablePhieuNganhVTGhiRo? tbl;
      if (id != null) {
        tbl = tblPhieuNganhVTGhiRos.where((x) => x.id == id).firstOrNull;
      } else if (stt != null) {
        tbl = tblPhieuNganhVTGhiRos.where((x) => x.sTT == stt).firstOrNull;
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

  ///maCauHoiMaSo: MaSo=13 or 15 or 17 or 18
  getValueVTGhiRoByFieldNameFromDB(
      String table, String fieldName, String maCauHoiMaSo, int? stt,
      {int? id}) {
    if (fieldName == null || fieldName == '') return null;
    if (table == tablePhieuNganhVTGhiRo) {
      TablePhieuNganhVTGhiRo? tbl;
      if (id != null) {
        tbl = tblPhieuNganhVTGhiRos.where((x) => x.id == id).firstOrNull;
      } else if (stt != null) {
        tbl = tblPhieuNganhVTGhiRos
            .where((x) => x.sTT == stt && x.maCauHoi == maCauHoiMaSo)
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
  String? onValidate(
      String table,
      String maCauHoi,
      String? fieldName,
      String? inputValue,
      minValue,
      maxValue,
      int loaiCauHoi,
      bool typing,
      int maPhieu) {
    var tblPhieuCT = getTableByTableName(table, typing);
    if (tblPhieuCT == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }

    if (maCauHoi == colPhieuMauTBA1_3_2 && maPhieu == AppDefine.maPhieuTB) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập Năm sinh.';
      }
      var nSinh = inputValue!.replaceAll(' ', '');
      //nam sinh
      if (nSinh.length != 4) {
        return 'Vui lòng nhập năm sinh 4 chũ số';
      }
      int namSinh = AppUtils.convertStringToInt(nSinh);
      if (namSinh < 1900 || namSinh > 2025) {
        return "Năm sinh phải >= 1900 và <= 2025";
      }
    }

    if (maCauHoi == colPhieuMauTBA1_5_1 && maPhieu == AppDefine.maPhieuTB) {
      var a1_5Value = tblPhieuCT[colPhieuMauTBA1_5];
      if (a1_5Value.toString() == '1') {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị Mã số thuế.';
        }
        if (inputValue!.length != 10 && inputValue.length != 12) {
          return 'Mã số thuế của cơ sở không thể khác 10 hoặc 12 chữa số được.';
        }
        return null;
      } else {
        return null;
      }
    }

    if ((maCauHoi == "A2_1" || maCauHoi == "A2_1_1") &&
        maPhieu == AppDefine.maPhieuTB) {
      var resValid = onValidateA2_1(table, maCauHoi, fieldName, inputValue,
          minValue, maxValue, loaiCauHoi, typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if ((maCauHoi == "A3_2" || maCauHoi == "A3_2_1") &&
        maPhieu == AppDefine.maPhieuTB) {
      var resValid = onValidateA3_2(table, maCauHoi, fieldName, inputValue,
          minValue, maxValue, loaiCauHoi, typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    }
    if (maCauHoi == "A4_1" && maPhieu == AppDefine.maPhieuTB) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      var a4_1 = AppUtils.convertStringToInt(inputValue.replaceAll(' ', ''));
      if (a4_1 > 12) {
        return 'Vui lòng nhập giá trị 1 - 12.';
      }
      if (a4_1 == 0) {
        return 'Kiểm tra lại số tháng hoạt động của cơ sở';
      }
    }
    if ((maCauHoi == "A4_2") && maPhieu == AppDefine.maPhieuTB) {
      var resValid = onValidateA4_2(table, maCauHoi, fieldName, inputValue,
          minValue, maxValue, loaiCauHoi, typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    } else if (maCauHoi == colPhieuMauTBA4_3 &&
        maPhieu == AppDefine.maPhieuTB) {
      var resValid = onValidateA4_3(table, maCauHoi, fieldName, inputValue,
          minValue, maxValue, loaiCauHoi, typing);
      if (resValid != null && resValid != '') {
        return resValid;
      }
      return null;
    } else if (maCauHoi == colPhieuMauTBA7_1 &&
        maPhieu == AppDefine.maPhieuTB) {
      if (inputValue != null && inputValue == '1') {
        var a6_1_1_1Dien = tblPhieuCT[colPhieuMauTBA6_1_1_1] != null
            ? tblPhieuCT[colPhieuMauTBA1_2].toString()
            : '';
        if (a6_1_1_1Dien == 2) {
          return 'Cơ sở có sử dụng internet cho hoạt động SXKD (C7.1 = 1) mà Không sử dụng năng lượng là điện (C6.1_1. Điện = 2. Không?)';
        }
      }
    } else if (maCauHoi == colPhieuMauTBA7_2 &&
        maPhieu == AppDefine.maPhieuTB) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
    } else if (maCauHoi == colPhieuMauTBA7_3 &&
        maPhieu == AppDefine.maPhieuTB) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      num minVal = 1;
      num maxVal = 100;

      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
      var a7_3Value = tblPhieuCT[colPhieuMauTBA7_3] != null
          ? AppUtils.convertStringToDouble(
              tblPhieuCT[colPhieuMauTBA7_3].toString())
          : null;
      if (a7_3Value != null && a7_3Value > 0) {
        var a4TValue = tblPhieuCT[colPhieuMauTBA4T] != null
            ? AppUtils.convertStringToDouble(
                tblPhieuCT[colPhieuMauTBA4T].toString())
            : null;
        if (a4TValue != null && validateEqual0InputValue(a4TValue)) {
          var a7_3ValueText = toCurrencyString(a7_3Value.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Tỷ trọng doanh thu qua internet ($a7_3ValueText) > 0% mà Doanh thu bình quân 1 tháng năm 2025 = 0';
        }
      }
    } else if (fieldName == colPhieuNganhVTA5 &&
        maPhieu == AppDefine.maPhieuVT) {
      //Cơ sở hoạt động trong ngành vận tải nhưng không có bất kỳ phương tiện vận tải nào (C1.2_Tổng số lượng xe=0)?
      var a5Value = tblPhieuCT[colPhieuNganhVTA5] ?? 0;
      if (a5Value != null && validateEqual0InputValue(a5Value)) {
        return 'Cơ sở hoạt động trong ngành vận tải nhưng không có bất kỳ phương tiện vận tải nào (C1.2_Tổng số lượng xe = 0)?';
      }
    } else if (fieldName == colPhieuNganhVTA11 &&
        maPhieu == AppDefine.maPhieuVT) {
      //C1.2_Tổng số lượng xe=0
      var a5Value = tblPhieuCT[colPhieuNganhVTA5] ?? 0;
      if (a5Value != null && validateEqual0InputValue(a5Value)) {
        return 'Cơ sở hoạt động trong ngành vận tải nhưng không có bất kỳ phương tiện vận tải nào (C1.2_Tổng số lượng xe = 0)?';
      }
    } else if (maCauHoi == "A1_2" && maPhieu == AppDefine.maPhieuTM) {
      //Tổng số tiền vốn tại C1>C5.2_Dthu tại Phiếu 7TB
      if (tongTienVonBoRaC1TM.value > tongDoanhThuSanPhamNganhTM.value) {
        String c1TMValue = toCurrencyString(
            tongTienVonBoRaC1TM.value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String tongDTA5_2Value = toCurrencyString(
            tongDoanhThuSanPhamNganhTM.value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Tổng số tiền vốn là [$c1TMValue] >Doanh thu (gồm vốn và lãi) tại C5.2=[$tongDTA5_2Value]';
      }
    } else if (maCauHoi == colPhieuNganhVTA1_M &&
        maPhieu == AppDefine.maPhieuVTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///- C5.2_Doanh thu sản phẩm từ ngành vận tải >0 và C1=0
      if (validateEqual0InputValue(inputValue.toString().replaceAll(' ', ''))) {
        if (doanhThuNganhVTHK.value > 0) {
          String doanhThuVTHKValue = toCurrencyString(
              doanhThuNganhVTHK.value.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Cơ sở có doanh thu vận tải là $doanhThuVTHKValue triệu đồng mà Số chuyến vận chuyển hành khách tại C1 = 0';
        }
      }
    } else if (maCauHoi == colPhieuNganhVTA2_M &&
        maPhieu == AppDefine.maPhieuVTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 9999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///- C1>0 và C2=0;
      if (validateEqual0InputValue(inputValue.toString())) {
        var a1MValue = tblPhieuCT[colPhieuNganhVTA1_M] != null
            ? AppUtils.convertStringToInt(
                tblPhieuCT[colPhieuNganhVTA1_M].toString())
            : 0;

        if (a1MValue > 0) {
          String a1MVal = toCurrencyString(a1MValue.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Số chuyến vận chuyển tại C1 > 0 ($a1MVal) mà số khách bình quân chuyến tại C2 = 0?';
        }
      }
    } else if (maCauHoi == colPhieuNganhVTA3_M &&
        maPhieu == AppDefine.maPhieuVTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 99999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///- C3=0 &C1>0
      if (validateEqual0InputValue(inputValue.toString().replaceAll(' ', ''))) {
        var a1MValue = tblPhieuCT[colPhieuNganhVTA1_M] != null
            ? AppUtils.convertStringToInt(
                tblPhieuCT[colPhieuNganhVTA1_M].toString())
            : 0;

        if (a1MValue > 0) {
          String a1MVal = toCurrencyString(a1MValue.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Số km bình quân 1 chuyến tại C3 = 0 mà số chuyến vận chuyển khách bình quân tại C1 > 0 ($a1MValue)';
        }
      }
    } else if (maCauHoi == colPhieuNganhVTA6_M &&
        maPhieu == AppDefine.maPhieuVTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
      if (validateEqual0InputValue(inputValue.toString().replaceAll(' ', ''))) {
        if (doanhThuNganhVTHH.value > 0) {
          String doanhThuVTHHValue = toCurrencyString(
              doanhThuNganhVTHH.value.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Cơ sở có doanh thu vận tải là $doanhThuVTHHValue triệu đồng mà Số chuyến vận chuyển hàng hóa tại C6 = 0';
        }
      }
    } else if (maCauHoi == colPhieuNganhVTA7_M &&
        maPhieu == AppDefine.maPhieuVTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///- C6>0 và C7=0;
      if (validateEqual0InputValue(inputValue.toString().replaceAll(' ', ''))) {
        var a6MValue = tblPhieuCT[colPhieuNganhVTA6_M] != null
            ? AppUtils.convertStringToInt(
                tblPhieuCT[colPhieuNganhVTA6_M].toString())
            : 0;

        if (a6MValue > 0) {
          String a6MVal = toCurrencyString(a6MValue.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Số chuyến vận chuyển tại C6>0 ($a6MVal) mà khối lượng hàng hóa bình quân 1 chuyến tại C7 = 0?';
        }
      }
    } else if (maCauHoi == colPhieuNganhVTA8_M &&
        maPhieu == AppDefine.maPhieuVTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 99999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///- C8=0 & C6>0
      if (validateEqual0InputValue(inputValue.toString().replaceAll(' ', ''))) {
        var a6MValue = tblPhieuCT[colPhieuNganhVTA6_M] != null
            ? AppUtils.convertStringToInt(
                tblPhieuCT[colPhieuNganhVTA6_M].toString())
            : 0;

        if (a6MValue > 0) {
          String a6MVal = toCurrencyString(a6MValue.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Số km bình quân 1 chuyến tại C3 = 0 mà số chuyến vận chuyển khách bình quân tại C6 > 0 ($a6MVal)';
        }
      }
    } else if (maCauHoi == colPhieuNganhLTA1_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 99999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
    } else if (maCauHoi == colPhieuNganhLTA1_1_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 99999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///C1.1> C1

      var a1MValue = tblPhieuCT[colPhieuNganhLTA1_M] != null
          ? AppUtils.convertStringToInt(
              tblPhieuCT[colPhieuNganhLTA1_M].toString())
          : 0;
      var a1_1MValue = inputValue != null
          ? AppUtils.convertStringToInt(
              inputValue.toString().replaceAll(' ', ''))
          : 0;

      if (a1_1MValue > a1MValue) {
        String a1_1MValueText = toCurrencyString(a1_1MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);
        String a1MValueText = toCurrencyString(a1MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);
        return 'Số lượt khách quốc tế ($a1_1MValueText) không thể lớn hơn (>) số lượt khách ngủ qua đêm của cơ sở ($a1MValueText)';
      }
    } else if (maCauHoi == colPhieuNganhLTA2_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 99999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
      //- C5.2_Doanh thu sản phẩm từ ngành vận tải >0 và C1+C2=0
      var a1MValue = tblPhieuCT[colPhieuNganhLTA1_M] != null
          ? AppUtils.convertStringToInt(
              tblPhieuCT[colPhieuNganhLTA1_M].toString())
          : 0;
      var a2MValue = inputValue != null
          ? AppUtils.convertStringToInt(
              inputValue.toString().replaceAll(' ', ''))
          : 0;
      var totalC1C2 = a1MValue + a2MValue;
      if (doanhThuNganhLT.value > 0 && totalC1C2 == 0) {
        String c1TMValue = toCurrencyString(
            tongTienVonBoRaC1TM.value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String tongDTA5_2Value = toCurrencyString(
            doanhThuNganhLT.value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Cơ sở có doanh thu ngành vận tải tại C5.5_TB=$tongDTA5_2Value >0 mà Không có lượt khách nào ngủ qua đêm + không ngủ qua đêm (C2+C1=0)';
      }
    } else if (maCauHoi == colPhieuNganhLTA2_1_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 99999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///C2.1> C2

      var a2MValue = tblPhieuCT[colPhieuNganhLTA2_M] != null
          ? AppUtils.convertStringToInt(
              tblPhieuCT[colPhieuNganhLTA2_M].toString())
          : 0;
      var a2_1MValue = inputValue != null
          ? AppUtils.convertStringToInt(inputValue.toString())
          : 0;

      if (a2_1MValue > a2MValue) {
        String a2_1MValueText = toCurrencyString(a2_1MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);
        String a2MValueText = toCurrencyString(a2MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);
        return 'Số lượt khách quốc tế không ngủ qua đêm ($a2_1MValueText) không thể lớn hơn (>) số lượt khách không ngủ qua đêm của cơ sở ($a2MValueText)';
      }
    } else if (maCauHoi == colPhieuNganhLTA4_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }

      ///Nếu C4 < C3

      var a3MValue = tblPhieuCT[colPhieuNganhLTA3_M] != null
          ? AppUtils.convertStringToDouble(
              tblPhieuCT[colPhieuNganhLTA3_M].toString())
          : 0;
      var a4MValue = inputValue != null
          ? AppUtils.convertStringToDouble(
              inputValue.toString().replaceAll(' ', ''))
          : 0;

      if (a4MValue < a3MValue) {
        String a4MValueText = toCurrencyString(a4MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        String a3MValueText = toCurrencyString(a3MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Số ngày sử dụng giường tại C4 không thể ($a4MValueText) < Số ngày sử dụng sử dụng phòng  tại C3 ($a3MValueText) (do ít nhất trong phòng có 1 giường được sử dụng trở lên)?';
      }
    } else if (maCauHoi == colPhieuNganhLTA5_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      num minVal = 0;
      num maxVal = 100;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }

      ///" Nếu C1>0 và C5=0; C5=100% và C2>0"

      var a1MValue = tblPhieuCT[colPhieuNganhLTA1_M] != null
          ? AppUtils.convertStringToInt(
              tblPhieuCT[colPhieuNganhLTA1_M].toString())
          : 0;
      var a2MValue = tblPhieuCT[colPhieuNganhLTA2_M] != null
          ? AppUtils.convertStringToInt(
              tblPhieuCT[colPhieuNganhLTA2_M].toString())
          : 0;
      var a5MValue = inputValue != null
          ? AppUtils.convertStringToDouble(
              inputValue.toString().replaceAll(' ', ''))
          : 0;

      if (a1MValue != null &&
          a1MValue > 0 &&
          a5MValue != null &&
          a5MValue == 0) {
        String a1MValueText = toCurrencyString(a1MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);

        return 'Cơ sở có số khách ngủ qua đêm ($a1MValueText) > 0 mà tổng số tiền phòng = 0';
      }
      if (a2MValue != null &&
          a2MValue > 0 &&
          a5MValue != null &&
          a5MValue == 100) {
        String a2MValueText = toCurrencyString(a2MValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);

        return 'Doanh thu khách ngủ qua đêm chiếm 100% (C5 =100) nhưng cơ sở lại có số lượt khách không ngủ qua đêm ($a2MValueText)?';
      }
    } else if (maCauHoi == colPhieuNganhLTA6_M &&
        maPhieu == AppDefine.maPhieuLTMau) {
      num minVal = minValue ?? 1;
      num maxVal = maxValue ?? 9999;
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
    }
  }

  String? onValidateA2_1(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    inputValue = inputValue!.replaceAll(' ', '');

    var tblPhieuCT = getTableByTableName(table, typing);
    if (tblPhieuCT == null) {
      return 'khonglay_duoc_dulieu_kiemtra'.tr;
    }
    num intputVal = inputValue != null
        ? AppUtils.convertStringToInt(inputValue.replaceAll(' ', ''))
        : 0;
    if (intputVal < minValue) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
    } else if (intputVal > maxValue) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
    }
    int a2_1Value = tblPhieuCT['A2_1'] != null
        ? AppUtils.convertStringToInt(tblPhieuCT['A2_1'].toString())
        : 0;
    int a2_1_1Value = tblPhieuCT['A2_1_1'] != null
        ? AppUtils.convertStringToInt(tblPhieuCT['A2_1_1'].toString())
        : 0;

    var a1_3_1Value = tblPhieuCT['A1_3_1'];

    if (fieldName == colPhieuMauTBA2_1) {
      if (a2_1Value == 0) {
        return 'Lao động của cơ sở phải lớn hơn 0';
      }
      if (a2_1Value == 1 && a1_3_1Value == 1 && a2_1_1Value > 0) {
        return 'Cơ sở có 1 lao động là nam (là người chủ cơ sở) mà C2.1.1_Nữ >0';
      }
      if (a2_1Value == 1 && a1_3_1Value == 2 && a2_1_1Value == 0) {
        return 'Cơ sở có 1 lao động là nữ (là chủ cơ sở) mà C2.1.1_Nữ =0;';
      }
    } else if (fieldName == colPhieuMauTBA2_1_1) {
      if (a2_1Value < a2_1_1Value) {
        return 'Câu 2.1.1 Số lao động nữ lớn hơn tổng số lao động Câu 2.1';
      }
    }
    return null;
  }

  String? onValidateA2_2(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? inputValue,
      {bool typing = true, String? fieldName}) {
    // if (question.maCauHoi == "A2_2") {
    //   if (validateEmptyString(inputValue.toString())) {
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
      ChiTieuDongModel? chiTieuDong, String? inputValue,
      {bool typing = true, String? fieldName}) {
    // if (question.maCauHoi == "A2_3") {
    //   if (validateEmptyString(inputValue.toString())) {
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

  String? onValidateA3_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? inputValue,
      {bool typing = true, String? fieldName}) {
    if (question.maCauHoi == "A3_1") {
      num minValue = chiTieuCot!.giaTriNN ?? 0;
      num maxValue = chiTieuCot.giaTriLN ?? 999999;

      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal = inputValue != null
          ? AppUtils.convertStringToDouble(inputValue.replaceAll(' ', ''))
          : 0;
      if (intputVal < minValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      } else if (intputVal > maxValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      }
      var tblPhieuCT = getTableByTableName(question.bangDuLieu!, typing);
      if (tblPhieuCT == null) {
        return 'khonglay_duoc_dulieu_kiemtra'.tr;
      }

      double a3_2_x_1Value = tblPhieuCT['A3_1_${chiTieuDong!.maSo}_1'] != null
          ? AppUtils.convertStringToDouble(
              tblPhieuCT['A3_1_${chiTieuDong!.maSo}_1'])
          : 0;
      double a3_2_x_2Value = tblPhieuCT['A3_1_${chiTieuDong!.maSo}_2'] != null
          ? AppUtils.convertStringToDouble(
              tblPhieuCT['A3_1_${chiTieuDong!.maSo}_2'])
          : 0;
      double a3_1TValue = tblPhieuCT[colPhieuMauTBA3_1T] != null
          ? AppUtils.convertStringToDouble(tblPhieuCT[colPhieuMauTBA3_1T])
          : 0;
      var a1_2TValue = tblPhieuCT[colPhieuMauTBA1_2];
      if (chiTieuCot!.maChiTieu == '1') {
        if (a3_2_x_1Value > 0 && a3_2_x_1Value < 30.0) {
          return 'TSCĐ có giá trị tối thiểu 30 triệu đồng mà Giá trị TSCĐ = $a3_2_x_1Value triệu?;';
        }
      }
      // if (chiTieuCot!.maChiTieu == '2') {
      //   if (a3_2_x_2Value > 0 && a3_2_x_2Value < 9.0) {
      //     return 'b. Trong đó: Giá trị mua/xây dựng mới từ trong năm 2024 phải >= 9';
      //   }
      // }
      if (a3_2_x_1Value < a3_2_x_2Value) {
        return 'b. Trong đó: Giá trị mua/xây dựng mới từ trong năm 2025 ($a3_2_x_2Value) > a. Tổng số giá trị TSCĐ theo giá mua phải ($a3_2_x_1Value)';
      }
      if (a1_2TValue == 2 && a3_1TValue == 0) {
        return 'Cơ sở kinh doanh thuộc sở hữu chủ cơ sở (C1.2=2) mà Tài sản cố định cơ sở =0 (C3.1.1. Nhà xưởng, cửa hàng=0)';
      }
      return null;
    }
    return null;
  }

  String? onValidateA3_2(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    if (maCauHoi == "A3_2" || maCauHoi == "A3_2_1") {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 999999;

      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
      var tblPhieuCT = getTableByTableName(table, typing);
      if (tblPhieuCT == null) {
        return 'khonglay_duoc_dulieu_kiemtra'.tr;
      }

      // double a3_2Value = tblPhieuCT[colPhieuMauTBA3_2] != null
      //     ? AppUtils.convertStringToDouble(tblPhieuCT[colPhieuMauTBA3_2])
      //     : 0;
      double a3_2_1Value = tblPhieuCT[colPhieuMauTBA3_2_1] != null
          ? AppUtils.convertStringToDouble(tblPhieuCT[colPhieuMauTBA3_2_1])
          : 0;
      double a3TValue = tblPhieuCT[colPhieuMauTBA3T] != null
          ? AppUtils.convertStringToDouble(tblPhieuCT[colPhieuMauTBA3T])
          : 0;
      if (maCauHoi == "A3_2_1") {
        if (a3_2_1Value > a3TValue) {
          return 'Số tiền vay nợ lớn hơn tổng số tiền vốn';
        }
      }

      return null;
    }
    return null;
  }

  String? onValidateA4_2(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    if (maCauHoi == "A4_2") {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 999999;

      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      inputValue = inputValue!.replaceAll(' ', '');
      num intputVal =
          inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
      if (intputVal < minVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      } else if (intputVal > maxVal) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
      }
      var tblPhieuCT = getTableByTableName(table, typing);
      if (tblPhieuCT == null) {
        return 'khonglay_duoc_dulieu_kiemtra'.tr;
      }

      double a4_2_1Value = tblPhieuCT[colPhieuMauTBA3_2_1] != null
          ? AppUtils.convertStringToDouble(tblPhieuCT[colPhieuMauTBA3_2_1])
          : 0;

      if (a4_2_1Value == 0) {
        return 'Kiểm tra: Doanh thu của cơ sở phải lớn hơn 0';
      }

      return null;
    }
    return null;
  }

  String? onValidateA4_3(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    if (maCauHoi == "A4_3") {
      num minVal = minValue ?? 0;
      num maxVal = maxValue ?? 999999;

      var tblPhieuCT = getTableByTableName(table, typing);
      if (tblPhieuCT == null) {
        return 'khonglay_duoc_dulieu_kiemtra'.tr;
      }

      var a1_2Value = tblPhieuCT[colPhieuMauTBA1_2] != null
          ? tblPhieuCT[colPhieuMauTBA1_2].toString()
          : '';
      if (!validateEmptyString(a1_2Value) && a1_2Value == '1') {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị.';
        }
        inputValue = inputValue!.replaceAll(' ', '');
        num intputVal =
            inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
        if (intputVal < minVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        } else if (intputVal > maxVal) {
          return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
        }

        var a3_2Value = tblPhieuCT[colPhieuMauTBA3_2] != null
            ? AppUtils.convertStringToDouble(
                tblPhieuCT[colPhieuMauTBA3_2].toString())
            : null;
        var a4_3Value = tblPhieuCT[colPhieuMauTBA4_3] != null
            ? AppUtils.convertStringToDouble(
                tblPhieuCT[colPhieuMauTBA4_3].toString())
            : null;
        if (!validateEmptyString(a4_3Value.toString()) &&
            !validateEmptyString(a3_2Value.toString()) &&
            a4_3Value > a3_2Value) {
          var a4_3ValueText = toCurrencyString(a4_3Value.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          var a3_2ValueText = toCurrencyString(a3_2Value.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          return 'Số tiền thuê địa điểm SXKD tại C4.3 ($a4_3ValueText) > Số tiền vốn bỏ ra để SXKD ($a3_2ValueText)? (Số tiền thuê địa điểm phải được tính vào số tiền vốn)';
        }
      }
    }
    return null;
  }

  String? onValidateA7_2(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_2") {
    //   if (validateEmptyString(inputValue.toString())) {
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
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_2_1") {
    //   if (validateEmptyString(inputValue.toString())) {
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

  //String? onValidateA7_4(String table, String maCauHoi, String? fieldName,  String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
  // if (maCauHoi == "A7_4") {
  //   if (validateEmptyString(inputValue.toString())) {
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
  // return null;
  //}

  String? onValidateA7_4_1(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_4_1") {
    //   if (validateEmptyString(inputValue.toString())) {
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
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_5") {
    //   if (validateEmptyString(inputValue.toString())) {
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
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_6" || maCauHoi == "A7_6_1") {
    //   if (validateEmptyString(inputValue.toString())) {
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
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    // if (maCauHoi == "A7_7" || maCauHoi == "A7_7_1") {
    //   if (validateEmptyString(inputValue.toString())) {
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

  Future<List<QuestionFieldModel>> getValidationFields() async {
    List<QuestionFieldModel> result = [];
    var fieldNames = await getListFieldToValidateV2();
    //Lay
    var tbls = fieldNames.map((user) => user.bangDuLieu!).toList();
    var tables = tbls.toSet().toList();
    for (var tbl in tables) {
      var cols = await phieuProvider.getColumnNames(tbl);
      var fields = fieldNames.where((x) => cols.contains(x.tenTruong)).toList();
      if (fields.isNotEmpty) {
        var distinctFields = fields.toSet().toList();
        // result.addAll(distinctFields);
        for (var item in distinctFields) {
          if (result.isEmpty) {
            result.add(item);
          } else {
            var ttr =
                result.where((x) => x.tenTruong == item.tenTruong).firstOrNull;
            if (ttr == null) {
              result.add(item);
            }
          }
        }
      }
    }

    ///1. Lấy danh sách các bảng dữ liệu
    ///2. validationFields=Lặp fieldNames với các bảng dữ liệu đó để lấy ra các trường cần validate
    ///3.
    return result;
  }

  ///VALIDATE KHI NHẤN NÚT Tiếp tục V2
  ///1. Lấy danh sách các bảng dữ liệu
  ///2. validationFields=Lặp fieldNames với các bảng dữ liệu đó để lấy ra các trường cần validate
  Future<String> validateAllFormV2() async {
    String result = '';
    // var fieldNames = await getListFieldToValidateV2();
    var fieldNames = await getValidationFields();

    var tblTB = tblPhieuMauTB.value.toJson();
    var tblVT = tblPhieuNganhVT.value.toJson();
    var tblLT = tblPhieuNganhLT.value.toJson();
    var tblTM = tblPhieuNganhTM.value.toJson();

    for (var item in fieldNames) {
      if (currentScreenNo.value == item.manHinh) {
        if (item.tenTruong != null && item.tenTruong != '') {
          if ((item.bangDuLieu == tablePhieuMauTB &&
              item.maPhieu == AppDefine.maPhieuTB)) {
            if (tblTB.containsKey(item.tenTruong)) {
              var val = tblTB[item.tenTruong];
              // if (item.loaiCauHoi == 2) {
              //   val = val ?? AppUtils.convertStringToInt(val);
              // } else if (item.loaiCauHoi == 3) {
              //   val = val ?? AppUtils.convertStringToDouble(val);
              // }
              if (item.bangChiTieu == "2" ||
                  (item.bangChiTieu != null && item.bangChiTieu != '') ||
                  (item.bangChiTieu != null &&
                      item.bangChiTieu!.contains('CT_DM'))) {
                var validRes = onValidateInputChiTieuDongCot(item.question!,
                    item.chiTieuCot, item.chiTieuDong, val.toString(),
                    typing: false, fieldName: item.tenTruong);
                if (validRes != null && validRes != '') {
                  result = await generateMessageV2(item.tenHienThi, validRes);
                  break;
                }
              } else {
                var validRes = onValidate(
                    item.bangDuLieu!,
                    item.maCauHoi!,
                    item.tenTruong!,
                    val.toString(),
                    item.giaTriNN,
                    item.giaTriLN,
                    item.loaiCauHoi!,
                    false,
                    item.maPhieu!);
                if (validRes != null && validRes != '') {
                  result = await generateMessageV2(
                      '${item.tenHienThi} Mã số ${item.chiTieuDong!.maSo} - ${item.chiTieuDong!.tenChiTieu}',
                      validRes);
                  break;
                }
              }
            }
          } else if ((item.bangDuLieu == tablePhieuNganhVT &&
                  (item.maPhieu == AppDefine.maPhieuVT) ||
              (item.maPhieu == AppDefine.maPhieuVTMau))) {
            if (tblVT.containsKey(item.tenTruong)) {
              var val = tblVT[item.tenTruong];
              if (item.bangChiTieu == "2" ||
                  (item.bangChiTieu != null && item.bangChiTieu != '') ||
                  (item.bangChiTieu != null &&
                      item.bangChiTieu!.contains('CT_DM'))) {
                var validRes = onValidateInputChiTieuDongCot(item.question!,
                    item.chiTieuCot, item.chiTieuDong, val.toString(),
                    typing: false, fieldName: item.tenTruong);
                if (validRes != null && validRes != '') {
                  result = await generateMessageV2(
                      '${item.tenHienThi} Mã số ${item.chiTieuDong!.maSo} - ${item.chiTieuDong!.tenChiTieu}',
                      validRes);
                  break;
                }
              } else {
                var validRes = onValidate(
                    item.bangDuLieu!,
                    item.maCauHoi!,
                    item.tenTruong!,
                    val.toString(),
                    item.giaTriNN,
                    item.giaTriLN,
                    item.loaiCauHoi!,
                    false,
                    item.maPhieu!);
                if (validRes != null && validRes != '') {
                  result = await generateMessageV2(item.tenHienThi, validRes);
                  break;
                }
              }
            }
          } else if ((item.bangDuLieu == tablePhieuNganhLT &&
                  (item.maPhieu == AppDefine.maPhieuLT) ||
              (item.maPhieu == AppDefine.maPhieuLTMau))) {
            if (tblLT.containsKey(item.tenTruong)) {
              var val = tblLT[item.tenTruong];
              if (item.bangChiTieu == "2" ||
                  (item.bangChiTieu != null && item.bangChiTieu != '') ||
                  (item.bangChiTieu != null &&
                      item.bangChiTieu!.contains('CT_DM'))) {
                var validRes = onValidateInputChiTieuDongCot(item.question!,
                    item.chiTieuCot, item.chiTieuDong, val.toString(),
                    typing: false, fieldName: item.tenTruong);
                if (validRes != null && validRes != '') {
                  result = await generateMessageV2(
                      '${item.tenHienThi} Mã số ${item.chiTieuDong!.maSo} - ${item.chiTieuDong!.tenChiTieu}',
                      validRes);
                  break;
                }
              } else {
                var validRes = onValidate(
                    item.bangDuLieu!,
                    item.maCauHoi!,
                    item.tenTruong!,
                    val.toString(),
                    item.giaTriNN,
                    item.giaTriLN,
                    item.loaiCauHoi!,
                    false,
                    item.maPhieu!);
                if (validRes != null && validRes != '') {
                  result = await generateMessageV2(item.tenHienThi, validRes);
                  break;
                }
              }
            }
          }
        }
      }
    }
    var fieldNamesTableA5 = fieldNames
        .where((c) => c.bangDuLieu == tablePhieuMauTBSanPham)
        .toList();
    if (fieldNamesTableA5.isNotEmpty) {
      if (fieldNames.isNotEmpty) {
        if (tblPhieuMauTBSanPham.isNotEmpty) {
          //  var isReturn = false;
          for (var itemA5 in tblPhieuMauTBSanPham) {
            var tblA5 = itemA5.toJson();
            for (var fieldA5 in fieldNames) {
              if (tblA5.containsKey(fieldA5.tenTruong)) {
                var val = tblA5[fieldA5.tenTruong];
                int colId = int.parse(tblA5[columnId].toString());
                int sttSanPham =
                    int.parse(tblA5[colPhieuMauTBSanPhamSTTSanPham].toString());

                int idx = tblPhieuMauTBSanPham.indexOf(itemA5);
                idx = idx + 1;
                String maSPMoTa = '';
                if (!validateEmptyString(
                        tblA5[colPhieuMauTBSanPhamA5_1_2].toString()) &&
                    !validateEmptyString(
                        tblA5[colPhieuMauTBSanPhamA5_1_1].toString())) {
                  maSPMoTa =
                      '${tblA5[colPhieuMauTBSanPhamA5_1_2].toString()} - ${tblA5[colPhieuMauTBSanPhamA5_1_1].toString()}';
                }

                var validRes = onValidateInputA5(
                    fieldA5.maPhieu!,
                    fieldA5.bangDuLieu!,
                    fieldA5.maCauHoi!,
                    fieldA5.tenTruong,
                    colId,
                    val.toString(),
                    0,
                    0,
                    fieldA5.giaTriNN,
                    fieldA5.giaTriLN,
                    fieldA5.loaiCauHoi!,
                    sttSanPham,
                    false);

                if (validRes != null && validRes != '') {
                  String msg = 'STT = ${idx.toString()}';
                  if (!validateEmptyString(maSPMoTa)) {
                    msg = '$msg Mã sản phẩm: ${maSPMoTa}';
                  }

                  result = await generateMessageV2(
                      '${fieldA5.tenHienThi} $msg ', validRes);
                  // isReturn = true;
                  return result;
                  //    break;
                }
              }
              // if (isReturn) return result;
            }
          }
          var validRes = onValidateInputA5T(
              AppDefine.maPhieuTB, tablePhieuMauTB, colPhieuMauTBA5T, false);
          if (validRes != null && validRes != '') {
            return 'Câu 5T: $validRes';
          }
        }
      }
    }
    var fieldNameA1CNs =
        fieldNames.where((c) => c.bangDuLieu == tablePhieuNganhCN).toList();
    if (fieldNameA1CNs.isNotEmpty) {
      if (tblPhieuNganhCN.isNotEmpty) {
        //  var isReturn = false;
        for (var itemA1 in tblPhieuNganhCN) {
          var tblA1 = itemA1.toJson();
          for (var fieldA5 in fieldNames) {
            if (tblA1.containsKey(fieldA5.tenTruong)) {
              var val = tblA1[fieldA5.tenTruong];
              int colId = int.parse(tblA1[columnId].toString());
              int sttSanPham =
                  int.parse(tblA1[colPhieuNganhCNSTT_SanPham].toString());
              //  int idx = tblPhieuNganhCN.indexWhere((x) => x.sTT_SanPham ==sttSanPham && x.id==itemA1.id);
              int idx = tblPhieuNganhCN.indexOf(itemA1);
              idx = idx + 1;
              String maSPMoTa = '';
              if (!validateEmptyString(tblA1[colPhieuNganhCNA1_1].toString()) &&
                  !validateEmptyString(tblA1[colPhieuNganhCNA1_2].toString())) {
                maSPMoTa =
                    '${tblA1[colPhieuNganhCNA1_2].toString()} - ${tblA1[colPhieuNganhCNA1_1].toString()}';
              }

              var validRes = onValidateNganhCN(
                  fieldA5.maPhieu!,
                  fieldA5.bangDuLieu!,
                  fieldA5.maCauHoi!,
                  fieldA5.tenTruong,
                  colId,
                  val.toString(),
                  0,
                  0,
                  fieldA5.giaTriNN,
                  fieldA5.giaTriLN,
                  fieldA5.loaiCauHoi!,
                  sttSanPham,
                  false);

              if (validRes != null && validRes != '') {
                String msg = 'STT = ${idx.toString()}';
                if (!validateEmptyString(maSPMoTa)) {
                  msg = '$msg Mã sản phẩm: ${maSPMoTa}';
                }

                result = await generateMessageV2(
                    '${fieldA5.tenHienThi ?? fieldA5.tenNganCauHoi} $msg ',
                    validRes);
                // isReturn = true;
                return result;
                //    break;
              }
            }
            // if (isReturn) return result;
          }
        }
        // var validRes = onValidateInputA5T(
        //     AppDefine.maPhieuTB, tablePhieuMauTB, colPhieuMauTBA5T, false);
        // if (validRes != null && validRes != '') {
        //   return 'Câu 5T: $validRes';
        // }
      }
    }

    var vt = fieldNames
        .where((c) =>
            c.bangDuLieu == tablePhieuNganhVT &&
            (c.maCauHoi == "A1" || c.maCauHoi == "A7"))
        .firstOrNull;
    if (vt != null) {
      for (var itemA1 in tblPhieuNganhVTGhiRos) {
        var tblA1 = itemA1.toJson();

        int colId = int.parse(tblA1[columnId].toString());
        int stt = int.parse(tblA1[columnSTT].toString());

        String maso = itemA1.maCauHoi!.split('_').last;
        var validRes = onValidateInputGhiRo(itemA1);

        if (validRes != null && validRes != '') {
          return validRes;
        }
      }
    }

    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldToValidateV2() async {
    List<QuestionFieldModel> result = [];
    if (questions.isNotEmpty) {
      for (var item in questions) {
        QuestionFieldModel questionField = QuestionFieldModel(
            maPhieu: item.maPhieu,
            manHinh: item.manHinh,
            maCauHoi: item.maCauHoi,
            tenNganCauHoi: 'Câu ${item.maSo}',
            tenHienThi: item.tenHienThi,
            tenTruong: item.maCauHoi,
            loaiCauHoi: item.loaiCauHoi,
            giaTriLN: item.giaTriLN,
            giaTriNN: item.giaTriNN,
            bangChiTieu: item.bangChiTieu,
            bangDuLieu: item.bangDuLieu,
            question: item);
        if (item.loaiCauHoi != null && item.loaiCauHoi != 0) {
          if (((item.maCauHoi != "A9_M" && item.maCauHoi != "A10_M") &&
                  item.maPhieu == AppDefine.maPhieuVTMau) ||
              ((item.maCauHoi != "A5_M" &&
                      item.maCauHoi != "A5_1_M" &&
                      item.maCauHoi != "A6_M" &&
                      item.maCauHoi != "A6_1_M") &&
                  item.maPhieu == AppDefine.maPhieuLT)) {
            var fields = result
                .where((x) =>
                    x.tenTruong == questionField.tenTruong &&
                    x.maPhieu == questionField.maPhieu &&
                    x.maCauHoi == questionField.maCauHoi)
                .toList();
            if (fields.isEmpty) {
              result.add(questionField);
            }
          } else {
            result.add(questionField);
          }
        }
        if (item.maCauHoi == "A1_1" && item.maPhieu == AppDefine.maPhieuTB) {
          QuestionFieldModel qField = QuestionFieldModel(
              maPhieu: item.maPhieu,
              manHinh: item.manHinh,
              maCauHoi: item.maCauHoi,
              tenNganCauHoi: 'Câu ${item.maSo} Ghi rõ',
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

        if (item.maCauHoi == "A3_1" && item.maPhieu == AppDefine.maPhieuTB) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A5_1_1" ||
                item.maCauHoi == "A5_1_2" ||
                item.maCauHoi == "A5_2") &&
            item.maPhieu == AppDefine.maPhieuTB) {
          var cols = await phieuProvider.getColumnNames(tablePhieuMauTBSanPham);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: col,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              var fields = result
                  .where((x) =>
                      x.tenTruong == qfCol.tenTruong &&
                      x.maPhieu == qfCol.maPhieu &&
                      x.maCauHoi == qfCol.maCauHoi)
                  .toList();
              if (fields.isEmpty) {
                result.add(qfCol);
              }
            }
          }
        }
        if (item.maCauHoi == "A6_1" && item.maPhieu == AppDefine.maPhieuTB) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if (item.maCauHoi == "A7_4" && item.maPhieu == AppDefine.maPhieuTB) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A1_2" || item.maCauHoi == "A2_2") &&
            item.maPhieu == AppDefine.maPhieuCN) {
          var cols = await phieuProvider.getColumnNames(tablePhieuNganhCN);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: col,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              var fields = result
                  .where((x) =>
                      x.tenTruong == qfCol.tenTruong &&
                      x.maPhieu == qfCol.maPhieu &&
                      x.maCauHoi == qfCol.maCauHoi)
                  .toList();
              if (fields.isEmpty) {
                result.add(qfCol);
              }
            }
          }
        }
        if ((item.maCauHoi == "A1") && item.maPhieu == AppDefine.maPhieuVT) {
          //A5 A6 có ở trên; A1_M..A5M có ở trên
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2VanTai(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A7") && item.maPhieu == AppDefine.maPhieuVT) {
          //A11 A12 có ở trên; A6_M...A10_M có ở trên
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2VanTai(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if (item.maCauHoi == "A1" && item.maPhieu == AppDefine.maPhieuLT) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A1_2") && item.maPhieu == AppDefine.maPhieuTM) {
          var cols =
              await phieuProvider.getColumnNames(tablePhieuNganhTMSanPham);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: col,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              result.add(qfCol);
            }
          }
        }
        if ((item.maCauHoi == "A1T" ||
                item.maCauHoi == "A2" ||
                item.maCauHoi == "A3" ||
                item.maCauHoi == "A3T") &&
            item.maPhieu == AppDefine.maPhieuTM) {
          var cols =
              await phieuProvider.getColumnNames(tablePhieuNganhTMSanPham);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: col,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              result.add(qfCol);
            }
          }
        }

        if (item.danhSachCauHoiCon != null &&
            item.danhSachCauHoiCon!.isNotEmpty) {
          var res =
              await getListFieldToValidateCauHoiConV2(item.danhSachCauHoiCon!);
          if (res.isNotEmpty) {
            result.addAll(res);
          }
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldChiTieuDongCotV2(
      List<ChiTieuModel> danhSachChiTieuCot,
      List<ChiTieuDongModel> danhSachChiTieuDong,
      QuestionFieldModel questionModel) async {
    List<QuestionFieldModel> result = [];

    if (danhSachChiTieuDong.isNotEmpty) {
      for (var ctDong in danhSachChiTieuDong) {
        if ((ctDong.maPhieu != AppDefine.maPhieuVT)) {
          var ctCots = danhSachChiTieuCot
              .where((x) =>
                  x.maPhieu == ctDong.maPhieu &&
                  x.maCauHoi == ctDong.maCauHoi &&
                  (x.loaiChiTieu.toString() ==
                      AppDefine
                          .loaiChiTieu_1)) //loaiChiTieu=1 nhập giá trị; loaiChiTieu=2: Tự động tính
              .toList();

          if (ctCots.isNotEmpty) {
            for (var ctCot in ctCots) {
              String fName =
                  '${ctDong.maCauHoi}_${ctDong.maSo}_${ctCot.maChiTieu}';
              if (ctCot.maCauHoi == "A6_1_M") {
                fName = 'A6_1_${ctDong.maSo}_${ctCot.maChiTieu}';
              }
              String mucCauHoi =
                  '${questionModel.tenNganCauHoi} Mã số ${ctDong.maSo}';
              if (ctDong.maSo == '0') {
                mucCauHoi = '${questionModel.tenNganCauHoi}';
              }
              QuestionFieldModel qCtField = QuestionFieldModel(
                  maPhieu: questionModel.maPhieu,
                  manHinh: questionModel.manHinh,
                  maCauHoi: ctDong.maCauHoi,
                  tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
                  mucCauHoi: mucCauHoi,
                  tenHienThi: questionModel.tenHienThi,
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
            }
          }
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldToValidateCauHoiConV2(
      List<QuestionCommonModel> questionsCon) async {
    List<QuestionFieldModel> result = [];
    if (questionsCon.isNotEmpty) {
      for (var item in questionsCon) {
        QuestionFieldModel questionField = QuestionFieldModel(
            maPhieu: item.maPhieu,
            manHinh: item.manHinh,
            maCauHoi: item.maCauHoi,
            tenNganCauHoi: 'Câu ${item.maSo}',
            mucCauHoi: 'Câu ${item.maSo}',
            tenTruong: item.maCauHoi,
            tenHienThi: item.tenHienThi,
            loaiCauHoi: item.loaiCauHoi,
            giaTriLN: item.giaTriLN,
            giaTriNN: item.giaTriNN,
            bangChiTieu: item.bangChiTieu,
            bangDuLieu: item.bangDuLieu,
            tenTruongKhoa: '',
            question: item);
        if (item.loaiCauHoi != null && item.loaiCauHoi != 0) {
          if (((item.maCauHoi != "A9_M" && item.maCauHoi != "A10_M") &&
                  item.maPhieu == AppDefine.maPhieuVTMau) ||
              ((item.maCauHoi != "A5_M" &&
                      item.maCauHoi != "A5_1_M" &&
                      item.maCauHoi != "A6_M" &&
                      item.maCauHoi != "A6_1_M") &&
                  item.maPhieu == AppDefine.maPhieuLT)) {
            var fields = result
                .where((x) =>
                    x.tenTruong == questionField.tenTruong &&
                    x.maPhieu == questionField.maPhieu &&
                    x.maCauHoi == questionField.maCauHoi)
                .toList();
            if (fields.isEmpty) {
              result.add(questionField);
            }
          } else {
            result.add(questionField);
          }
        }
        if (item.maCauHoi == "A1_1" && item.maPhieu == AppDefine.maPhieuTB) {
          QuestionFieldModel qField = QuestionFieldModel(
              maPhieu: item.maPhieu,
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
        if (item.maCauHoi == "A3_1" && item.maPhieu == AppDefine.maPhieuTB) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A5_1_1" ||
                item.maCauHoi == "A5_1_2" ||
                item.maCauHoi == "A5_2") &&
            item.maPhieu == AppDefine.maPhieuTB) {
          var cols = await phieuProvider.getColumnNames(tablePhieuMauTBSanPham);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: item.maCauHoi,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              var fields = result
                  .where((x) =>
                      x.tenTruong == qfCol.tenTruong &&
                      x.maPhieu == qfCol.maPhieu &&
                      x.maCauHoi == qfCol.maCauHoi)
                  .toList();
              if (fields.isEmpty) {
                result.add(qfCol);
              }
            }
          }
        }
        if (item.maCauHoi == "A6_1" && item.maPhieu == AppDefine.maPhieuTB) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if (item.maCauHoi == "A7_4" && item.maPhieu == AppDefine.maPhieuTB) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A1_2" || item.maCauHoi == "A2_2") &&
            item.maPhieu == AppDefine.maPhieuCN) {
          var cols = await phieuProvider.getColumnNames(tablePhieuNganhCN);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              if (col == item.maCauHoi) {
                QuestionFieldModel qfCol = QuestionFieldModel(
                    maPhieu: item.maPhieu,
                    manHinh: item.manHinh,
                    maCauHoi: item.maCauHoi,
                    tenNganCauHoi: 'Câu ${item.maSo}',
                    tenHienThi: item.tenHienThi,
                    tenTruong: col,
                    loaiCauHoi: item.loaiCauHoi,
                    giaTriLN: item.giaTriLN,
                    giaTriNN: item.giaTriNN,
                    bangChiTieu: item.bangChiTieu,
                    bangDuLieu: item.bangDuLieu,
                    question: item);
                var fields = result
                    .where((x) =>
                        x.tenTruong == qfCol.tenTruong &&
                        x.maPhieu == qfCol.maPhieu &&
                        x.maCauHoi == qfCol.maCauHoi)
                    .toList();
                if (fields.isEmpty) {
                  result.add(qfCol);
                }
              }
            }
          }
        }
        if ((item.maCauHoi == "A1") && item.maPhieu == AppDefine.maPhieuVT) {
          //A5 A6 có ở trên; A1_M..A5M có ở trên
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2VanTai(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A7") && item.maPhieu == AppDefine.maPhieuVT) {
          //A11 A12 có ở trên; A6_M...A10_M có ở trên
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2VanTai(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if (item.maCauHoi == "A1" && item.maPhieu == AppDefine.maPhieuLT) {
          if (item.danhSachChiTieu != null && item.danhSachChiTieu != null) {
            var cauHoiChiTieu = await getListFieldChiTieuDongCotV2(
                item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
            result.addAll(cauHoiChiTieu);
          }
        }
        if ((item.maCauHoi == "A1_2") && item.maPhieu == AppDefine.maPhieuTM) {
          var cols =
              await phieuProvider.getColumnNames(tablePhieuNganhTMSanPham);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: col,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              result.add(qfCol);
            }
          }
        }
        if ((item.maCauHoi == "A1T" ||
                item.maCauHoi == "A2" ||
                item.maCauHoi == "A3" ||
                item.maCauHoi == "A3T") &&
            item.maPhieu == AppDefine.maPhieuTM) {
          var cols =
              await phieuProvider.getColumnNames(tablePhieuNganhTMSanPham);
          if (cols.isNotEmpty) {
            for (var col in cols) {
              QuestionFieldModel qfCol = QuestionFieldModel(
                  maPhieu: item.maPhieu,
                  manHinh: item.manHinh,
                  maCauHoi: item.maCauHoi,
                  tenNganCauHoi: 'Câu ${item.maSo}',
                  tenHienThi: item.tenHienThi,
                  tenTruong: col,
                  loaiCauHoi: item.loaiCauHoi,
                  giaTriLN: item.giaTriLN,
                  giaTriNN: item.giaTriNN,
                  bangChiTieu: item.bangChiTieu,
                  bangDuLieu: item.bangDuLieu,
                  question: item);
              result.add(qfCol);
            }
          }
        }

        if (item.danhSachCauHoiCon != null &&
            item.danhSachCauHoiCon!.isNotEmpty) {
          var res =
              await getListFieldToValidateCauHoiConV2(item.danhSachCauHoiCon!);
          result.addAll(res);
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldChiTieuDongCotV2VanTai(
      List<ChiTieuModel> danhSachChiTieuCot,
      List<ChiTieuDongModel> danhSachChiTieuDong,
      QuestionFieldModel questionModel) async {
    List<QuestionFieldModel> result = [];

    if (danhSachChiTieuDong.isNotEmpty) {
      for (var ctDong in danhSachChiTieuDong) {
        var ctCots = danhSachChiTieuCot
            .where((x) =>
                x.maPhieu == ctDong.maPhieu &&
                x.maCauHoi == ctDong.maCauHoi &&
                (x.loaiChiTieu.toString() == AppDefine.loaiChiTieu_1))
            .toList();

        if (ctCots.isNotEmpty) {
          for (var ctCot in ctCots) {
            String fName =
                '${ctDong.maCauHoi}_${ctDong.maSo}_${ctCot.maChiTieu}';
            if (ctCot.maCauHoi == "A6_1_M") {
              fName = 'A6_1_${ctDong.maSo}_${ctCot.maChiTieu}';
            }
            String mucCauHoi =
                '${questionModel.tenNganCauHoi} Mã số ${ctDong.maSo}';
            if (ctDong.maSo == '0') {
              mucCauHoi = '${questionModel.tenNganCauHoi}';
            }
            QuestionFieldModel qCtField = QuestionFieldModel(
                maPhieu: questionModel.maPhieu,
                manHinh: questionModel.manHinh,
                maCauHoi: ctDong.maCauHoi,
                tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
                mucCauHoi: mucCauHoi,
                tenHienThi: questionModel.tenHienThi,
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
          }
        }
      }
    }
    return result;
  }

  ///VALIDATE KHI NHẤN NÚT Tiếp tục V2
  //Future<String> validateAllFormV2() async {
  //   String result = '';

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
  //  return result;
  //}

  Future onKetThucPhongVan({int? lyDoKetThucPV}) async {
    final resultRoute = await Get.to(
      () => CompleteInterviewScreen(),
      fullscreenDialog: true,
    );

    if (resultRoute != null && resultRoute is CompletedResult) {
      final result = resultRoute.completeInfo;
      if (generalInformationController.tblBkCoSoSXKD.value.maTrangThaiDT != 9) {
        await onChangeCompleted(ThoiGianBD, startTime.toIso8601String());
        await onChangeCompleted(ThoiGianKT, DateTime.now().toIso8601String());
      }
      await bkCoSoSXKDProvider.updateTrangThai(currentIdCoSo!);
      AppPref.setQuestionNoStartTime = '';

      if (resultRoute.isEdited) {
        await Future.wait(completeInfo.keys
            .map((e) => updateAnswerCompletedToDb(e, completeInfo[e])));
      }
      if (lyDoKetThucPV != null &&
          lyDoKetThucPV == AppDefine.khongThuocDoiTuongDieuTra) {
        updateAnswerCompletedToDb(
            trangThaiCoSo, AppDefine.khongThuocDoiTuongDieuTra);
      } else {
        updateAnswerCompletedToDb(
            trangThaiCoSo, AppDefine.thuocDoiTuongDieuTra);
      }
      setLoading(false);
      Get.offAllNamed(AppRoutes.mainMenu);
    }
    // handleCompletedQuestion(
    //     tableThongTinNPV: completeInfo,
    //     onChangeName: (value) {
    //       onChangeCompleted(nguoiTraLoiBase, value);
    //     },
    //     onChangePhone: (value) {
    //       onChangeCompleted(soDienThoaiBase, value);
    //     },
    //     onChangeNameDTV: (value) {
    //       onChangeCompleted(hoTenDTVBase, value);
    //     },
    //     onChangePhoneDTV: (value) {
    //       onChangeCompleted(soDienThoaiDTVBase, value);
    //     },
    //     onUpdate: (Map updateValues) async {
    //       setLoading(true);
    //       await Future.wait(completeInfo.keys
    //           .map((e) => updateAnswerCompletedToDb(e, completeInfo[e])));
    //       await Future.wait(updateValues.keys
    //           .map((e) => updateAnswerCompletedToDb(e, updateValues[e])));
    //       if (glat == null && glng == null) {
    //         setLoading(false);
    //         var res = handleNoneLocation();
    //         return;
    //       }

    //       ///BEGIN::added by tuannb 06/082024: Cập nhật lại thời gian bắt đầu và kết thúc phỏng vấn phiếu
    //       if (generalInformationController.tblBkCoSoSXKD.value.maTrangThaiDT !=
    //           9) {
    //         await onChangeCompleted(ThoiGianBD, startTime.toIso8601String());
    //         await onChangeCompleted(
    //             ThoiGianKT, DateTime.now().toIso8601String());
    //       }
    //       bkCoSoSXKDProvider.updateTrangThai(currentIdCoSo!);
    //       AppPref.setQuestionNoStartTime = '';
    //       final sTimeLog = AppPref.getQuestionNoStartTime;
    //       log('AppPref.getQuestionNoStartTime $sTimeLog');

    //       ///END:: added
    //       ///
    //       setLoading(false);
    //       Get.offAllNamed(AppRoutes.mainMenu);
    //       //  onBackInterviewListDetail();
    //     });
  }

  confirmKetThucPhongVan(String table, String fieldName) {
    return Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        updateAnswerToDB(table, fieldName, 1);
        updateAnswerTblPhieuMau(fieldName, 1, table);
        Get.back();
      },
      onPressedPositive: () async {
        onKetThucPhongVan();
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: 'Bạn có chắc chắn kết thúc phỏng vấn?',
    ));
  }

  warningA9MDialog(String message) {
    return Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        Get.back();
        onKetThucPhongVan();
      },
      title: 'dialog_title_warning'.tr,
      content: message,
      isCancelButton: false,
    ));
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

  onOpenDialogSearch(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuMauTBSanPham product,
      int idValue,
      int stt,
      String motaSp,
      value) async {
    final result = await Get.dialog(DialogSearchVcpaTab(
      keyword: motaSp ?? '',
      initialValue: product.a5_1_2 ?? '',
      onChangeListViewItem: (item, productItem, selectedIndex) =>
          onChangeListViewItem(item, productItem, selectedIndex),
      productItem: product,
      capSo: 5,
    ));
  }

  onOpenDialogSearchCap8(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuNganhCN product,
      int idValue,
      int stt,
      String motaSp,
      value,
      TablePhieuNganhCNCap5 productCap5) async {
    final result = await Get.dialog(DialogSearchVcpaTab(
      keyword: motaSp ?? '',
      initialValue: product.a1_2 ?? '',
      onChangeListViewItem: (item, productItem, selectedIndex) =>
          onChangeListViewItem(item, productItem, selectedIndex),
      productItem: product,
      capSo: 8,
      maNganhCap5: productCap5.maNganhC5,
      moTaMaNganhCap5: productCap5.moTaSanPham,
    ));
  }

  // Initialization methods
  Future<void> initializeEvaluator() async {
    isInitializedEvaluator.value = false;
    log('Loading model and resources...');
    try {
      // final currentFilePath =
      //     '${AppPref.dataModelAIFilePath}/${AppPref.dataModelSuggestionsPath}';
      // final currentFile = File(currentFilePath);
      // var isCurrentFileExist = await currentFile.exists();
      // if (!isCurrentFileExist) {
      //   return snackBar('Thông báo',
      //       'Chưa có dữ liệu AI. Vui lòng thực hiện cập nhật dữ liệu AI',
      //       style: ToastSnackType.error);
      // }

      final startTime = DateTime.now();
      await evaluator.initialize();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      isInitializedEvaluator.value = true;
      log('Model ready! Initialization took ${duration.inMilliseconds}ms');
    } catch (e) {
      isInitializedEvaluator.value = false;
      log('Initialization failed: $e');
      snackBar('Thông báo', 'Khởi tạo dữ liệu AI bị lỗi ${e.toString()}',
          style: ToastSnackType.error);
    }
  }

  onChangeListViewItem(
      TableDmMotaSanpham item, dynamic spItem, int selectedIndex) async {
    debugPrint(
        "onChangeListViewItem linh vuc ${item?.maSanPham} - ${item?.tenSanPham}");
    log('ON onChangeListViewItem id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected');
    try {
      if (spItem is TablePhieuMauTBSanPham) {
        if (sanPhamIdSelected.value == spItem.id) {}

        String vcpaCapx = '';
        String donViTinh = '';
        // String maLV = item.maLV ?? '';
        int idVal = spItem.id!;
        int stt = spItem.sTTSanPham!;
        vcpaCapx = item.maSanPham!;
        donViTinh = item.donViTinh ?? '';

        var res = kiemTraMaVCPACap5(vcpaCapx);
        if (res) {
          if (selectedIndex < 0) {
            //Bỏ chọn
            await updateToDbSanPham(tablePhieuMauTBSanPham,
                colPhieuMauTBSanPhamA5_1_2, idVal, null);
            await updateToDbSanPham(
                tablePhieuMauTBSanPham, columnMaLV, idVal, null);
          } else {
            await updateToDbSanPham(tablePhieuMauTBSanPham,
                colPhieuMauTBSanPhamA5_1_2, idVal, vcpaCapx);
            // if (spItem.a5_1_1 == null || spItem.a5_1_1 == '') {
            //   if (item.tenSanPham != null && item.tenSanPham != '') {
            //     await updateToDbSanPham(tablePhieuMauTBSanPham,
            //         colPhieuMauTBSanPhamA5_1_1, idVal, item.tenSanPham);
            //   }
            // }
            // await updateToDbSanPham(
            //     tablePhieuMauTBSanPham, columnMaLV, idVal, maLV);
          }
          updateNganhAll();

          var hasVcpa5GL8610 = await hasA5_5G_L6810(vcpaCapx);
          Map<String, dynamic> ddSp = {
            ddSpId: idVal,
            ddSpMaSanPham: vcpaCapx,
            ddSpSttSanPham: stt,
            ddSpIsCap1GL: hasVcpa5GL8610
          };
          await updateAnswerDanhDauSanPhamByMap(stt, ddSp);
          var hasCap2PhanV = await hasCap2_56TM(vcpaCap2TM, vcpaCapx);
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
      } else if (spItem is TablePhieuNganhCN) {
        String vcpaCap8 = '';
        String donViTinh = '';
        //  String maLV = item.maLV ?? '';
        int idVal = spItem.id!;
        int stt = spItem.sTT_SanPham!;
        vcpaCap8 = item.maSanPham!;
        donViTinh = item.donViTinh ?? '';

        var res = kiemTraMaVCPACap8(vcpaCap8);
        if (res) {
          if (selectedIndex < 0) {
            //Bỏ chọn
            await updateToDbSanPham(
                tablePhieuNganhCN, colPhieuNganhCNA1_2, idVal, null);
            await updateToDbSanPham(
                tablePhieuNganhCN, colPhieuNganhCNA2_1, idVal, null);
            await updateToDbSanPham(tablePhieuNganhCN, columnMaLV, idVal, null);
          } else {
            await updateToDbSanPham(
                tablePhieuNganhCN, colPhieuNganhCNA1_2, idVal, vcpaCap8);
            await updateToDbSanPham(
                tablePhieuNganhCN, colPhieuNganhCNA2_1, idVal, donViTinh);
            // await updateToDbSanPham(tablePhieuNganhCN, columnMaLV, idVal, maLV);
          }
          snackBar('Thông báo', 'Đã cập nhật');
          log('ON onChangeListViewItem ĐÃ cập nhật mã VCPA cấp 8 vào bảng $tablePhieuNganhCN');
        } else {
          log('ON onChangeListViewItem chưa cập nhật mã VCPA cấp 8 vào bảng $tablePhieuNganhCN');
          snackBar(
              'Thông báo', 'Cập nhật không thành công. Mã cấp 8 không hợp lệ.');
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  onCloseSearch() async {
    update();
    log('ON onCloseSearch id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected $tblDmMoTaSanPhamSearch');
    Get.back();
    //
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
      //     TableDmMotaSanpham inputValue = value;
      //     if (inputValue != null) {
      //       vcpaCap5 = inputValue.maSanPham!;
      //       donViTinh = inputValue.donViTinh ?? '';
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
      //     var hasCap2PhanV = await hasCap2_56TM(  vcpaCap2TM,vcpaCap5);
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

  kiemTraMaVCPACap5(inputValue) {
    // if (inputValue is TableDmMotaSanpham) {
    //   if (inputValue != null) {
    //     if (inputValue.maSanPham != null && inputValue.maSanPham != '') {
    //       var res = tblDmMoTaSanPhamSearch
    //           .where((x) => x.maSanPham == inputValue.maSanPham!)
    //           .firstOrNull;
    //       if (res != null) {
    //         return res.maSanPham != '';
    //       }
    //     }
    //   }
    // } else if (inputValue is String) {
    //   var res = tblDmMoTaSanPhamSearch
    //       .where((x) => x.maSanPham == inputValue!)
    //       .firstOrNull;
    //   if (res != null) {
    //     return res.maSanPham != '';
    //   }
    // }

    // return false;
    return true;
  }

  kiemTraMaVCPACap8(inputValue) {
    return true;
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

  onChangeInputPhanV(int maPhieu, String table, String? maCauHoi,
      String? fieldName, int idValue, value) async {
    log('ON onChangeInputPhanV: id= $idValue $fieldName $value');

    try {
      if (table == tablePhieuMauTBSanPham) {
        await updateToDbSanPham(table, fieldName!, idValue, value);
        if (maCauHoi == "A5_2") {
          var total5TValue = await total5T();
          await updateAnswerToDB(
              tablePhieuMauTB, colPhieuMauTBA5T, total5TValue);
          var a5MValue =
              getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA5_M);
          if (a5MValue != null) {
            await tinhCapNhatA8_M_A9_M_A10_M(a5MValue);
          }
        }
      } else if (table == tablePhieuNganhCN && maPhieu == AppDefine.maPhieuCN) {
        await updateToDbSanPham(table, fieldName!, idValue, value);
        if (maCauHoi == "A1_2") {}
      } else if (table == tablePhieuNganhTMSanPham &&
          maPhieu == AppDefine.maPhieuTM) {
        await updateToDbSanPham(table, fieldName!, idValue, value);
        if (maCauHoi == "A1_2") {
          await tongDoanhThuSanPhamTM();
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

  ///Xoá sản phầm phần V
  ///- Kiểm tra ngành có liên quan tới mà ngành đang xoá.
  /// => Thông báo cụ thể mã ngành - tên ngành liên quan.
  /// => Xác nhận xoá của người dùng với nội dung:
  ///   + if (validResCN == "nganhCN") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có hoạt động công nghiệp. Dữ liệu mục hoạt động công nghiệp sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResCN!, warningMsg);
  // } else if (validResVT == "nganhVThh") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có hoạt động vận tải hàng hoá. Dữ liệu mục hoạt động vận tải hàng hoá sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResVT!, warningMsg);
  // } else if (validResVT == "nganhVThk") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có hoạt động vận tải hành khách. Dữ liệu mục hoạt động vận tải hành khách sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResVT!, warningMsg);
  // } else if (validResVT == "nganhVT") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có hoạt động vận tải. Dữ liệu mục hoạt động vận tải sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResVT!, warningMsg);
  // } else if (validResLT == "nganhLT") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có hoạt động kinh doanh dịch vụ lưu trú. Dữ liệu mục hoạt động kinh doanh dịch vụ lưu trú sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResLT!, warningMsg);
  // } else if (validResTM == "nganhTM56") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có thông tin về kết quả hoạt động ăn uống. Dữ liệu mục thông tin về kết quả hoạt động ăn uống sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResTM!, warningMsg);
  // } else if (validResTM == "nganhTMG6810") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có thông tin về hoạt động buôn bán; bán lẻ,.... Dữ liệu mục thông tin về hoạt động buôn bán; bán lẻ,... sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResTM!, warningMsg);
  // } else if (validResTM == "nganhTM") {
  //   String warningMsg =
  //       'Thông tin về nhóm sản phẩm không có thông tin về kết quả hoạt động ăn uống và oạt động buôn bán; bán lẻ,.... Dữ liệu mục thông tin về kết quả hoạt động ăn uống và oạt động buôn bán; bán lẻ,... sẽ bị xoá. Bạn có đồng ý?.';
  //   await showDialogValidNganh(validResTM!, warningMsg);
  // }
  onDeleteProduct(id, {String? maNganhCap5}) async {
    var checkRes = isDuplicateVCPAA5_1_2(maNganhCap5 ?? '');

    if (validateEmptyString(maNganhCap5) || checkRes) {
      Get.dialog(DialogBarrierWidget(
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          await executeConfirmDeleteProduct(id, '', '');

          Get.back();
        },
        title: 'dialog_title_warning'.tr,
        content: 'Bạn có chắc muốn xoá sản phẩm này?',
      ));
      return;
    }

    //Ngành CN
    var (nganh, messageContent) = await kiemTraNganhXoaCN(id, maNganhCap5!);

    if (nganh == 'CN' && messageContent != '') {
      Get.dialog(DialogBarrierWidget(
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          await executeConfirmDeleteProduct(id, nganh, maNganhCap5);
          Get.back();
        },
        color: errorColor,
        title: 'dialog_title_warning'.tr,
        content: messageContent,
        content2: 'Bạn có chắc muốn xoá sản phẩm này?',
        btnAcceptColor: errorColor,
      ));
    }
    //Ngành VT
    (nganh, messageContent) = await kiemTraNganhXoaCN(id, maNganhCap5!);
    if ((nganh == 'VT' || nganh == 'VTHK' || nganh == 'VTHH') &&
        messageContent != '') {
      Get.dialog(DialogBarrierWidget(
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          await executeConfirmDeleteProduct(id, nganh, maNganhCap5);
          Get.back();
        },
        color: errorColor,
        title: 'dialog_title_warning'.tr,
        content: messageContent,
        content2: 'Bạn có chắc muốn xoá sản phẩm này?',
        btnAcceptColor: errorColor,
      ));
    }
    //Ngành LT
    (nganh, messageContent) = await kiemTraNganhXoaLT(id, maNganhCap5!);
    if (nganh == 'LT' && messageContent != '') {
      Get.dialog(DialogBarrierWidget(
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          await executeConfirmDeleteProduct(id, nganh, maNganhCap5);
          Get.back();
        },
        color: errorColor,
        title: 'dialog_title_warning'.tr,
        content: messageContent,
        content2: 'Bạn có chắc muốn xoá sản phẩm này?',
        btnAcceptColor: errorColor,
      ));
    }
    //Ngành TM
    (nganh, messageContent) = await kiemTraNganhXoaTM(id, maNganhCap5!);
    if ((nganh == 'TM' || nganh == 'TMG8610' || nganh == 'TM56') &&
        messageContent != '') {
      Get.dialog(DialogBarrierWidget(
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          await executeConfirmDeleteProduct(id, nganh, maNganhCap5);
          Get.back();
        },
        color: errorColor,
        title: 'dialog_title_warning'.tr,
        content: messageContent,
        content2: 'Bạn có chắc muốn xoá sản phẩm này?',
        btnAcceptColor: errorColor,
      ));
    }
  }

  Future<(String, String)> kiemTraNganhXoaCN(int id, String maNganhCap5) async {
    ///
    String nganh = '';
    String messageContent = '';

    ///Ngành CN
    var isCap1BCDE = await hasA5_3BCDE(maNganhCap5);
    if (isCap1BCDE) {
      var map = await phieuNganhCNProvider.getByMaNganhC5(
          currentIdCoSo!, maNganhCap5);
      if (map.isNotEmpty) {
        nganh = 'CN';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động công nghiệp. Dữ liệu này sẽ bị xoá.';
      }
    }
    return (nganh, messageContent);
  }

  Future<(String, String)> kiemTraNganhXoaVT(int id, String maNganhCap5) async {
    ///
    String nganh = '';
    String messageContent = '';

    ///Ngành VT
    var hasVTHK = await hasCap5NganhVT(vcpaCap5VanTaiHanhKhach);
    var hasVTHH = await hasCap5NganhVT(vcpaCap5VanTaiHangHoa);
    if (hasVTHK && hasVTHH) {
      var hasDataTVHK = await hasMucVTHanhKhach();
      var hasDataTVHH = await hasMucVTHangHoa();
      if (hasDataTVHK && hasDataTVHH) {
        nganh = 'VT';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động vận tải hành khách và vận tải hàng hoá. Dữ liệu này sẽ bị xoá.';
      } else if (hasDataTVHK && !hasDataTVHH) {
        nganh = 'VT';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động vận tải hành khách. Dữ liệu này sẽ bị xoá.';
      } else if (!hasDataTVHK && hasDataTVHH) {
        nganh = 'VT';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động vận tải hàng hoá. Dữ liệu này sẽ bị xoá.';
      }
    } else if (hasVTHK && !hasVTHH) {
      var hasDataTVHK = await hasMucVTHanhKhach();
      if (hasDataTVHK) {
        nganh = 'VTHK';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động vận tải hành khách. Dữ liệu này sẽ bị xoá.';
      }
    } else if (!hasVTHK && hasVTHH) {
      var hasDataTVHK = await hasMucVTHanhKhach();
      if (hasDataTVHK) {
        nganh = 'VTHH';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động vận tải hàng hoá. Dữ liệu này sẽ bị xoá.';
      }
    }
    return (nganh, messageContent);
  }

  Future<(String, String)> kiemTraNganhXoaLT(int id, String maNganhCap5) async {
    ///
    String nganh = '';
    String messageContent = '';

    ///Ngành LT
    var hasLT55 = await dmMotaSanphamProvider.kiemTraMaNganhCap2ByMaSanPham5(
        '55', maNganhCap5);

    if (hasLT55) {
      var map = await phieuNganhLTProvider.selectByIdCoSo(currentIdCoSo!);
      if (map.isNotEmpty) {
        nganh = 'LT';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động kinh doanh dịch vụ lưu trú. Dữ liệu này sẽ bị xoá.';
      }
    }
    return (nganh, messageContent);
  }

  Future<(String, String)> kiemTraNganhXoaTM(int id, String maNganhCap5) async {
    ///
    String nganh = '';
    String messageContent = '';

    ///Ngành LT
    var hasG8610 = await hasA5_5G_L6810(maNganhCap5);
    var has56TM = await hasCap2_56TM('56', maNganhCap5);

    if (hasG8610 && has56TM) {
      var g8610 =
          await phieuNganhTMSanphamProvider.selectByIdCoSo(currentIdCoSo!);
      var map56 = await phieuNganhTMProvider.selectByIdCoSo(currentIdCoSo!);
      if (g8610.isNotEmpty || map56.isNotEmpty) {
        nganh = 'TM';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động bán buôn; bán lẻ...và hoạt động ăn uống. Dữ liệu này sẽ bị xoá.';
      }
    } else if (hasG8610 && !has56TM) {
      var g8610 =
          await phieuNganhTMSanphamProvider.selectByIdCoSo(currentIdCoSo!);
      if (g8610.isNotEmpty) {
        nganh = 'TMG8610';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động bán buôn; bánl lẻ... Dữ liệu này sẽ bị xoá.';
      }
    } else if (!hasG8610 && has56TM) {
      var map56 = await phieuNganhTMProvider.selectByIdCoSo(currentIdCoSo!);
      if (map56.isNotEmpty) {
        nganh = 'TM56';
        messageContent =
            'Sản phẩm này đã có dữ liệu ở phiếu hoạt động ăn uống. Dữ liệu này sẽ bị xoá.';
      }
    }
    return (nganh, messageContent);
  }

  executeConfirmDeleteProduct(id, String nganh, String maNganhCap5) async {
    await xacNhanLogicProvider.deleteByIdHoManHinh(
        currentIdCoSo!, currentScreenNo.value);

    await phieuMauTBSanPhamProvider.deleteById(id);

//
    if (!validateEmptyString(nganh) && !validateEmptyString(maNganhCap5)) {
      if (nganh == 'CN') {
        //Xoá record có mã ngành cấp 5 maNganhCap5 trong bảng CT_Phieu_NganhCN
        await phieuNganhCNProvider.deleteByCoSoIdMaNganhCap5(
            currentIdCoSo!, maNganhCap5);
      }
      if (nganh == 'VT') {
        //Vận tải hành khách và vận tải hàng hoá đều không có
        //Xoá record  trong bảng CT_Phieu_NganhVT và CT_Phieu_NganhVT_GhiRo;
        await phieuNganhVTProvider.deleteByCoSoId(currentIdCoSo!);
        await phieuNganhVTGhiRoProvider.deleteByCoSoId(currentIdCoSo!);
      }
      if (nganh == 'VTHK') {
        //Chỉ có vận tải hành khách;
        //Update các trường thuộc VTHK  trong bảng CT_Phieu_NganhVT và delete record có A1_13 và A1_15 CT_Phieu_NganhVT_GhiRo;
        await phieuNganhVTGhiRoProvider.deleteByCoSoIdMaCauHoi(
            currentIdCoSo!, 'A13;A15');
        if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
          await phieuNganhVTProvider.updateNullValues(
              currentIdCoSo!, fieldNamesPhan6HKTB);
        } else if (currentMaDoiTuongDT ==
            AppDefine.maDoiTuongDT_07Mau.toString()) {
          await phieuNganhVTProvider.updateNullValues(
              currentIdCoSo!, fieldNamesPhan6HKMau);
        }
      }
      if (nganh == 'VTHH') {
        //Chỉ có vận tải hàng hoá;
        //Update các trường thuộc VTHH  trong bảng CT_Phieu_NganhVT và delete record có A1_17 và A1_18 CT_Phieu_NganhVT_GhiRo;
        await phieuNganhVTGhiRoProvider.deleteByCoSoIdMaCauHoi(
            currentIdCoSo!, 'A17;A18');
        if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
          await phieuNganhVTProvider.updateNullValues(
              currentIdCoSo!, fieldNamesPhan6HHTB);
        } else if (currentMaDoiTuongDT ==
            AppDefine.maDoiTuongDT_07Mau.toString()) {
          await phieuNganhVTProvider.updateNullValues(
              currentIdCoSo!, fieldNamesPhan6HHMau);
        }
      }
      if (nganh == 'LT') {
        //Xoá record  trong bảng CT_Phieu_NganhLT
        await phieuNganhLTProvider.deleteByCoSoId(currentIdCoSo!);
      }
      if (nganh == 'TM') {
        //Xoá record  trong bảng CT_Phieu_NganhTM và CT_Phieu_NganhTM_SanPham
        await phieuNganhTMSanphamProvider.deleteByCoSoId(currentIdCoSo!);
        await phieuNganhTMProvider.deleteByCoSoId(currentIdCoSo!);
      }
      if (nganh == 'TM_G6810') {
        //Chỉ có thông về hoạt động bán buốn; bán lẻ sửa chữa ô tô mô tô xe máy ;
        //Cập nhật trường 1T = null trong bảng CT_Phieu_NganhTM và Xoá record  trong bảng CT_Phieu_NganhTM_SanPham
        await phieuNganhTMSanphamProvider.deleteByCoSoId(currentIdCoSo!);
        await phieuNganhTMProvider.updateValueByIdCoSo(
            colPhieuNganhTMA1T, null, currentIdCoSo!);
      }
      if (nganh == 'TM_56') {
        //Chỉ có thông tin về kết quả hoạt động ăn uống 56;
        //Cập nhật trường 1T = null trong bảng CT_Phieu_NganhTM và Xoá record  trong bảng CT_Phieu_NganhTM_SanPham
        await phieuNganhTMProvider.updateValueByIdCoSo(
            colPhieuNganhTMA1T, null, currentIdCoSo!);
        await phieuNganhTMProvider.updateNullValues(currentIdCoSo!,
            [colPhieuNganhTMA2, colPhieuNganhTMA3, colPhieuNganhTMA3T]);
      }
    }

    ///Tính lại  A5T: 5T. Tổng doanh thu của các sản phẩm năm 2025 (Tổng các câu A5.2*A4.1)
    ///Tính lại A8: Doanh thu khách ngủ qua đêm(= câu 5.2 của phiếu TB * câu 5: Doanh thu từ khách ngủ qua đêm chiếm bao nhiêu phần trăm trong tổng doanh thu?)
    ///Tính lại A9: Doanh thu khách không ngủ qua đêm (=câu 5.2 - câu 8: doanh thu khách ngủ qua đêm)
    ///Tính lại A10: Số ngày khách do cơ sở lưu trú phục vụ = A8/A6(Giá bình quân 1 đêm/khách là bao nhiêu?)
    /// (cũ A5_7 và A7_10A7_11A7_13 )
    ///
    var total5TValue = await total5T();
    await updateAnswerToDB(tablePhieuMauTB, colPhieuMauTBA5T, total5TValue);
    //TODO CẬP NHẬT LẠI CÁC NGÀNH LIÊN QUAN
    await updateNganhAll();
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

    await danhDauSanPhamCN();
    await danhDauSanPhamVT();
    await danhDauSanPhamLT();
    await danhDauSanPhamTM();
  }

  addNewRowProduct() async {
    await insertNewRecordSanPham();
    await getTablePhieuMauTBSanPham();
  }

  updateToDbSanPham(String table, String fieldName, idValue, value,
      {dynamic product}) async {
    if (table == tablePhieuMauTBSanPham) {
      var res = await phieuMauTBSanPhamProvider.isExistProductById(
          currentIdCoSo!, idValue);
      if (res) {
        await phieuMauTBSanPhamProvider.updateValueByIdCoso(
            fieldName, value, currentIdCoSo, idValue);
        if (fieldName == colPhieuMauTBSanPhamA5_1_2) {
          if (value == null) {
            await phieuMauTBSanPhamProvider.updateValueByIdCoso(
                colPhieuMauTBSanPhamMaNganhC5, null, currentIdCoSo, idValue);
          } else {
            if (value.toString().length >= 5) {
              var cap5 = value.toString().substring(0, 5);
              await phieuMauTBSanPhamProvider.updateValueByIdCoso(
                  colPhieuMauTBSanPhamMaNganhC5, cap5, currentIdCoSo, idValue);
            }
          }
        }
      }
      await getTablePhieuMauTBSanPham();
    } else if (table == tablePhieuNganhCN) {
      await phieuNganhCNProvider.updateValueByIdCoso(
          fieldName, value, currentIdCoSo, idValue);
      if (fieldName == colPhieuNganhCNA1_2) {}
      await getTablePhieuNganhCN();
    } else if (table == tablePhieuNganhTMSanPham) {
      await phieuNganhTMSanphamProvider.updateValueByIdCoso(
          fieldName, value, currentIdCoSo, idValue);
      await tinhTongTriGiaVonCau1TNganhTM();
    }
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
    } else if (table == tablePhieuNganhCN) {
      var tblTmp = tblPhieuNganhCN.where((x) => x.id == id).firstOrNull;
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
  Future<bool> hasA5_3BCDE(String maSanPham) async {
    // if (maSanPham == '') {
    //   return true;
    // }
    var result =
        await dmMotaSanphamProvider.kiemTraMaNganhCap1BCDEByMaVCPA(maSanPham);
    return result;
  }

  Future<bool> hasAllSanPhamBCDE() async {
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
  Future<bool> hasA5_5G_L6810(String maSanPham) async {
    // if (maSanPham == '') {
    //   return true;
    // }

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

  Future<bool> hasAll_5G_L6810() async {
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

  // hasCap1(String maQuiDinh, String maSanPham) async {
  //   return await dmNhomNganhVcpaProvider.kiemTraMaNganhCap1ByMaSanPham5(
  //       maQuiDinh, maSanPham);
  // }

  ///[MÃ SẢN PHẨM CẤP 2 LÀ 56] => HỎI CÂU 5.6 và 5.6.1
  ///VII. NĂNG LỰC PHỤC VỤ CỦA CƠ SỞ KINH DOANH DỊCH VỤ LƯU TRÚ  => (HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 2 LÀ 55)
  ///maSanPham ở câu A5_1_2
  ///cap2: mã sản phẩm cấp 2: 56
  Future<bool> hasCap2_56TM(String maQuiDinh, String maSanPhams) async {
    // if (maSanPhams == '') {
    //   return true;
    // }
    // return await dmNhomNganhVcpaProvider.kiemTraMaNganhCap2ByMaSanPham5(
    //      maQuiDinh, maSanPhams);
    return await dmMotaSanphamProvider.kiemTraMaNganhCap2ByMaSanPham5(
        maQuiDinh, maSanPhams);
  }

  Future<bool> hasAllCap2_56TM() async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      return await dmMotaSanphamProvider.kiemTraMaNganhCap2ByMaSanPham5(
          vcpaCap2TM, resMaSPs.join(';'));
    }
    return false;
  }

  ///VI. NĂNG LỰC PHỤC VỤ CỦA CƠ SỞ KINH DOANH DỊCH VỤ VẬN TẢI NĂM 2024
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 1 LÀ NGÀNH H)
  Future<bool> hasCap1NganhVT() async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      return await dmMotaSanphamProvider.kiemTraMaNganhCap1ByMaSanPham5(
          'H', resMaSPs.join(';'));
    }
    return false;
  }

  ///HOẠT ĐỘNG VẬN TẢI HÀNH KHÁCH
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 5 LÀ 49210-49220-49290-49312-49313-49319-49321-49329-50111-50112-50211-50212)
  ///HOẠT ĐỘNG VẬN TẢI HÀNG HÓA
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 5 LÀ 49331-49332-49333-49334-49339-50121-50122-50221-50222)
  Future<bool> hasCap5NganhVT(String maQuiDinh) async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      return await dmMotaSanphamProvider.kiemTraMaNganhCap5ByMaSanPham5(
          maQuiDinh, resMaSPs.join(';'));
    }
    return false;
  }

  // Future<List<TablePhieuMauTBSanPham>> getMaSanPhamNganhCN() async {
  //      List<TablePhieuMauTBSanPham> result = [];
  //   var resMaSPs =
  //       await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
  //   if (resMaSPs.isNotEmpty) {
  //     var spBCDEs =
  //         await dmMotaSanphamProvider.getSanPhamByCap1BCDE(resMaSPs.join(';'));
  //     if (spBCDEs.isNotEmpty) {
  //       var sanPhams = await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCosoSps(
  //           currentIdCoSo!, spBCDEs.join(';'));
  //            if (sanPhams.isNotEmpty) {
  //         result = TablePhieuMauTBSanPham.fromListJson(sanPhams) ?? [];
  //       }
  //     }
  //   }
  //   tblPhieuNganhCNDistinctCap5
  //   return result;
  // }

  ///Lấy mã ngành vận tải hành khách (maSanPhams), hàng hoá (maSanPhams) ở bảng phieuMauTBSanPham
  Future<List<TablePhieuMauTBSanPham>> getMaSanPhamNganhVT(
      String maSanPhams) async {
    List<TablePhieuMauTBSanPham> result = [];
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      var sps = await dmMotaSanphamProvider.getMaNganhCap5ByMaSanPham5(
          maSanPhams, resMaSPs.join(';'));
      if (sps.isNotEmpty) {
        var res = await phieuMauTBSanPhamProvider.getSanPhamsByIdCosoSps(
            currentIdCoSo!, sps.join(';'));
        if (res.isNotEmpty) {
          result = TablePhieuMauTBSanPham.fromListJson(res) ?? [];
        }
      }
    }
    if (vcpaCap5VanTaiHanhKhach == maSanPhams) {
      tblPhieuMauTBSanPhamVTHanhKhach.assignAll(result);
      if (tblPhieuMauTBSanPhamVTHanhKhach.isNotEmpty) {
        List<String> res =
            tblPhieuMauTBSanPhamVTHanhKhach.map((x) => x.a5_1_2!).toList();
        hasMaNganhVTHK.addAll(res);
      }
    }
    if (vcpaCap5VanTaiHangHoa == maSanPhams) {
      tblPhieuMauTBSanPhamVTHangHoa.assignAll(result);
      if (tblPhieuMauTBSanPhamVTHangHoa.isNotEmpty) {
        List<String> res =
            tblPhieuMauTBSanPhamVTHangHoa.map((x) => x.a5_1_2!).toList();
        hasMaNganhVTHH.addAll(res);
      }
    }
    return result;
  }

  ///Lấy mã ngành luu tru maSanPhams=55 ở bảng phieuMauTBSanPham
  Future<List<TablePhieuMauTBSanPham>> getMaSanPhamNganhLT() async {
    List<TablePhieuMauTBSanPham> result = [];
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      var sps = await dmMotaSanphamProvider.getMaNganhCapByMaSanPham2(
          vcpaCap2LT, resMaSPs.join(';'));
      if (sps.isNotEmpty) {
        var res = await phieuMauTBSanPhamProvider.getSanPhamsByIdCosoSps(
            currentIdCoSo!, sps.join(';'));
        if (res.isNotEmpty) {
          result = TablePhieuMauTBSanPham.fromListJson(res) ?? [];
        }
      }
    }
    tblPhieuMauTBSanPhamLT.assignAll(result);
    return result;
  }

  ///Lấy mã ngành luu tru maSanPhams=GL6810 ở bảng phieuMauTBSanPham
  Future<List<TablePhieuMauTBSanPham>> getMaSanPhamNganhTMGL6810() async {
    List<TablePhieuMauTBSanPham> result = [];
    var arrG_C5 = maVcpaLoaiTruG_C5.split(';');
    var arrG_C4 = maVcpaLoaiTruG_C4.split(';');
    var arrG_C3 = maVcpaLoaiTruG_C3.split(';');
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      var spG8610s = await dmMotaSanphamProvider.getSanPhamBy_5G_L6810(
          resMaSPs.join(';'), arrG_C3, arrG_C4, arrG_C5, maVcpaL6810);
      if (spG8610s.isNotEmpty) {
        var res = await phieuMauTBSanPhamProvider.getSanPhamsByIdCosoSps(
            currentIdCoSo!, spG8610s.join(';'));
        if (res.isNotEmpty) {
          result = TablePhieuMauTBSanPham.fromListJson(res) ?? [];
        }
      }
    }

    tblPhieuMauTBSanPhamTMGL6810.assignAll(result);
    return result;
  }

  ///Lấy mã ngành luu tru maSanPhams=56 ở bảng phieuMauTBSanPham
  Future<List<TablePhieuMauTBSanPham>> getMaSanPhamNganhTM56() async {
    List<TablePhieuMauTBSanPham> result = [];
    var arrG_C5 = maVcpaLoaiTruG_C5.split(';');
    var arrG_C4 = maVcpaLoaiTruG_C4.split(';');
    var arrG_C3 = maVcpaLoaiTruG_C3.split(';');
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      var sps = await dmMotaSanphamProvider.getMaNganhCapByMaSanPham2(
          vcpaCap2TM, resMaSPs.join(';'));
      if (sps.isNotEmpty) {
        var res = await phieuMauTBSanPhamProvider.getSanPhamsByIdCosoSps(
            currentIdCoSo!, sps.join(';'));
        if (res.isNotEmpty) {
          result = TablePhieuMauTBSanPham.fromListJson(res) ?? [];
        }
      }
    }

    tblPhieuMauTBSanPhamTM56.assignAll(result);
    return result;
  }

  countCap5NganhVT(String maSanPhams) async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      return await dmMotaSanphamProvider.countMaNganhCap5ByMaSanPham5(
          maSanPhams, resMaSPs.join(';'));
    }
    return 0;
  }

  Future<bool> hasCap2NganhLT(String maSPCap2QuiDinh) async {
    var resMaSPs =
        await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
    if (resMaSPs.isNotEmpty) {
      return await dmMotaSanphamProvider.kiemTraMaNganhCap2ByMaSanPham5(
          maSPCap2QuiDinh, resMaSPs.join(';'));
    }
    return false;
  }

  ///END:: PHẦN V
  /***********/
  ///BEGIN:: PHẦN VI
  ///maSanPham: 42343;24234;...
  ///Return: true => Hiển thị phần/câu hỏi; false: không hiển thị phần/câu hỏi
  Future<bool> kiemTraCauHoiThuocMaVCPA(String maSanPham) async {
    //1. Lấy các mã sản phẩm ở bảng phieuMauSanPham
    //2. So sánh với maVCPAs của phần/câu hỏi
    // if (maSanPham == '') {
    //   return true;
    // }
    List<String> arrMa = maSanPham.split(';');
    var res = await phieuMauTBSanPhamProvider.kiemTraMaNganhVCPA(arrMa);
    return res;
  }

  ///END:: PHẦN VI
  /***********/
  ///
/***********/
  ///BEGIN::PHẦN VII
  onSelectDmLTA1(
    QuestionCommonModel question,
    String table,
    String? maCauHoi,
    String? fieldName,
    value,
    dmItem, {
    ChiTieuDongModel? chiTieuDong,
    ChiTieuModel? chiTieuCot,
  }) {
    log('ON CHANGE onSelectDmLTA1: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblPhieuMau(fieldName, value, table);

      if (maCauHoi == "A1" && question.maPhieu == AppDefine.maPhieuLT) {
        if (value != 1) {
          var hasData =
              kiemTraDuLieuLTA1ChiTieu(table, value, chiTieuDong!, chiTieuCot!);
          if (hasData) {
            Get.dialog(DialogBarrierWidget(
              onPressedNegative: () async {
                await backYesValueForYesNoQuestionLTA1(
                    table, maCauHoi, fieldName, 1, question);
              },
              onPressedPositive: () async {
                updateAnswerToDB(table, fieldName!, value);
                updateAnswerTblPhieuMau(fieldName, value, table);
                await executeOnChangeYesNoQuestionLTA1(
                    table, value, chiTieuDong!, chiTieuCot!);
                Get.back();
              },
              title: 'dialog_title_warning'.tr,
              content: 'dialog_content_warning_select_no_chitieu'.tr,
            ));
          } else {
            updateAnswerToDB(table, fieldName!, value);
            updateAnswerTblPhieuMau(fieldName, value, table);
          }
        }
        tinhTongSoPhongA5LT(question);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  backYesValueForYesNoQuestionLTA1(
      String table, String? maCauHoi, String? fieldName, value, dmItem) async {
    await updateAnswerToDB(table, fieldName!, 1);
    await updateAnswerTblPhieuMau(fieldName, 1, table);
    Get.back();
  }

  executeOnChangeYesNoQuestionLTA1(table, value, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) async {
    log('ON executeOnChangeYesNoQuestionLTA1:  $value');

    try {
      if (value != 1) {
        for (int i = 2; i <= 6; i++) {
          var fieldNameDel = '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_$i';
          await updateAnswerToDB(table, fieldNameDel, null);
          await updateAnswerTblPhieuMau(fieldNameDel, null, table);
        }
        await updateAnswerToDB(table, colPhieuNganhLTA1_5_GhiRo, null);
        await updateAnswerTblPhieuMau(colPhieuNganhLTA1_5_GhiRo, null, table);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  kiemTraDuLieuLTA1ChiTieu(
      table, value, ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot) {
    List<dynamic> result = [];
    for (int i = 2; i <= 6; i++) {
      var fieldName = '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_$i';
      var val = getValueByFieldName(table, fieldName);
      if (val != null && val != '') {
        result.add(val);
      }
    }
    var valGhiRo = getValueByFieldName(table, colPhieuNganhLTA1_5_GhiRo);
    if (valGhiRo != null) {
      result.add(valGhiRo);
    }
    return result.isNotEmpty;
  }

  ///END::PHẦN VII

  /// ****BEGIN: Nganh CN*****

  addNewRowProductNganhCN(TablePhieuNganhCNCap5 product) async {
    await insertNewRecordNganhCN(product);
    await getTablePhieuNganhCN();
  }

  ///Thêm mới record cho bảng CT_Phieu_NganhCN
  Future insertNewRecordNganhCN(TablePhieuNganhCNCap5 product) async {
    var maxStt = await phieuNganhCNProvider.getMaxSTTByIdCoso(currentIdCoSo!);
    maxStt = maxStt + 1;
    var tblSp = TablePhieuNganhCN(
        iDCoSo: currentIdCoSo,
        sTT_SanPham: maxStt,
        maNganhC5: product.maNganhC5,
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

  bool allowDeleteProductNganhCN(TablePhieuNganhCN product) {
    // if (product != null) {
    //   var countCap5=await phieuNganhCNProvider.countMaNganhCap5ByIdCoso(currentIdCoSo!,product.maNganhC5!);
    //   return countCap5>1;
    // }
    // return false;
    return true;
  }

  onDeleteProductNganhCN(
      TablePhieuNganhCN phieuNganhCN, TablePhieuNganhCNCap5 productCap5) async {
    var maC5 = phieuNganhCN.maNganhC5 ?? '';
    if (maC5 == '') {
      Get.dialog(DialogBarrierWidget(
        isCancelButton: false,
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          Get.back();
        },
        title: 'dialog_title_warning'.tr,
        content: 'Không tìm thấy mã cấp 5 của mục này?',
      ));
      return;
    }
    var res =
        await kiemtraXoaSanPham(phieuNganhCN.id!, phieuNganhCN.maNganhC5!);
    if (res == false) {
      Get.dialog(DialogBarrierWidget(
        onPressedNegative: () async {
          Get.back();
        },
        onPressedPositive: () async {
          //await executeConfirmDeleteProductNganhCN(phieuNganhCN.id);

          Get.back();
        },
        title: 'dialog_title_warning'.tr,
        content: 'Phải có ít nhất một sản phẩm cấp 8 của mã cấp 5:',
        content2: '${phieuNganhCN.maNganhC5} - ${productCap5.moTaSanPham}.',
        content2Color: warningColor,
        isCancelButton: false,
      ));
    } else {
      await onConfirmDeleteProductNganhCN(phieuNganhCN.id!);
    }
  }

  Future<bool> kiemtraXoaSanPham(int id, String maNganhC5) async {
    var res =
        await phieuNganhCNProvider.getByMaNganhC5(currentIdCoSo!, maNganhC5);
    if (res.isNotEmpty) {
      if (res.length > 1) {
        return true;
      }
    }
    return false;
  }

  onConfirmDeleteProductNganhCN(int id) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await executeConfirmDeleteProductNganhCN(id);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: 'Bạn có chắc muốn xoá sản phẩm này?',
    ));
  }

  executeConfirmDeleteProductNganhCN(id) async {
    await xacNhanLogicProvider.deleteByIdHoManHinh(
        currentIdCoSo!, currentScreenNo.value);
    await phieuNganhCNProvider.deleteById(id);
    await getTablePhieuNganhCN();
    await danhDauSanPhamCN();
  }

  countHasMoreProductNganhCN(String table, String maNganhC5) {
    if (table == tablePhieuNganhCN) {
      var countItem = tblPhieuNganhCN
          .where((x) =>
              x.sTT_SanPham != null &&
              x.maNganhC5 != null &&
              x.maNganhC5 == maNganhC5 &&
              x.a1_1 != null &&
              x.a1_2 != null &&
              (x.a2_2 != null && x.a2_2! > 0) &&
              x.iDCoSo == currentIdCoSo)
          .length;
      return countItem;
    }
    return 0;
  }

/***END::NGÀNH CN***/

  updateNganhAll() async {
    /**
           * NGÀNH CN
             * todo  KIỂM TRA MÃ SẢN PHẨM (ĐANG CHỌN VÀ HIỆN CÓ TRONG CT_PhieuMauTB_SanPham) CẤP 1 LÀ B, C, D, E:
             * => CT_Phieu_NganhCN phiếu 7.1 CN
             * todo   - Phải cập nhật thông tin sản phẩm đó cho bảng CT_Phieu_NganhCN
             * todo   - Ngược lại XOÁ thông tin sản phẩm đó ở bảng CT_Phieu_NganhCN
             * 
             */
    await updateDataNganhCN();
    /**
           * NGÀNH VT
             * todo  KIỂM TRA MÃ SẢN PHẨM (ĐANG CHỌN VÀ HIỆN CÓ TRONG CT_PhieuMauTB_SanPham) THUỘC CÁC MÃ VẬN HÀNH KHÁCH VÀ/HOẶC VẬN TẢI HÀNH KHÁCH
             * MÃ VẬN TẢI HÀNH KHÁCH GỒM CÁC MÃ vcpaCap5VanTaiHanhKhach = "49210;49220;49290;49312;49313;49319;49321;49329;50111;50112;50211;50212"
             * MÃ VẬN TẢI HÀNG HOÁ GỒM CÁC MÃ vcpaCap5VanTaiHangHoa = "49331;49332;49333;49334;49339;50121;50122;50221;50222";
             * => CT_Phieu_NganhCN phiếu 7.2 VT
             * todo   - Phải cập nhật thông tin sản phẩm đó cho bảng CT_Phieu_NganhVT
             * todo   - Ngược lại XOÁ thông tin sản phẩm đó ở bảng CT_Phieu_NganhVT
             * 
             */
    await updateDataNganhVT();

    /**
           * NGÀNH CN
             * todo  KIỂM TRA MÃ SẢN PHẨM (ĐANG CHỌN VÀ HIỆN CÓ TRONG CT_PhieuMauTB_SanPham) CẤP 2 LÀ 55 (KINH DOANH DỊCH VỤ LƯU TRÚ):
             * => CT_Phieu_NganhCN phiếu 7.3 LT
             * todo   - Phải cập nhật thông tin sản phẩm đó cho bảng CT_Phieu_NganhLT
             * todo   - Ngược lại XOÁ thông tin sản phẩm đó ở bảng CT_Phieu_NganhLT
             * 
             */
    await updateDataNganhLT();
    /**
           * NGÀNH TM
             * todo  KIỂM TRA MÃ SẢN PHẨM (ĐANG CHỌN VÀ HIỆN CÓ TRONG CT_PhieuMauTB_SanPham) CẤP 1 LÀ G VÀ NGÀNH CẤP 4 LÀ 6810 (TRỪ CÁC MÃ 4513, 4520, 45413, 4542, 461)
             *  => CT_Phieu_NganhTM_SanPham
             * todo   - Phải cập nhật thông tin sản phẩm đó cho bảng CT_Phieu_NganhTM_Sanpham
             * todo   - Ngược lại XOÁ thông tin sản phẩm đó ở bảng CT_Phieu_NganhTM_Sanpham
             * 
             */
    ///Kiểm tra: [MÃ SẢN PHẨM CẤP 1 LÀ G VÀ NGÀNH L6810  (TRỪ CÁC MÃ 4513-4520-45413-4542-461)]
    await updateDataNganhTM();
  }

  Future<bool> updateDataNganhCN() async {
    var hasBDCE = await hasAllSanPhamBCDE();

    if (hasBDCE) {
      // var res = await phieuNganhCNProvider.isExistProduct(currentIdCoSo!);
      // if (res == false) {
      //   var maxStt =
      //       await phieuNganhCNProvider.getMaxSTTByIDCoso(currentIdCoSo!);
      //   maxStt = maxStt + 1;
      //   var tblSp = TablePhieuNganhCN(
      //       iDCoSo: currentIdCoSo, sTT_SanPham: maxStt, maDTV: AppPref.uid);
      //   List<TablePhieuNganhCN> tblSps = [];
      //   tblSps.add(tblSp);

      //   await phieuNganhCNProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
      // }
      //Lấy các sản phẩm là cấp 5 thuộc G,L 8610 từ bảng PhieuMauTBSanPham;
      var resMaSPs =
          await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
      if (resMaSPs.isNotEmpty) {
        var spBCDEs = await dmMotaSanphamProvider
            .getSanPhamByCap1BCDE(resMaSPs.join(';'));
        if (spBCDEs.isNotEmpty) {
          var sanPhams = await phieuMauTBSanPhamProvider
              .getMaSanPhamsByIdCosoSps(currentIdCoSo!, spBCDEs.join(';'));
          //
          if (sanPhams.isNotEmpty) {
            var res = await phieuNganhCNProvider.selectCap1BCDEByIdCoSo(
                currentIdCoSo!, sanPhams);
            if (res.isNotEmpty) {
              var currentSp = TablePhieuNganhCN.fromListJson(res);
              if (currentSp != null && currentSp.isNotEmpty) {
                await phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);
                await phieuNganhCNProvider.insertCN(
                    currentSp, AppPref.dateTimeSaveDB!);
              } else {
                // var hasBDCE = await hasAllSanPhamBCDE();

                // if (!hasBDCE) {
                //   await phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);
                // }
              }
            } else {
              // var hasBDCE = await hasAllSanPhamBCDE();

              // if (!hasBDCE) {
              //   await phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);
              // }
            }
          }
        }
      }
      //Goi ham  Mã ngành cấp 2 là ngành công nghiệp (mã ngành >=10 và <=39)
      await getMaNganhCN10To39();
    } else {
      // if (res) {
      //   phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);
      // }
    }
    await getTablePhieuNganhCN();
    return hasBDCE;
  }

  /// ***BEGIN::NGANH VT*******
  Future<(bool, bool, bool)> updateDataNganhVT() async {
    var hasC1VT = await hasCap1NganhVT();
    var hasC5VTHK = await hasCap5NganhVT(vcpaCap5VanTaiHanhKhach);
    var hasC5VTHH = await hasCap5NganhVT(vcpaCap5VanTaiHangHoa);
    if ((hasC1VT && hasC5VTHK) || (hasC1VT && hasC5VTHH)) {
      var res = await phieuNganhVTProvider.isExistQuestion(currentIdCoSo!);
      if (res == false) {
        var tblSp =
            TablePhieuNganhVT(iDCoSo: currentIdCoSo, maDTV: AppPref.uid);
        List<TablePhieuNganhVT> tblSps = [];
        tblSps.add(tblSp);

        await phieuNganhVTProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
      }
      //Ghi ro
      if (hasC1VT && hasC5VTHK) {
        await insertNganhVTGhiRoDefaultA1_A7("A1_13");
        await insertNganhVTGhiRoDefaultA1_A7("A1_15");
      }
      if (hasC1VT && hasC5VTHH) {
        await insertNganhVTGhiRoDefaultA1_A7("A7_17");
        await insertNganhVTGhiRoDefaultA1_A7("A7_18");
      }
    } else {
      // if (res) {
      //   phieuNganhVTProvider.deleteByCoSoId(currentIdCoSo!);
      // }
    }
    await getTablePhieuNganhVT();
    await getTablePhieuNganhVTGhiRo();
    return (hasC1VT, hasC5VTHK, hasC5VTHH);
  }

  Future insertNganhVTGhiRoDefaultA1_A7(String maCauHoiMaSo) async {
    var resChkA1_13 = await phieuNganhVTGhiRoProvider.isExistQuestionByMaCauHoi(
        currentIdCoSo!, maCauHoiMaSo);
    if (!resChkA1_13) {
      TablePhieuNganhVTGhiRo vtGhiRo = TablePhieuNganhVTGhiRo(
          iDCoSo: currentIdCoSo!,
          maCauHoi: maCauHoiMaSo,
          sTT: 1,
          maDTV: AppPref.uid);
      List<TablePhieuNganhVTGhiRo> tablePhieuNganhVTGhiRos = [];
      tablePhieuNganhVTGhiRos.add(vtGhiRo);
      phieuNganhVTGhiRoProvider.insert(
          tablePhieuNganhVTGhiRos, AppPref.dateTimeSaveDB!);
    }
  }

  bool isA1NganhVT(QuestionCommonModel question, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) {
    return (question.maCauHoi == "A1" &&
        question.maPhieu == AppDefine.maPhieuVT);
  }

  bool isA7NganhVT(QuestionCommonModel question, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) {
    return (question.maCauHoi == "A7" &&
        question.maPhieu == AppDefine.maPhieuVT);
  }

  bool isA1GhiRoF(QuestionCommonModel question, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) {
    return (question.maCauHoi == "A1" &&
            question.maPhieu == AppDefine.maPhieuVT) &&
        (chiTieuDong.maSo == "13" || chiTieuDong.maSo == "15");
  }

  bool isA7GhiRoF(QuestionCommonModel question, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) {
    return (question.maCauHoi == "A7" &&
            question.maPhieu == AppDefine.maPhieuVT) &&
        (chiTieuDong.maSo == "17" || chiTieuDong.maSo == "18");
  }

  ///Check có/không chi cũng gọi hàm này::
  ///* TODO Chỉ dùng cho stt=1
  Future insertUpdateGhiRoNganhVT(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, coKhongVal) async {
    var isA1GhiRo = isA1GhiRoF(question, chiTieuDong, chiTieuCot);
    var isA7GhiRo = isA7GhiRoF(question, chiTieuDong, chiTieuCot);

    if (isA1GhiRo || isA7GhiRo) {
      String maCauHoiMaSo = '${question.maCauHoi}_${chiTieuDong.maSo}';
      var resChk = await phieuNganhVTGhiRoProvider.isExistQuestionByMaCauHoiSTT(
          currentIdCoSo!, maCauHoiMaSo, 1);
      if (coKhongVal == 1 || coKhongVal == "1") {
        if (!resChk) {
          await insertVTGhiRo(question, chiTieuDong, chiTieuCot, coKhongVal);
        }
      } else if (coKhongVal == 2 || coKhongVal == "2") {
        if (!resChk) {
          Get.dialog(DialogBarrierWidget(
            onPressedNegative: () async {
              Get.back();
            },
            onPressedPositive: () async {
              await executeConfirmDeleteVTGhiRo(
                  question, chiTieuDong, chiTieuCot, coKhongVal);
              Get.back();
            },
            title: 'dialog_title_warning'.tr,
            content: 'Bạn có chắc muốn xoá thông tin ghi rõ mục này?',
          ));
        }
      }
    }
  }

  Future executeConfirmDeleteVTGhiRo(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, coKhongVal) async {
    if (coKhongVal == 2 || coKhongVal == "2") {
      var res = await phieuNganhVTGhiRoProvider.deleteByCoSoId(currentIdCoSo!);
      if (res > 0) {
        await insertVTGhiRo(question, chiTieuDong, chiTieuCot, coKhongVal);
      }
    }
  }

  Future insertVTGhiRo(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, coKhongVal) async {
    var isA1GhiRo = isA1GhiRoF(question, chiTieuDong, chiTieuCot);

    if (isA1GhiRo || isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
      String maCauHoiMaSo = '${question.maCauHoi}_${chiTieuDong.maSo}';
      // var resChk = await phieuNganhVTGhiRoProvider.isExistQuestionByMaCauHoi(/currentIdCoSo!, maCauHoiMaSo);

      // if (!resChk) {
      int sttMax = await phieuNganhVTGhiRoProvider.getMaxSTTByIdCoSoByMaCauHoi(
          currentIdCoSo!, maCauHoiMaSo);
      sttMax = sttMax + 1;
      TablePhieuNganhVTGhiRo vtGhiRo = TablePhieuNganhVTGhiRo(
          iDCoSo: currentIdCoSo!,
          maCauHoi: maCauHoiMaSo,
          sTT: sttMax,
          c_1: 1,
          maDTV: AppPref.uid);
      List<TablePhieuNganhVTGhiRo> tablePhieuNganhVTGhiRos = [];
      tablePhieuNganhVTGhiRos.add(vtGhiRo);
      phieuNganhVTGhiRoProvider.insert(
          tablePhieuNganhVTGhiRos, AppPref.dateTimeSaveDB!);
      await getTablePhieuNganhVTGhiRo();
      //  }
    }
  }

  Future deleteGhiRoNganhVTById(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, int id) async {
    var isA1GhiRo = isA1GhiRoF(question, chiTieuDong, chiTieuCot);

    String maCauHoiMaSo = '${question.maCauHoi}_${chiTieuDong.maSo}';
    var resChk = await phieuNganhVTGhiRoProvider.isExistQuestionByMaCauHoiId(
        currentIdCoSo!, maCauHoiMaSo, id);
    if (resChk) {
      var res = await phieuNganhVTGhiRoProvider.deleteById(id);
      await getTablePhieuNganhVTGhiRo();
    }
  }

  Future onDeletePhieuNganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem) async {
    await deleteGhiRoNganhVTById(
        question, chiTieuDong, chiTieuCot, ghiRoItem.id!);
  }

  Future addNewRowonPhieuNganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem) async {
    await insertVTGhiRo(question, chiTieuDong, chiTieuCot, null);
  }

  countHasMorePhieuNganhVTGhiRo(
      String table, TablePhieuNganhVTGhiRo ghiRoItem) {
    if (table == tablePhieuNganhVTGhiRo) {
      var countItem = tblPhieuNganhVTGhiRos
          .where((x) =>
              x.maCauHoi != null &&
              x.c_1 != null &&
              x.c_2 != null &&
              x.c_3 != null &&
              x.c_4 != null &&
              x.cGhiRo != null &&
              x.sTT == 1 &&
              x.maCauHoi == ghiRoItem.maCauHoi &&
              x.iDCoSo == currentIdCoSo)
          .length;
      return countItem;
    }
    return 0;
  }

  onSelectDmA1_A7(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, value, dmItem,
      {ChiTieuDongModel? chiTieuDong,
      ChiTieuModel? chiTieuCot,
      TablePhieuNganhVTGhiRo? ghiRoItem}) {
    log('ON CHANGE onSelectDmA1_A7: $fieldName $value $dmItem');
    try {
      if (isA1GhiRoF(question, chiTieuDong!, chiTieuCot!)) {
        if (chiTieuDong.maSo == "13" || chiTieuDong.maSo == "15") {
          updateAnswerPhieuVTGhiRoToDB(
              colPhieuNganhVTGhiRoC1, value, ghiRoItem!.id!);
          if (value == 1 || value == "1") {
            tinhTongTaiTrongA1GhiRoNganhVT(
                question, table, chiTieuDong, chiTieuCot, ghiRoItem);
          }
          if (value == 2 || value == "2") {
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoC2, null, ghiRoItem!.id!);
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoC3, null, ghiRoItem!.id!);
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoC4, null, ghiRoItem!.id!);
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoCGhiRo, null, ghiRoItem!.id!);
          }
          tinhTongA5A6NganhVT(question);
        }
      } else if (isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
        if (chiTieuDong.maSo == "17" || chiTieuDong.maSo == "18") {
          updateAnswerPhieuVTGhiRoToDB(
              colPhieuNganhVTGhiRoC1, value, ghiRoItem!.id!);
          if (value == 1 || value == "1") {
            tinhTongTaiTrongA7GhiRoNganhVT(
                question, table, chiTieuDong, chiTieuCot, ghiRoItem);
          }
          if (value == 2 || value == "2") {
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoC2, null, ghiRoItem!.id!);
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoC3, null, ghiRoItem!.id!);
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoC4, null, ghiRoItem!.id!);
            updateAnswerPhieuVTGhiRoToDB(
                colPhieuNganhVTGhiRoCGhiRo, null, ghiRoItem!.id!);
          }
          tinhTongA11A12NganhVT(question);
        }
      } else if (isA1NganhVT(question, chiTieuDong, chiTieuCot)) {
        String soLuongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_2';
        String taiTrongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_3';
        String tongTaiTrongFieldName =
            '${question.maCauHoi}_${chiTieuDong.maSo}_4';
        if (value == 1 || value == "1") {
          //update co/khong
          updateAnswerToDB(table, fieldName ?? "", value);
          updateAnswerTblPhieuMau(fieldName, value, table);
          //Lấy trọng tải
          var trongTai =
              layTaiTrongA1NganhVT(question, table, chiTieuDong, chiTieuCot);

          updateAnswerToDB(table, taiTrongFieldName, trongTai);
          updateAnswerTblPhieuMau(taiTrongFieldName, trongTai, table);
          tinhTongTaiTrongA1NganhVT(question, table, chiTieuDong, chiTieuCot);
        } else {
          updateAnswerToDB(table, fieldName ?? "", value);
          updateAnswerTblPhieuMau(fieldName, value, table);

          updateAnswerToDB(table, soLuongFieldName, null);
          updateAnswerTblPhieuMau(soLuongFieldName, null, table);
          updateAnswerToDB(table, taiTrongFieldName, null);
          updateAnswerTblPhieuMau(taiTrongFieldName, null, table);
          updateAnswerToDB(table, tongTaiTrongFieldName, null);
          updateAnswerTblPhieuMau(tongTaiTrongFieldName, null, table);
        }

        updateAnswerToDB(table, fieldName ?? "", value);
        updateAnswerTblPhieuMau(fieldName, value, table);
        tinhTongA5A6NganhVT(question);
      } else if (isA7NganhVT(question, chiTieuDong, chiTieuCot)) {
        String soLuongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_2';
        String taiTrongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_3';
        String tongTaiTrongFieldName =
            '${question.maCauHoi}_${chiTieuDong.maSo}_4';
        if (value == 1) {
          //update co/khong
          updateAnswerToDB(table, fieldName ?? "", value);
          updateAnswerTblPhieuMau(fieldName, value, table);
          //Lấy trọng tải
          var trongTai =
              layTaiTrongA7NganhVT(question, table, chiTieuDong, chiTieuCot);

          updateAnswerToDB(table, taiTrongFieldName, trongTai);
          updateAnswerTblPhieuMau(taiTrongFieldName, trongTai, table);
          tinhTongTaiTrongA7NganhVT(question, table, chiTieuDong, chiTieuCot);
        } else {
          updateAnswerToDB(table, fieldName ?? "", value);
          updateAnswerTblPhieuMau(fieldName, value, table);

          updateAnswerToDB(table, soLuongFieldName, null);
          updateAnswerTblPhieuMau(soLuongFieldName, null, table);
          updateAnswerToDB(table, taiTrongFieldName, null);
          updateAnswerTblPhieuMau(taiTrongFieldName, null, table);
          updateAnswerToDB(table, tongTaiTrongFieldName, null);
          updateAnswerTblPhieuMau(tongTaiTrongFieldName, null, table);
        }

        updateAnswerToDB(table, fieldName ?? "", value);
        updateAnswerTblPhieuMau(fieldName, value, table);
        tinhTongA11A12NganhVT(question);
      } else {
        updateAnswerToDB(table, fieldName ?? "", value);
        updateAnswerTblPhieuMau(fieldName, value, table);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  int layTaiTrongA1NganhVT(QuestionCommonModel question, String table,
      ChiTieuDongModel? chiTieuDong, ChiTieuModel? chiTieuCot) {
    int result = 0;
    if (chiTieuDong!.giaTriLN != null) {
      result = chiTieuDong!.giaTriLN!.toInt();
    }
    return result;
  }

  double layTaiTrongA7NganhVT(QuestionCommonModel question, String table,
      ChiTieuDongModel? chiTieuDong, ChiTieuModel? chiTieuCot) {
    double result = 0.0;
    if (chiTieuDong!.giaTriLN != null) {
      result = chiTieuDong!.giaTriLN!;
    }
    return result;
  }

  Future<int> tinhTongTaiTrongA1NganhVT(
      QuestionCommonModel question,
      String table,
      ChiTieuDongModel? chiTieuDong,
      ChiTieuModel? chiTieuCot) async {
    int result = 0;
    if (chiTieuDong!.giaTriLN != null) {}
    String soLuongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_2';
    String taiTrongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_3';
    String tongTaiTrongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_4';
    var soluong = getValueByFieldName(table, soLuongFieldName);
    soluong = AppUtils.convertStringToInt(soluong);
    var taiTrong = getValueByFieldName(table, taiTrongFieldName);
    taiTrong = AppUtils.convertStringToInt(taiTrong);
    result = soluong * taiTrong;
    await updateAnswerToDB(table, tongTaiTrongFieldName, result);
    await updateAnswerTblPhieuMau(tongTaiTrongFieldName, result, table);
    return result;
  }

  Future<double> tinhTongTaiTrongA1GhiRoNganhVT(
      QuestionCommonModel question,
      String table,
      ChiTieuDongModel? chiTieuDong,
      ChiTieuModel? chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem) async {
    double result = 0.0;

    var soluong = getValueVTGhiRoByFieldNameFromDB(
        table, colPhieuNganhVTGhiRoC2, ghiRoItem.maCauHoi!, ghiRoItem.sTT!,
        id: ghiRoItem.id!);
    soluong = AppUtils.convertStringAndFixedToDouble(soluong);
    var taiTrong = getValueVTGhiRoByFieldNameFromDB(
        table, colPhieuNganhVTGhiRoC3, ghiRoItem.maCauHoi!, ghiRoItem.sTT!,
        id: ghiRoItem.id!);
    taiTrong = AppUtils.convertStringAndFixedToDouble(taiTrong);
    result = soluong * taiTrong;
    await updateAnswerPhieuVTGhiRoToDB(
        colPhieuNganhVTGhiRoC4, result, ghiRoItem.id!);
    return result;
  }

  Future tinhTongA5A6NganhVT(QuestionCommonModel question) async {
    int tongSoLuong = 0;
    int tongTaiTrong = 0;
    var dsChiTieuDong = question.danhSachChiTieuIO;
    if (dsChiTieuDong != null) {
      List<String> soLuongFieldNames = [];
      List<String> taiTrongFieldNames = [];
      for (var chiTieuDong in dsChiTieuDong) {
        if (chiTieuDong.maSo != "13" && chiTieuDong.maSo != "15") {
          String soLuongFieldName =
              '${question.maCauHoi}_${chiTieuDong.maSo}_2';
          String taiTrongFieldName =
              '${question.maCauHoi}_${chiTieuDong.maSo}_3';
          soLuongFieldNames.add(soLuongFieldName);
          taiTrongFieldNames.add(taiTrongFieldName);
        }
      }
      tongSoLuong = await phieuNganhVTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, soLuongFieldNames);
      tongTaiTrong = await phieuNganhVTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, taiTrongFieldNames);
    }
    int tongSoLuongA1_1315 =
        await phieuNganhVTGhiRoProvider.tongSoLuongA1_1315(currentIdCoSo!);

    int tongTaiTrongA1_1315 =
        await phieuNganhVTGhiRoProvider.tongTaiTrongA1_1315(currentIdCoSo!);
    tongSoLuong = tongSoLuong + tongSoLuongA1_1315;
    tongTaiTrong = tongTaiTrong + tongTaiTrongA1_1315;

    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA5, tongSoLuong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhVTA5, tongSoLuong, tablePhieuNganhVT);
    //Tong tai trong
    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA6, tongTaiTrong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhVTA6, tongTaiTrong, tablePhieuNganhVT);
  }

  Future<double> tinhTongTaiTrongA7NganhVT(
      QuestionCommonModel question,
      String table,
      ChiTieuDongModel? chiTieuDong,
      ChiTieuModel? chiTieuCot) async {
    double result = 0.0;
    if (chiTieuDong!.giaTriLN != null) {}
    String soLuongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_2';
    String taiTrongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_3';
    String tongTaiTrongFieldName = '${question.maCauHoi}_${chiTieuDong.maSo}_4';
    var soluong = getValueByFieldName(table, soLuongFieldName);
    soluong = AppUtils.convertStringAndFixedToDouble(soluong);
    var taiTrong = getValueByFieldName(table, taiTrongFieldName);
    taiTrong = AppUtils.convertStringAndFixedToDouble(taiTrong);
    result = soluong * taiTrong;
    await updateAnswerToDB(table, tongTaiTrongFieldName, result);
    await updateAnswerTblPhieuMau(tongTaiTrongFieldName, result, table);
    return result;
  }

  Future tinhTongA11A12NganhVT(QuestionCommonModel question) async {
    int tongSoLuong = 0;
    double tongTaiTrong = 0.0;
    var dsChiTieuDong = question.danhSachChiTieuIO;
    if (dsChiTieuDong != null) {
      List<String> soLuongFieldNames = [];
      List<String> taiTrongFieldNames = [];
      for (var chiTieuDong in dsChiTieuDong) {
        if (chiTieuDong.maSo != "17" && chiTieuDong.maSo != "18") {
          String soLuongFieldName =
              '${question.maCauHoi}_${chiTieuDong.maSo}_2';
          String taiTrongFieldName =
              '${question.maCauHoi}_${chiTieuDong.maSo}_3';
          soLuongFieldNames.add(soLuongFieldName);
          taiTrongFieldNames.add(taiTrongFieldName);
        }
      }
      tongSoLuong = await phieuNganhVTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, soLuongFieldNames);
      tongTaiTrong = await phieuNganhVTProvider.totalDoubleByMaCauHoi(
          currentIdCoSo!, taiTrongFieldNames, '+');
    }
    int tongSoLuongA7_1718 =
        await phieuNganhVTGhiRoProvider.tongSoLuongA7_1718(currentIdCoSo!);

    double tongTaiTrongA7_1718 =
        await phieuNganhVTGhiRoProvider.tongTaiTrongA7_1718(currentIdCoSo!);
    tongSoLuong = tongSoLuong + tongSoLuongA7_1718;
    tongTaiTrong = tongTaiTrong + tongTaiTrongA7_1718;
    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA11, tongSoLuong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhVTA11, tongSoLuong, tablePhieuNganhVT);
    //Tong tai trong
    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA12, tongTaiTrong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhVTA12, tongTaiTrong, tablePhieuNganhVT);
  }

  Future<double> tinhTongTaiTrongA7GhiRoNganhVT(
      QuestionCommonModel question,
      String table,
      ChiTieuDongModel? chiTieuDong,
      ChiTieuModel? chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem) async {
    double result = 0.0;

    var soluong = getValueVTGhiRoByFieldNameFromDB(
        table, colPhieuNganhVTGhiRoC2, ghiRoItem.maCauHoi!, ghiRoItem.sTT!,
        id: ghiRoItem.id!);
    soluong = AppUtils.convertStringAndFixedToDouble(soluong);
    var taiTrong = getValueVTGhiRoByFieldNameFromDB(
        table, colPhieuNganhVTGhiRoC3, ghiRoItem.maCauHoi!, ghiRoItem.sTT!,
        id: ghiRoItem.id!);
    taiTrong = AppUtils.convertStringAndFixedToDouble(taiTrong);
    result = soluong * taiTrong;
    await updateAnswerPhieuVTGhiRoToDB(
        colPhieuNganhVTGhiRoC4, result, ghiRoItem.id!);
    return result;
  }

//
  onChangePhieuNganhVTGhiRoDm(QuestionCommonModel question, String table,
      String? maCauHoi, String? fieldName, value, dmItem,
      {ChiTieuDongModel? chiTieuDong,
      ChiTieuModel? chiTieuCot,
      TablePhieuNganhVTGhiRo? ghiRoItem}) {
    log('onChangePhieuNganhVTGhiRoDm Mã câu hỏi ${question.maCauHoi} ${question.bangChiTieu}');
    if (isA1GhiRoF(question, chiTieuDong!, chiTieuCot!) ||
        isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
      if (chiTieuDong.maSo == "13") {
        //updateAnswerPhieuVTGhiRoToDB("C1",value)
      } else {}
    }
  }

  updateAnswerPhieuVTGhiRoToDB(String fieldName, value, id) async {
    await phieuNganhVTGhiRoProvider.updateValueById(fieldName, value, id);
    await getTablePhieuNganhVTGhiRo();
  }

  onChangeInputChiTieuDongCotNganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem,
      value,
      {String? fieldNameVTGhiRo}) async {
    try {
      if (isA1GhiRoF(question, chiTieuDong, chiTieuCot) ||
          isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
        String fieldName = 'C_${chiTieuCot.maChiTieu}';
        if (fieldNameVTGhiRo != null && fieldNameVTGhiRo == "C_GhiRo") {
          fieldName = fieldNameVTGhiRo;
        }
        await updateAnswerPhieuVTGhiRoToDB(fieldName, value, ghiRoItem!.id!);
        if (isA1GhiRoF(question, chiTieuDong, chiTieuCot)) {
          if (fieldName == colPhieuNganhVTGhiRoC2 ||
              fieldName == colPhieuNganhVTGhiRoC3) {
            await tinhTongTaiTrongA1GhiRoNganhVT(question,
                tablePhieuNganhVTGhiRo, chiTieuDong, chiTieuCot, ghiRoItem);
            await tinhTongA5A6NganhVT(question);
          }
        } else if (isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
          if (fieldName == colPhieuNganhVTGhiRoC2 ||
              fieldName == colPhieuNganhVTGhiRoC3) {
            await tinhTongTaiTrongA7GhiRoNganhVT(question,
                tablePhieuNganhVTGhiRo, chiTieuDong, chiTieuCot, ghiRoItem);
            await tinhTongA11A12NganhVT(question);
          }
        }
      }

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
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  ///4. SỐ LƯỢT HÀNH KHÁCH VẬN CHUYỂN (PM TỰ TÍNH= 1*2)
  Future tinhSoLuotKhachVanChuyenA4VTMau() async {
    var fieldNamesA1_MA2_M = [colPhieuNganhVTA1_M, colPhieuNganhVTA2_M];
    int tich = await phieuNganhVTProvider.totalSubtractIntByMaCauHoi(
        currentIdCoSo!, fieldNamesA1_MA2_M);

    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA4_M, tich);
    await updateAnswerTblPhieuMau(colPhieuNganhVTA4_M, tich, tablePhieuNganhVT);
  }

  ///5. SỐ LƯỢT HÀNH KHÁCH LUÂN CHUYỂN (PM TỰ TÍNH= 4*3)
  Future tinhSoLuotKhachLuanChuyenA4VTMau() async {
    var fieldNamesA3_MA4_M = [colPhieuNganhVTA3_M, colPhieuNganhVTA4_M];
    double tich = await phieuNganhVTProvider.totalDoubleByMaCauHoi(
        currentIdCoSo!, fieldNamesA3_MA4_M, "*");
    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA5_M, tich);
    await updateAnswerTblPhieuMau(colPhieuNganhVTA5_M, tich, tablePhieuNganhVT);
  }

  Future tinhKhoiLuongHangHoaVanChuyenA9MVTMau() async {
    var fieldNamesA6_MA7M = [colPhieuNganhVTA6_M, colPhieuNganhVTA7_M];
    double tich = await phieuNganhVTProvider.totalDoubleByMaCauHoi(
        currentIdCoSo!, fieldNamesA6_MA7M, "*");

    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA9_M, tich);
    await updateAnswerTblPhieuMau(colPhieuNganhVTA9_M, tich, tablePhieuNganhVT);
  }

  Future tinhKhoiLuongHangHoaLuanChuyenA9MVTMau() async {
    var fieldNamesA8_MA9_M = [colPhieuNganhVTA8_M, colPhieuNganhVTA9_M];
    double tich = await phieuNganhVTProvider.totalDoubleByMaCauHoi(
        currentIdCoSo!, fieldNamesA8_MA9_M, "*");

    await updateAnswerToDB(tablePhieuNganhVT, colPhieuNganhVTA10_M, tich);
    await updateAnswerTblPhieuMau(
        colPhieuNganhVTA10_M, tich, tablePhieuNganhVT);
  }
/*****END::NGANH VT********/

  /// ***BEGIN::NGANH LT*******
  Future<bool> updateDataNganhLT() async {
    var res = await phieuNganhLTProvider.isExistQuestion(currentIdCoSo!);

    var hasC2_56LT = await hasCap2NganhLT('55');
    if ((hasC2_56LT)) {
      if (res == false) {
        var tblSp =
            TablePhieuNganhLT(iDCoSo: currentIdCoSo, maDTV: AppPref.uid);
        List<TablePhieuNganhLT> tblSps = [];
        tblSps.add(tblSp);

        await phieuNganhLTProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
      }
    } else {
      // if (res) {
      //   phieuNganhLTProvider.deleteByCoSoId(currentIdCoSo!);
      // }
    }
    await getTablePhieuNganhLT();
    return hasC2_56LT;
  }

  bool isA1NganhLT(QuestionCommonModel question, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) {
    return (question.maCauHoi == "A1" &&
        question.maPhieu == AppDefine.maPhieuLT);
  }

  Future tinhTongSoPhongA5LT(QuestionCommonModel question) async {
    int tongSoPhong = 0;
    int tongSoPhongTang = 0;
    int tongSoGuong = 0;
    int tongSoGuongTang = 0;

    var dsChiTieuDong = question.danhSachChiTieuIO;
    if (dsChiTieuDong != null) {
      List<String> soPhongFieldNames = [];
      List<String> soPhongTangFieldNames = [];
      List<String> soGuongFieldNames = [];
      List<String> soGuongTangFieldNames = [];

      for (var chiTieuDong in dsChiTieuDong) {
        var soPhongFieldName =
            '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_3';
        var soPhongTangFieldName =
            '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_4';
        var soGuongFieldName =
            '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_5';
        var soGuongTangFieldName =
            '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_6';
        soPhongFieldNames.add(soPhongFieldName);
        soPhongTangFieldNames.add(soPhongTangFieldName);
        soGuongFieldNames.add(soGuongFieldName);
        soGuongTangFieldNames.add(soGuongTangFieldName);
      }

      ///5.  TỔNG SỐ PHÒNG TẠI 31/12/2025:
      tongSoPhong = await phieuNganhLTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, soPhongFieldNames, "+");

      ///5.1. TỔNG SỐ PHÒNG TĂNG MỚI TRONG NĂM 2025:
      tongSoPhongTang = await phieuNganhLTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, soPhongTangFieldNames, "+");

      /// 6. TỔNG SỐ GIƯỜNG TẠI 31/12/2025:
      tongSoGuong = await phieuNganhLTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, soGuongFieldNames, "+");

      /// 6.1. TỔNG SỐ GIƯỜNG TĂNG MỚI TRONG NĂM 2025:
      tongSoGuongTang = await phieuNganhLTProvider.totalIntByMaCauHoi(
          currentIdCoSo!, soGuongTangFieldNames, "+");
    }

    ///5.  TỔNG SỐ PHÒNG TẠI 31/12/2025:
    await updateAnswerToDB(tablePhieuNganhLT, colPhieuNganhLTA5, tongSoPhong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA5, tongSoPhong, tablePhieuNganhLT);

    ///5.1. TỔNG SỐ PHÒNG TĂNG MỚI TRONG NĂM 2025:
    await updateAnswerToDB(
        tablePhieuNganhLT, colPhieuNganhLTA5_1, tongSoPhongTang);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA5_1, tongSoPhongTang, tablePhieuNganhLT);

    /// 6. TỔNG SỐ GIƯỜNG TẠI 31/12/2025:
    await updateAnswerToDB(tablePhieuNganhLT, colPhieuNganhLTA6, tongSoGuong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA6, tongSoGuong, tablePhieuNganhLT);

    /// 6.1. TỔNG SỐ GIƯỜNG TĂNG MỚI TRONG NĂM 2025:
    await updateAnswerToDB(
        tablePhieuNganhLT, colPhieuNganhLTA6_1, tongSoGuongTang);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA6_1, tongSoGuongTang, tablePhieuNganhLT);
  }

  ///7.TỔNG SỐ LƯỢT KHÁCH CỦA CƠ SỞ BÌNH QUÂN 1 THÁNG NĂM 2025 (=1+2)
  Future tinhTongLuotKhachBQ1Thang() async {
    var a1MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA1_M);
    var a2MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA2_M);
    var a1MLTVal = AppUtils.convertStringToInt(a1MLT);
    var a2MLTVal = AppUtils.convertStringToInt(a2MLT);
    int tong = a1MLTVal + a2MLTVal;
    await updateAnswerToDB(tablePhieuNganhLT, colPhieuNganhLTA7_M, tong);
    await updateAnswerTblPhieuMau(colPhieuNganhLTA7_M, tong, tablePhieuNganhLT);
  }

  ///7.1.TRONG ĐÓ: LƯỢT KHÁCH QUỐC TẾ (1.1+2.1)
  Future tinhTongLuotKhachBQ1ThangQuocTe() async {
    var a1MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA1_1_M);
    var a2MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA2_1_M);
    var a1MLTVal = AppUtils.convertStringToInt(a1MLT);
    var a2MLTVal = AppUtils.convertStringToInt(a2MLT);
    int tong = a1MLTVal + a2MLTVal;
    await updateAnswerToDB(tablePhieuNganhLT, colPhieuNganhLTA7_1_M, tong);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA7_1_M, tong, tablePhieuNganhLT);
  }

  ///8. DOANH THU KHÁCH NGỦ QUA ĐÊM (=CÂU 5.2 CỦA PHIẾU TB x Câu 5)/100)
  Future tinhDoanhThuKhachNguQuaDem() async {
    var totalA5_2 = await phieuMauTBSanPhamProvider.totalA5_2ByMaVcpaCap2(
        currentIdCoSo!, vcpaCap2LT);
    var a5MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA5_M);

    var a5MLTVAl = AppUtils.convertStringAndFixedToDouble(a5MLT);
    var a8MLTVal = (totalA5_2 * a5MLTVAl) / 100;
    if (a8MLTVal > 0) {
      a8MLTVal = AppUtils.roundDouble(a8MLTVal, 2);
    }
    await updateAnswerToDB(tablePhieuNganhLT, colPhieuNganhLTA8_M, a8MLTVal);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA8_M, a8MLTVal, tablePhieuNganhLT);
  }

  Future tinhDoanhThuKhachKhongNguQuaDem() async {
    var totalA5_2 = await phieuMauTBSanPhamProvider.totalA5_2ByMaVcpaCap2(
        currentIdCoSo!, vcpaCap2LT);
    var a8MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA8_M);

    var a8MLTVal = AppUtils.convertStringAndFixedToDouble(a8MLT);
    var a9MLTVal = totalA5_2 - a8MLTVal;
    if (a8MLTVal > 0) {
      a8MLTVal = AppUtils.roundDouble(a8MLTVal, 2);
    }
    await updateAnswerToDB(tablePhieuNganhLT, colPhieuNganhLTA9_M, a9MLTVal);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA9_M, a9MLTVal, tablePhieuNganhLT);
  }

  ///10. SỐ NGÀY KHÁCH DO CƠ SỞ LƯU TRÚ PHỤC VỤ =(8/6)
  Future soNgayKhachDoCsPhucVu() async {
    var a6MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA6_M);
    var a8MLT = getValueByFieldName(tablePhieuNganhLT, colPhieuNganhLTA8_M);
    var a6MLTVal = AppUtils.convertStringAndFixedToDouble(a6MLT);
    var a8MLTVal = AppUtils.convertStringAndFixedToDouble(a8MLT);

    if (a6MLT > 0 && a8MLTVal > 0) {
      var a10MLTVal = a8MLTVal / a6MLTVal;
      a10MLTVal = AppUtils.roundDouble(a10MLTVal, 2);
      await updateAnswerToDB(
          tablePhieuNganhLT, colPhieuNganhLTA10_M, a10MLTVal);
      await updateAnswerTblPhieuMau(
          colPhieuNganhLTA10_M, a10MLTVal, tablePhieuNganhLT);
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
        currentIdCoSo!, vcpaCap2LT);
    //Tinh cho cau A8 (cũ A7_10)
    //8. DOANH THU KHÁCH NGỦ QUA ĐÊM (=CÂU 5.2 CỦA PHIẾU TB x Câu 5)/100)
    var totalA8M = (a8MValue * totalA5_2) / 100;
    if (totalA8M > 0) {
      totalA8M = AppUtils.roundDouble(totalA8M, 2);
    }

    // colPhieuNganhLTA8_M <=> var fieldNameTotalA7_10 = "A7_10";
    await phieuNganhLTProvider.updateValueByIdCoSo(
        colPhieuNganhLTA8_M, totalA8M, currentIdCoSo);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA8_M, totalA8M, tablePhieuNganhLT);
    //Tính cho câu A9_M <=> A7_11
    //9. DOANH THU KHÁCH KHÔNG NGỦ QUA ĐÊM (= CÂU 5.2 CỦA PHIẾU TB - câu 8)
    var totalA9M = totalA5_2 - totalA8M;

    if (totalA9M > 0) {
      totalA9M = AppUtils.roundDouble(totalA9M, 2);
    }

    await phieuNganhLTProvider.updateValueByIdCoSo(
        colPhieuNganhLTA9_M!, totalA9M, currentIdCoSo);
    await updateAnswerTblPhieuMau(
        colPhieuNganhLTA9_M, totalA9M, tablePhieuNganhLT);
  }

  ///A10_M <=> A7_13
  tinhUpdateA10M(a6MValue) async {
    var a10MValue =
        getValueByFieldName(tablePhieuMauTB, colPhieuNganhLTA10_M) ?? 0;

    var a6MVal = a6MValue ?? 0;
    if (a10MValue >= 0 && a6MVal >= 0) {
      var a10M = a10MValue / a6MVal;
      await phieuNganhLTProvider.updateValueByIdCoSo(
          colPhieuNganhLTA10_M, a10M, currentIdCoSo);
      await updateAnswerTblPhieuMau(
          colPhieuNganhLTA10_M, a10M, tablePhieuNganhLT);
    }
  }
/*****END::NGANH LT********/

  /// ***BEGIN::NGANH TM*******
  Future<(bool, bool)> updateDataNganhTM() async {
    var has5G8610TM = await hasAll_5G_L6810();
    var hasC2_56TM = await hasAllCap2_56TM();

    if ((has5G8610TM)) {
      await insertUpdateNganhTMSanpham();
    }

    if ((hasC2_56TM || (has5G8610TM))) {
      var res = await phieuNganhTMProvider.isExistQuestion(currentIdCoSo!);
      if (res == false) {
        var tblSp =
            TablePhieuNganhTM(iDCoSo: currentIdCoSo, maDTV: AppPref.uid);
        List<TablePhieuNganhTM> tblTMs = [];
        tblTMs.add(tblSp);

        await phieuNganhTMProvider.insert(tblTMs, AppPref.dateTimeSaveDB!);
      }
    }
    await getTablePhieuNganhTM();
    await getTablePhieuMauTBSanPham();
    return (has5G8610TM, hasC2_56TM);
  }

  insertUpdateNganhTMSanpham() async {
    var has5G8610TM = await hasAll_5G_L6810();
    if ((has5G8610TM)) {
      var arrG_C5 = maVcpaLoaiTruG_C5.split(';');
      var arrG_C4 = maVcpaLoaiTruG_C4.split(';');
      var arrG_C3 = maVcpaLoaiTruG_C3.split(';');
      //Lấy các sản phẩm là cấp 5 thuộc G,L 8610 từ bảng PhieuMauTBSanPham;
      var resMaSPs =
          await phieuMauTBSanPhamProvider.getMaSanPhamsByIdCoso(currentIdCoSo!);
      if (resMaSPs.isNotEmpty) {
        var spG8610s = await dmMotaSanphamProvider.getSanPhamBy_5G_L6810(
            resMaSPs.join(';'), arrG_C3, arrG_C4, arrG_C5, maVcpaL6810);
        if (spG8610s.isNotEmpty) {
          var sanPhams = await phieuMauTBSanPhamProvider
              .getMaSanPhamsByIdCosoSps(currentIdCoSo!, spG8610s.join(';'));
          //
          if (sanPhams.isNotEmpty) {
            var res = await phieuNganhTMSanphamProvider
                .selectCap1GL8610ByIdCoSo(currentIdCoSo!, sanPhams);
            if (res.isNotEmpty) {
              var currentSp = TablePhieuNganhTMSanPham.fromListJson(res);
              if (currentSp != null && currentSp.isNotEmpty) {
                await phieuNganhTMSanphamProvider
                    .deleteByCoSoId(currentIdCoSo!);
                await phieuNganhTMSanphamProvider.insert(
                    currentSp, AppPref.dateTimeSaveDB!);
              }
            }
          }
        }
      }
    }
  }

  ///"1T. TRỊ GIÁ VỐN HÀNG BÁN (TỔNG CÂU 1 * CÂU 4.1- PHIẾU TB)"
  Future<double> tinhTongTriGiaVonCau1TNganhTM() async {
    double result = 0.0;
    int a4_1TBValue = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA4_1);
    double tong =
        await phieuNganhTMSanphamProvider.tongTriGiaVonCau1T(currentIdCoSo!);
    if (a4_1TBValue != null && a4_1TBValue >= 0) {
      result = tong * a4_1TBValue;
    }
    await phieuNganhTMProvider.updateValueByIdCoSo(
        colPhieuNganhTMA1T, result, currentIdCoSo!);
    await getTablePhieuNganhTM();
    await getTablePhieuNganhTMSanPham();
    return result;
  }

  ///"3T. TRỊ GIÁ VỐN HÀNG CHUYỂN BÁN  (CÂU 3 *CÂU 4.1 - PHIẾU TB)"
  Future<double> tinhTongTriGiaVonCau3TNganhTM() async {
    double result = 0.0;
    int a4_1TBValue = getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA4_1);
    var a3TMValue = getValueByFieldName(tablePhieuNganhTM, colPhieuNganhTMA3);
    double a3TMVal = 0.0;
    if (a3TMValue != null) {
      a3TMVal = AppUtils.convertStringToDouble(a3TMValue);
    }
    if (a4_1TBValue != null &&
        a4_1TBValue >= 0 &&
        a3TMValue != null &&
        a3TMValue >= 0) {
      result = a4_1TBValue * a3TMVal;
    }
    await phieuNganhTMProvider.updateValueByIdCoSo(
        colPhieuNganhTMA3T, result, currentIdCoSo!);
    await getTablePhieuNganhTM();
    return result;
  }

  // totalA3TNganhtTM() async {
  //   var a4_1Value = answerTblPhieuMau['A4_1'];
  //   var a4_1Val = 0.0;
  //   if (a4_1Value != null) {
  //     a4_1Val = AppUtils.convertStringToDouble(a4_1Value);
  //   }

  //   var a3Value =
  //       getValueByFieldNameFromDB(tablePhieuNganhTM, colPhieuNganhTMA3);

  //   var a3Val = 0.0;
  //   if (a3Value != null) {
  //     a3Val = AppUtils.convertStringToDouble(a3Value);
  //   }
  //   var total = a3Val * a4_1Val;

  //   return total;
  // }

/*****BEGIN::NGANH TM********/
  ///
/***********/

  ///END::PHẦN
/***********/

  Future tongDoanhThuSanPhamTM() async {
    tongDoanhThuSanPhamNganhTM.value = 0.0;

    var res =
        await phieuNganhTMSanphamProvider.tongDoanhThuSanPhamTM(currentIdCoSo!);
    tongDoanhThuSanPhamNganhTM.value = res;

    var resC1Total =
        await phieuNganhTMSanphamProvider.tongTriGiaVonCau1T(currentIdCoSo!);
    tongTienVonBoRaC1TM.value = resC1Total;
  }

  Future tinhDoanhThuNganhVTHK() async {
    doanhThuNganhVTHK.value = 0.0;
    var res = await phieuMauTBSanPhamProvider.doanhThuNganh(
        currentIdCoSo!, 'VTHK', vcpaCap5VanTaiHanhKhach);
    doanhThuNganhVTHK.value = res;
  }

  Future tinhDoanhThuNganhVTHH() async {
    doanhThuNganhVTHH.value = 0.0;
    var res = await phieuMauTBSanPhamProvider.doanhThuNganh(
        currentIdCoSo!, 'VTHH', vcpaCap5VanTaiHangHoa);
    doanhThuNganhVTHH.value = res;
  }

  Future tinhDoanhThuNganhLT() async {
    doanhThuNganhLT.value = 0.0;
    var res = await phieuMauTBSanPhamProvider.doanhThuNganh(
        currentIdCoSo!, 'LT', vcpaCap2LT);
    doanhThuNganhLT.value = res;
  }

  ///C1_Khối lượng tiêu dùng tất cả năng lượng mã 1+11 (ngoại trừ các mã trong đó)=0;
  Future tongKhoiLuongNangLuong() async {
    tongKhoiLuongTieuDungNangLuong.value = 0.0;
    List<String> fieldNames = [];
    if (dsChiTieuDongA6_1TB.isNotEmpty) {
      for (var ct in dsChiTieuDongA6_1TB) {
        var fName2 = 'A6_1_${ct.maSo!}_2';
        fieldNames.add(fName2);
      }
    }
    var total = await phieuMauTBProvider.totalDoubleByMaCauHoi(
        currentIdCoSo!, fieldNames);
    tongKhoiLuongTieuDungNangLuong.value = total;
  }

  Future tongDoanhThuTatcaSanPhamA5_2() async {
    tongDoanhThuTatCaSanPham.value = 0.0;
    var total =
        await phieuMauTBProvider.tongDoanhThuTatCaSanPham(currentIdCoSo!);
    tongDoanhThuTatCaSanPham.value = total;
  }

  Future getMaNganhCN10To39() async {
    hasMaNganhCN10T039.value = [];
    var res = await phieuNganhCNProvider.getMaNganhCN10To39(currentIdCoSo!);
    if (res.isNotEmpty) {
      hasMaNganhCN10T039.addAll(res);
    }
  }

  // Future getMaNganhVTHK() async {
  //   hasMaNganhVTHK.value = [];
  //   if (tblPhieuMauTBSanPhamVTHanhKhach.isEmpty) {
  //     await getMaSanPhamNganhVT(vcpaCap5VanTaiHanhKhach);
  //   }

  //   if (tblPhieuMauTBSanPhamVTHanhKhach.isNotEmpty) {
  //     List<String> res =
  //         tblPhieuMauTBSanPhamVTHanhKhach.map((x) => x.a5_1_2!).toList();
  //     hasMaNganhVTHK.addAll(res);
  //   }
  // }

  // Future getMaNganhVTHH() async {
  //   hasMaNganhVTHH.value = [];
  //   if (tblPhieuMauTBSanPhamVTHangHoa.isEmpty) {
  //     await getMaSanPhamNganhVT(vcpaCap5VanTaiHangHoa);
  //   }
  //   if (tblPhieuMauTBSanPhamVTHangHoa.isNotEmpty) {
  //     List<String> res =
  //         tblPhieuMauTBSanPhamVTHangHoa.map((x) => x.a5_1_2!).toList();
  //     hasMaNganhVTHH.addAll(res);
  //   }
  // }
/************/

  Future<List<ChiTieuDongModel>> getLoaiNangLuongA6_1() async {
    List<ChiTieuDongModel> result = [];
    var a6_1Res = await phieuMauTBProvider.selectA6_1ByIdCoSo(currentIdCoSo!);
    if (a6_1Res.isNotEmpty) {
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      dynamic question07 = tableData.toCauHoiPhieu07(currentMaDoiTuongDT!);

      List<QuestionCommonModel> questionsTemp =
          QuestionCommonModel.listFromJson(jsonDecode(question07));
      List<QuestionCommonModel> questionsTemp2 = [];
      if (questionsTemp.isNotEmpty) {
        questionsTemp2.addAll(questionsTemp);

        questionsTemp2.retainWhere((x) {
          return (x.maPhieu == AppDefine.maPhieuTB && x.maCauHoi == 'A_VI');
        });
        if (questionsTemp2.isNotEmpty) {
          var a = questionsTemp2.firstOrNull;
          if (a != null) {
            if (a.danhSachCauHoiCon != null) {
              var b = a.danhSachCauHoiCon!;
              b.retainWhere((x) {
                return (x.maPhieu == AppDefine.maPhieuTB &&
                    x.maCauHoi == 'A6_1');
              });
              if (b.isNotEmpty) {
                var dsCT = b.firstOrNull?.danhSachChiTieuIO;
                if (dsCT != null && dsCT.isNotEmpty) {
                  var c = dsCT.where((x) => a6_1Res.contains(x.maSo)).toList();
                  if (c != null && c.isNotEmpty) {
                    result.addAll(c);
                    // var d = c.map((ctDong) => ctDong.tenChiTieu).toList();
                    // if(d!=null && d.isNotEmpty){
                    //   result=d.join(',');
                    // }
                  }
                }
              }
            }
          }
        }
      }
    }
    dsChiTieuDongA6_1TB.assignAll(result);
    return result;
  }

  Future<String> generateMessageV2(
      String? mucCauHoi, String? validResultMessage,
      {int? loaiCauHoi, String? maCauHoi}) async {
    String result = '';

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

  ///
  ///BEGIN::Tạo danh sách gồm các trường: ManHinh,MaCauHoi,TenTruong,...
  ///Mục đích: Dùng để lấy trường cho việc validate ở mỗi màn hình khi nhấn nút tiếp tục
  ///Danh sách trường này có thể chuyển qua lấy ở server ở chức năng lấy dữ liệu phỏng vấn.
  Future<List<QuestionFieldModel>> getListFieldToValidate() async {
    List<QuestionFieldModel> result = [];
    if (questions.isNotEmpty) {
      for (var item in questions) {
        QuestionFieldModel questionField = QuestionFieldModel(
            maPhieu: item.maPhieu,
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
              maPhieu: item.maPhieu,
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

        if (item.danhSachCauHoiCon != null &&
            item.danhSachCauHoiCon!.isNotEmpty) {
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
            maPhieu: item.maPhieu,
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
              maPhieu: item.maPhieu,
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
        if (item.danhSachCauHoiCon != null &&
            item.danhSachCauHoiCon!.isNotEmpty) {
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
              maPhieu: ctItem.maPhieu,
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
                  maPhieu: questionModel.maPhieu,
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
                    maPhieu: questionModel.maPhieu,
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

/***********/

  getSubTextByMaCauHoi(QuestionCommonModel question) {
    String result = '';
    if (question.bangDuLieu == tablePhieuMauTB) {
    } else if (question.bangDuLieu == tablePhieuMauTBSanPham) {
    } else if (question.bangDuLieu == tablePhieuNganhCN) {
    } else if (question.bangDuLieu == tablePhieuNganhVT) {
      if ((question.maCauHoi == "A_I_0" &&
              question.maPhieu == AppDefine.maPhieuVT) ||
          (question.maCauHoi == "A_I_M_0" &&
              question.maPhieu == AppDefine.maPhieuVTMau)) {
        // if (tblPhieuMauTBSanPhamVTHanhKhach.isEmpty) {
        //     getMaSanPhamNganhVT(vcpaCap5VanTaiHanhKhach).then((data){});
        // }
        if (tblPhieuMauTBSanPhamVTHanhKhach.isNotEmpty) {
          result = tblPhieuMauTBSanPhamVTHanhKhach
              .map((p) => p.a5_1_1!)
              .toList()
              .join('; ');
          return result;
        }
      } else if ((question.maCauHoi == "A_7" &&
              question.maPhieu == AppDefine.maPhieuVT) ||
          (question.maCauHoi == "A_II_M_0" &&
              question.maPhieu == AppDefine.maPhieuVTMau)) {
        // if (tblPhieuMauTBSanPhamVTHangHoa.isEmpty) {
        //   await getMaSanPhamNganhVT(vcpaCap5VanTaiHangHoa);
        // }
        if (tblPhieuMauTBSanPhamVTHangHoa.isNotEmpty) {
          result = tblPhieuMauTBSanPhamVTHangHoa
              .map((p) => p.a5_1_1!)
              .toList()
              .join('; ');
          return result;
        }
      }
    } else if (question.bangDuLieu == tablePhieuNganhLT) {
      if ((question.maCauHoi == "A_I_0" &&
              question.maPhieu == AppDefine.maPhieuLT) ||
          (question.maCauHoi == "A_I_M_0" &&
              question.maPhieu == AppDefine.maPhieuLTMau)) {
        // if (tblPhieuMauTBSanPhamLT.isEmpty) {
        //   getMaSanPhamNganhLT(vcpaCap2LT).then((data){});
        // }
        if (tblPhieuMauTBSanPhamLT.isNotEmpty) {
          result =
              tblPhieuMauTBSanPhamLT.map((p) => p.a5_1_1!).toList().join('; ');
          return result;
        }
      }
    } else if (question.bangDuLieu == tablePhieuNganhTM) {
    } else if (question.bangDuLieu == tablePhieuNganhTMSanPham) {}
    return result;
  }

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
