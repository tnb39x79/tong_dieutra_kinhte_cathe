import 'dart:convert';
import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/data_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_xacnhan_logic.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/question.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/question_group.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/dm_common_model.dart';

mixin QuestionUtils {
  ///Lấy danh sách nhóm câu hỏi có trên màn hình để hiển thị lên sidebar
  Future<List<QuestionGroup>> getQuestionGroups(
      String maDoiTuongDT, String idCoSo) async {
    List<QuestionGroup> questionGroups = [];
    try {
      final dataProvider = DataProvider();
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      dynamic question;
      if (AppDefine.maDoiTuongDT_07Mau.toString() == maDoiTuongDT) {
        question = tableData.toCauHoiPhieu07Mau();
      } else if (AppDefine.maDoiTuongDT_07TB.toString() == maDoiTuongDT) {
        question = tableData.toCauHoiPhieu07TB();
      } else if (AppDefine.maDoiTuongDT_08.toString() == maDoiTuongDT) {
        question = tableData.toCauHoiPhieu08();
      }
      List<QuestionCommonModel> questionsTemp =
          QuestionCommonModel.listFromJson(jsonDecode(question));
      List<QuestionCommonModel> questionsTemp2 = [];
      if (questionsTemp.isNotEmpty) {
        questionsTemp2.addAll(questionsTemp);
        questionGroups.clear();
        List<int> manHinhs = [];

        for (var item in questionsTemp2) {
          manHinhs.add(item.manHinh!);
        }
        int i = 1;
        for (var item in manHinhs) {
          var questionInManHinh =
              questionsTemp2.where((x) => x.manHinh == item).toList();

          if (questionInManHinh.isNotEmpty) {
            for (var qItem in questionInManHinh) {
              if (qItem.danhSachCauHoiCon!.isNotEmpty) {
                var secondItem = qItem.danhSachCauHoiCon!.first;
                if (secondItem.maSo == null || secondItem.maSo == '') {
                  if (secondItem.danhSachCauHoiCon != null &&
                      secondItem.danhSachCauHoiCon!.isNotEmpty) {
                    secondItem = secondItem.danhSachCauHoiCon!.first;
                  }
                }
                var lastItem = qItem.danhSachCauHoiCon!.last;
                if (lastItem.maSo == null || lastItem.maSo == '') {
                  if (lastItem.danhSachCauHoiCon != null &&
                      lastItem.danhSachCauHoiCon!.isNotEmpty) {
                    lastItem = lastItem.danhSachCauHoiCon!.first;
                  }
                }
                var questionGroup = QuestionGroup(
                    id: i,
                    manHinh: item,
                    tenNhomCauHoi: 'Nhóm $i',
                    fromQuestion: secondItem.maSo,
                    toQuestion:
                        lastItem.maSo == secondItem.maSo ? '' : lastItem.maSo,
                    isSelected: false,
                    enable: false);
                questionGroups.add(questionGroup);
                ++i;
              } else {
                var questionGroup = QuestionGroup(
                    id: i,
                    manHinh: item,
                    tenNhomCauHoi: 'Nhóm $i',
                    fromQuestion: qItem.maCauHoi,
                    toQuestion: '',
                    isSelected: false,
                    enable: false);
                questionGroups.add(questionGroup);
                ++i;
              }
            }
          }
        }
      }
    } catch (e) {
      log('ERROR lấy danh sách nhóm câu hỏi: $e');
      return [];
    }

    List<QuestionGroup> questionGroupsFinal = [];
    if (questionGroups.isNotEmpty) {
      final xacNhanLogicProvider = XacNhanLogicProvider();
      var xnLogics = await xacNhanLogicProvider.selectByIdDoiTuongDT(
          maDoiTuongDT: maDoiTuongDT, idDoiTuongDT: idCoSo);
      var tblXacNhans = TableXacnhanLogic.listFromJson(xnLogics);
      if (tblXacNhans.isNotEmpty) {
        for (var item in questionGroups) {
          for (var xn in tblXacNhans) {
            if (item.manHinh == xn.manHinh) {
              item.enable = xn.isEnableMenuItem == 1;
            }
          }
          questionGroupsFinal.add(item);
        }
        return questionGroupsFinal;
      }
    }
    return questionGroups;
  }

  Future<List<QuestionGroup>> updateXacNhanLogicByMaTrangThaiDT(
      List<QuestionGroup> questionGroups,
      int maDoiTuongDT,
      String idCoSoIdHo,
      int maTrangThaiDT,
      {String? noiDungLogic}) async {
    if (questionGroups.isNotEmpty) {
      for (var item in questionGroups) {
        await insertUpdateXacNhanLogic(item.manHinh!, idCoSoIdHo, maDoiTuongDT,
            1, 1, noiDungLogic ?? '', maTrangThaiDT);
        item.enable = true;
      }
    }
    return questionGroups;
  }

  Future insertUpdateXacNhanLogic(
      int manHinh,
      String idCoSoIdHo,
      int maDoiTuongDT,
      int isLogic,
      int isEnableMenuItem,
      String? noiDungLogic,
      int maTrangThaiDT) async {
    final xacNhanLogicProvider = XacNhanLogicProvider();
    TableXacnhanLogic value = TableXacnhanLogic(
        maDTV: AppPref.uid,
        manHinh: manHinh,
        idDoiTuong: idCoSoIdHo,
        maDoiTuongDT: maDoiTuongDT,
        isLogic: isLogic,
        isEnableMenuItem: isEnableMenuItem,
        noiDungLogic: noiDungLogic,
        maTrangThaiDT: maTrangThaiDT);
    return xacNhanLogicProvider.insertUpdate(value);
  }

  Future insertUpdateXacNhanLogicWithoutEnable(
      int manHinh,
      String idCoSoIdHo,
      int maDoiTuongDT,
      int isLogic,
      String? noiDungLogic,
      int maTrangThaiDT) async {
    final xacNhanLogicProvider = XacNhanLogicProvider();
    TableXacnhanLogic value = TableXacnhanLogic(
        maDTV: AppPref.uid,
        manHinh: manHinh,
        idDoiTuong: idCoSoIdHo,
        maDoiTuongDT: maDoiTuongDT,
        isLogic: isLogic,
        noiDungLogic: noiDungLogic,
        maTrangThaiDT: maTrangThaiDT);
    return xacNhanLogicProvider.insertUpdate(value, isUpdateEnable: false);
  }

  Future<List<QuestionCommonModel>> getQuestionContentFilterByVcpa(
      List<QuestionCommonModel> questions,
      int currentScreenNo,
      bool hasPhanVI,
      bool hasPhanVIHanhKhach,
      bool hasPhanVIHangHoa,
      bool hasPhanVII) async {
    List<QuestionCommonModel> result = [];

    if (currentScreenNo == 6) {
      if ((hasPhanVI && hasPhanVIHanhKhach) ||
          (hasPhanVI && hasPhanVIHangHoa)) {
        for (var item in questions) {
          if (item.manHinh == 6) {
            List<QuestionCommonModel> conHoiCons = [];
            QuestionCommonModel qItem = QuestionCommonModel(
                maPhieu: item.maPhieu,
                maCauHoi: item.maCauHoi,
                manHinh: item.manHinh,
                maCauHoiCha: item.maCauHoiCha,
                tenCauHoi: item.tenCauHoi,
                sTT: item.sTT,
                hienThi: item.hienThi,
                cap: item.cap,
                maSo: item.maSo,
                dVT: item.dVT,
                loaiCauHoi: item.loaiCauHoi,
                bangChiTieu: item.bangChiTieu,
                loaiCanhBao: item.loaiCanhBao,
                buocNhay: item.buocNhay,
                giaTriNN: item.giaTriNN,
                giaTriLN: item.giaTriLN,
                bangDuLieu: item.bangDuLieu,
                giaiThich: item.giaiThich,
                danhSachCauHoiCon: [],
                danhSachChiTieu: item.danhSachChiTieu,
                danhSachChiTieuIO: item.danhSachChiTieuIO);
            if (item.danhSachCauHoiCon != null &&
                item.danhSachCauHoiCon!.isNotEmpty) {
              conHoiCons = await getCauHoiConFilterVCPA(item.danhSachCauHoiCon!,
                  hasPhanVIHanhKhach, hasPhanVIHangHoa);
              if (conHoiCons.isNotEmpty) {
                qItem.danhSachCauHoiCon = conHoiCons;
              }
            }
            result.add(qItem);
          }
        }
      }
    } else if (currentScreenNo == 7) {
      List<QuestionCommonModel> qTmp7 = [];
      for (var item in questions) {
        if (item.manHinh == 7) {
          if (hasPhanVII == true) {
            result.add(item);
          }
        } else {
          result.add(item);
        }
      }
    }
    return result;
  }

  Future<List<QuestionCommonModel>> getCauHoiConFilterVCPA(
      List<QuestionCommonModel> questionModels,
      bool hasPhanVIHanhKhach,
      bool hasPhanVIHangHoa) async {
    try {
      List<QuestionCommonModel> result = [];
      for (var item in questionModels) {
        if ((hasPhanVIHanhKhach &&
            (item.maCauHoi == "A6_0" ||
                (item.maCauHoiCha == "A6_0" || item.maCauHoiCha == "A6_1")))) {
          List<QuestionCommonModel> conHoiCons = [];
          QuestionCommonModel qItem = QuestionCommonModel(
              maPhieu: item.maPhieu,
              maCauHoi: item.maCauHoi,
              manHinh: item.manHinh,
              maCauHoiCha: item.maCauHoiCha,
              tenCauHoi: item.tenCauHoi,
              sTT: item.sTT,
              hienThi: item.hienThi,
              cap: item.cap,
              maSo: item.maSo,
              dVT: item.dVT,
              loaiCauHoi: item.loaiCauHoi,
              bangChiTieu: item.bangChiTieu,
              loaiCanhBao: item.loaiCanhBao,
              buocNhay: item.buocNhay,
              giaTriNN: item.giaTriNN,
              giaTriLN: item.giaTriLN,
              bangDuLieu: item.bangDuLieu,
              giaiThich: item.giaiThich,
              danhSachCauHoiCon: [],
              danhSachChiTieu: item.danhSachChiTieu,
              danhSachChiTieuIO: item.danhSachChiTieuIO);
          if (item.danhSachCauHoiCon!.isNotEmpty) {
            conHoiCons = await getCauHoiConFilterVCPA(
                item.danhSachCauHoiCon!, hasPhanVIHanhKhach, hasPhanVIHangHoa);
            if (conHoiCons.isNotEmpty) {
              qItem.danhSachCauHoiCon = conHoiCons;
            }
          }
          result.add(qItem);
        } else if (hasPhanVIHangHoa &&
            (item.maCauHoi == "A6_00" || item.maCauHoiCha == "A6_00")) {
          List<QuestionCommonModel> conHoiCons = [];
          QuestionCommonModel qItem = QuestionCommonModel(
              maPhieu: item.maPhieu,
              maCauHoi: item.maCauHoi,
              manHinh: item.manHinh,
              maCauHoiCha: item.maCauHoiCha,
              tenCauHoi: item.tenCauHoi,
              sTT: item.sTT,
              hienThi: item.hienThi,
              cap: item.cap,
              maSo: item.maSo,
              dVT: item.dVT,
              loaiCauHoi: item.loaiCauHoi,
              bangChiTieu: item.bangChiTieu,
              loaiCanhBao: item.loaiCanhBao,
              buocNhay: item.buocNhay,
              giaTriNN: item.giaTriNN,
              giaTriLN: item.giaTriLN,
              bangDuLieu: item.bangDuLieu,
              giaiThich: item.giaiThich,
              danhSachCauHoiCon: [],
              danhSachChiTieu: item.danhSachChiTieu,
              danhSachChiTieuIO: item.danhSachChiTieuIO);
          if (item.danhSachCauHoiCon!.isNotEmpty) {
            conHoiCons = await getCauHoiConFilterVCPA(
                item.danhSachCauHoiCon!, hasPhanVIHanhKhach, hasPhanVIHangHoa);
            if (conHoiCons.isNotEmpty) {
              qItem.danhSachCauHoiCon = conHoiCons;
            }
          }
          result.add(qItem);
        } else if (item.maCauHoi != "A6_0" &&
            (item.maCauHoiCha != "A6_0" && item.maCauHoiCha != "A6_1") &&
            (item.maCauHoi != "A6_00" && item.maCauHoiCha != "A6_00")) {
          List<QuestionCommonModel> conHoiCons = [];
          QuestionCommonModel qItem = QuestionCommonModel(
              maPhieu: item.maPhieu,
              maCauHoi: item.maCauHoi,
              manHinh: item.manHinh,
              maCauHoiCha: item.maCauHoiCha,
              tenCauHoi: item.tenCauHoi,
              sTT: item.sTT,
              hienThi: item.hienThi,
              cap: item.cap,
              maSo: item.maSo,
              dVT: item.dVT,
              loaiCauHoi: item.loaiCauHoi,
              bangChiTieu: item.bangChiTieu,
              loaiCanhBao: item.loaiCanhBao,
              buocNhay: item.buocNhay,
              giaTriNN: item.giaTriNN,
              giaTriLN: item.giaTriLN,
              bangDuLieu: item.bangDuLieu,
              giaiThich: item.giaiThich,
              danhSachCauHoiCon: [],
              danhSachChiTieu: item.danhSachChiTieu,
              danhSachChiTieuIO: item.danhSachChiTieuIO);
          if (item.danhSachCauHoiCon!.isNotEmpty) {
            conHoiCons = await getCauHoiConFilterVCPA(
                item.danhSachCauHoiCon!, hasPhanVIHanhKhach, hasPhanVIHangHoa);
            if (conHoiCons.isNotEmpty) {
              qItem.danhSachCauHoiCon = conHoiCons;
            }
          }
          result.add(qItem);
        }
      }
      return result;
    } catch (e) {
      log('ERROR getCauHoiConFilterVCPA lấy danh sách câu hỏi phiếu lọc theo mã IO: $e');
      return [];
    }
  }

  validateNotEmptyString(String? value) {
    return value != null && value != '' && value != 'null';
  }

  validateEmptyString(String? value) {
    return value == null || value == "" || value == "null";
  }

  validate0InputValue(inputValue) {
    return inputValue == '0' ||
        inputValue == '0.0' ||
        inputValue == '0.00' ||
        inputValue == 0 ||
        inputValue == 0.0;
  }

  List<SearchTypeModel> getSearchType() {
    List<SearchTypeModel> result = [];
    SearchTypeModel cmDm = SearchTypeModel(ma: 1, ten: 'Tìm kiếm trong danh mục',selected: false);
    SearchTypeModel cmAI = SearchTypeModel(ma: 2, ten: 'Tìm kiếm bằng AI',selected: false);
    result.add(cmDm);
    result.add(cmAI);
    return result;
  }
}
