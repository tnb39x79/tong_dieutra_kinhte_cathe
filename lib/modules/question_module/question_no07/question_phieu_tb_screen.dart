import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/formatter_utils.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/money_input_enums.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/appbars/appbar_customize.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/search_dantoc.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/search_vcpa_cap5.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/question/input_int%20view.dart';

import 'package:gov_statistics_investigation_economic/common/widgets/question/input_string.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/question/select_int.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/question/text_string.dart';

import 'package:gov_statistics_investigation_economic/common/widgets/sidebar/sidebar.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/widgets.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/input_string_chitieu_ct.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/input_string_ct_dm.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/input_string_vcpa.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/new_yes_no_question.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/select_int_ct_dm.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/select_mutil_int_dm.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/select_string_ct_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_diadiem_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/model/model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/danh_dau_sanpham_model.dart';

import 'question_phieu_tb_controller.dart';

class QuestionPhieuTBScreen extends GetView<QuestionPhieuTBController> {
  const QuestionPhieuTBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: GestureDetector(
        onTap: () => controller.unFocus(context),
        child: Scaffold(
          key: controller.scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
            title: '${controller.currentTenDoiTuongDT!}',
            questionCode: 4,
            onPressedLeading: () => {},
            subTitle: controller.subTitleBar,
            iconLeading: IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            actions: IconButton(
                onPressed: controller.onOpenDrawerQuestionGroup,
                icon: const Icon(Icons.menu_rounded)),
            backAction: controller.onBackStart,
            wTitle: Obx(() => appBarTitle()),
          ),
          body: _buildBody(),
          drawer: SideBar(
              controller.questionGroupList,
              drawerTitle: controller.silderTitleBar,
              controller.onMenuPress,
              hasNganhVT: ((controller.isCap1H_VT.value &&
                      controller.isCap5VanTaiHangHoa.value) ||
                  (controller.isCap1H_VT.value &&
                      controller.isCap5VanTaiHanhKhach.value)),
              hasNganhLT: controller.isCap2_55LT.value),
        ),
      ),
    );
  }

  Widget appBarTitle() {
    var t =
        '${controller.currentTenPhieu.value != null && controller.currentTenPhieu.value != '' ? controller.currentTenPhieu.value : controller.currentTenDoiTuongDT} ';
    t = '$t (${controller.currentScreenNo})';
    return (controller.subTitleBar == null || controller.subTitleBar == "")
        ? Text(t, style: styleMediumBold)
        : ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            title: Text(
              t,
              style: styleMediumBoldAppBarHeader,
              textAlign: TextAlign.left,
            ),
            subtitle: Text(controller.subTitleBar,
                style: const TextStyle(color: Colors.white)),
            titleAlignment: ListTileTitleAlignment.center,
          );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(
              AppValues.padding, 0, AppValues.padding, AppValues.padding),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - kToolbarHeight,
              ),
              child: Obx(() {
                if (controller.questions.isEmpty) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                child: WidgetButtonPrevious(
                                    onPressed: controller.onBack)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: WidgetButtonNext(
                                    onPressed: controller.onNext)),
                          ],
                        )
                      ]);
                }
                return Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildQuestionByManHinh(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: WidgetButtonPrevious(
                                onPressed: controller.onBack)),
                        const SizedBox(width: 16),
                        Expanded(
                            child:
                                WidgetButtonNext(onPressed: controller.onNext)),
                      ],
                    )
                  ],
                );
              })),
        );
      },
    );
  }

  buildQuestionByManHinh() {
    return ListView.builder(
      itemCount: controller.questions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        final _question = controller.questions[index];
        return buildQuestionByManHinhItem(_question);
      },
    );
  }

  buildQuestionByManHinhItem(QuestionCommonModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(question.tenCauHoi ?? '',
            level: question.cap!, notes: question.giaiThich ?? ''),
        // const SizedBox(height: 50),
        if (question.maCauHoi == "A_V")
          buildPhanV(question)
        // else if (question.maCauHoi == "A_I" && question.maPhieu == 1)
        //   // RichTextQuestion(question.tenCauHoi ?? '',
        //   //     level: question.cap!, notes: question.giaiThich ?? '')

        //   buildNganhCN(question)
        // else if (question.maCauHoi == "A_I" && question.maPhieu == 4)
        //   buildNganhTM(question)
        //else  if (question.maCauHoi == "A1" && question.maPhieu==4)
        //   buildPhanV(question)
        else
          _buildQuestion(question),
      ],
    );
  }

  _buildQuestion(QuestionCommonModel mainQuestion) {
    if (mainQuestion.loaiCauHoi == 0 && mainQuestion.bangChiTieu == '2') {
      List<QuestionCommonModel> questionsCon = mainQuestion.danhSachCauHoiCon!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuestionChiTieuDongCot(mainQuestion),
          ListView.builder(
              itemCount: questionsCon.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                QuestionCommonModel question = questionsCon[index];
                return _questionItem(question, parentQuestion: mainQuestion);
              })
        ],
      );
    } else if (mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionsCon = mainQuestion.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questionsCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel question = questionsCon[index];
            return _questionItem(question, parentQuestion: mainQuestion);
          });
    } else {
      if (mainQuestion.loaiCauHoi == 0 && mainQuestion.bangChiTieu == '2') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildQuestionChiTieuDongCot(mainQuestion)],
        );
      }
    }
    return const SizedBox();
  }

  _buildQuestion2(QuestionCommonModel question,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questions = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel question = questions[index];

            switch (question.loaiCauHoi) {
              case 0:
                // if (question.bangChiTieu == '1' && question.loaiCauHoi == 0) {
                //   return Obx(() => Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           RichTextQuestion(
                //             question.tenCauHoi ?? '',
                //             level: question.cap!,
                //           ),
                //           buildOnlyQuestionChiTieuCot(question,
                //               parentQuestion: parentQuestion),
                //         ],
                //       ));
                // } else
                if (question.loaiCauHoi == 0 && question.bangChiTieu == '2') {
                  //return const SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [buildQuestionChiTieuDongCot(question)],
                  );
                } else {
                  return const SizedBox();
                }
              case 2:
                return _renderQuestionType2WithSub(question, product: product);
              case 3:
                return _renderQuestionType3(question, product: product);
              case 4:
                return _renderQuestionType4(question);
              case 5:
                if (question.bangChiTieu == tableDmDanToc) {
                  return buildDmDanToc(question);
                } else {
                  return _renderQuestionType5Dm(question);
                }

              // case 7:
              //   return _renderQuestionType7(question);

              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  _buildQuestion3(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questions = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel question = questions[index];

            switch (question.loaiCauHoi) {
              case 2:
                return _renderQuestionType2(question);
              case 3:
                return _renderQuestionType3(question);
              case 4:
                return _renderQuestionType4(question);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  _questionItem(QuestionCommonModel question,
      {QuestionCommonModel? parentQuestion}) {
    switch (question.loaiCauHoi) {
      case 0 || null:
        // if (question.bangChiTieu == '1') {
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       RichTextQuestion(
        //         question.tenCauHoi ?? '',
        //         level: question.cap!,
        //       ),
        //       buildOnlyQuestionChiTieuCot(question,
        //           parentQuestion: parentQuestion)
        //     ],
        //   );
        // }
        // return RichTextQuestion(question.tenCauHoi ?? '', level: question.cap!);
        // if (question.maCauHoi == "A_V") {
        //   return buildPhanV(question);
        // } else
        if (question.maCauHoi == "A_I_0" && question.maPhieu == 1) {
          String moTaSanPhamCau5_1 =
              controller.tblPhieuNganhCNDistinctCap5.isNotEmpty
                  ? controller.tblPhieuNganhCNDistinctCap5!
                      .map((p) => p.moTaSanPham ?? '')
                      .toList()
                      .join('; ')
                  : '';

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichTextQuestion(
                  question.tenCauHoi ?? '',
                  level: question.cap!,
                  notes: question.giaiThich ?? '',
                  moTaSanPham: moTaSanPhamCau5_1,
                ),
                buildNganhCN(question)
              ]);
        } else if (question.maCauHoi == maCauHoiTMGL6810 &&
            question.maPhieu == 4) {
          String moTaSanPhamCau5_1 =
              controller.tblPhieuNganhTMSanPhamView.isNotEmpty
                  ? controller.tblPhieuNganhTMSanPhamView!
                      .map((p) => p.moTaSanPham ?? '')
                      .toList()
                      .join('; ')
                  : '';

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichTextQuestion(
                  question.tenCauHoi ?? '',
                  level: question.cap!,
                  notes: question.giaiThich ?? '',
                  moTaSanPham: moTaSanPhamCau5_1,
                ),
                buildNganhTM(question)
              ]);
        } else if (question.bangChiTieu == "2") {
          return buildQuestionChiTieuDongCot(question);
        } else {
          //Bỏ không kiểm tra B, C, E
          // if (controller.isNhomNganhCap1BCE == '0' &&
          //     question.maCauHoi == 'A3_1') {
          //   return Container();
          // }
          return _renderQuestionType0(question);
        }
      case 1:
        if (question.bangChiTieu == '2') {
          // return _renderChiTieuDongCotType1(question);
        } else {
          return _renderQuestionType1(question);
        }

      case 2:
        return _renderQuestionType2WithSub(question);
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderQuestionType3(question),
            if (question.danhSachCauHoiCon!.isNotEmpty)
              Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyDarkBorder, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: _buildQuestion3(question))
          ],
        );
      case 4:
        return _renderQuestionType4(question);
      case 5:
        return _renderQuestionType5Dm(question);
      case 7:
        return renderQuestionType7(question);
      default:
        if (question.bangChiTieu == '2') {
          // if (question.maCauHoi == "A6_2") {
          //   return buildQuestionChiTieuDongCotA6_2(question);
          // }
          return buildQuestionChiTieuDongCot(question);
        }
        return Container();
    }
  }

  _renderQuestionType0(QuestionCommonModel question,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    String moTaSanPhamCaux = '';
    if (question.maCauHoi == maCauHoiVTHK &&
        question.maPhieu == AppDefine.maPhieuVT) {
      moTaSanPhamCaux = controller.tblPhieuMauTBSanPhamVTHanhKhach.isNotEmpty
          ? controller.tblPhieuMauTBSanPhamVTHanhKhach
              .map((p) => p.a5_1_1 ?? '')
              .toList()
              .join('; ')
          : '';
    } else if (question.maCauHoi == maCauHoiVTHH &&
        question.maPhieu == AppDefine.maPhieuVT) {
      moTaSanPhamCaux = controller.tblPhieuMauTBSanPhamVTHangHoa.isNotEmpty
          ? controller.tblPhieuMauTBSanPhamVTHangHoa
              .map((p) => p.a5_1_1 ?? '')
              .toList()
              .join('; ')
          : '';
    } else if ((question.maCauHoi == maCauHoiLT &&
            question.maPhieu == AppDefine.maPhieuLT) ||
        (question.maCauHoi == maCauHoiLTMau &&
            question.maPhieu == AppDefine.maPhieuLTMau)) {
      moTaSanPhamCaux = controller.tblPhieuMauTBSanPhamLT.isNotEmpty
          ? controller.tblPhieuMauTBSanPhamLT
              .map((p) => p.a5_1_1 ?? '')
              .toList()
              .join('; ')
          : '';
    } else if (question.maCauHoi == maCauHoiTMGL6810 &&
        question.maPhieu == AppDefine.maPhieuTM) {
      moTaSanPhamCaux = controller.tblPhieuMauTBSanPhamTMGL6810.isNotEmpty
          ? controller.tblPhieuMauTBSanPhamTMGL6810
              .map((p) => p.a5_1_1 ?? '')
              .toList()
              .join('; ')
          : '';
    } else if (question.maCauHoi == maCauHoiTM56 &&
        question.maPhieu == AppDefine.maPhieuTM) {
      moTaSanPhamCaux = controller.tblPhieuMauTBSanPhamTM56.isNotEmpty
          ? controller.tblPhieuMauTBSanPhamTM56
              .map((p) => p.a5_1_1 ?? '')
              .toList()
              .join('; ')
          : '';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(
          question.tenCauHoi ?? '',
          level: question.cap ?? 2,
          moTaSanPham: moTaSanPhamCaux,
        ),
        _buildQuestion2(question,
            product: product, parentQuestion: parentQuestion)
      ],
    );
  }

  _renderQuestionType1(QuestionCommonModel question,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    return YesNoQuestion(
      onChange: (value) => controller.onChangeYesNoQuestion(
          question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
      question: question,
      key: ValueKey<QuestionCommonModel>(question),
      //   key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
      value: controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!),
      child: Column(
        children: question.danhSachCauHoiCon!.map<Widget>((question) {
          switch (question.loaiCauHoi) {
            case 0:
              return _renderQuestionType0(question, product: product);

            case 2:
              return Column(
                children: [
                  _renderQuestionType2(question, product: product),
                  if (question.danhSachCauHoiCon!.isNotEmpty)
                    _buildQuestion2(question)
                ],
              );

            case 3:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _renderQuestionType3(question, product: product),
                  if (question.danhSachCauHoiCon!.isNotEmpty)
                    Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: greyDarkBorder, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: _buildQuestion3(question))
                ],
              );
            case 4:
              return _renderQuestionType4(question);
            default:
              return Container();
          }
        }).toList(),
      ),
    );
  }

  _renderQuestionType2(QuestionCommonModel question,
      {String? subName,
      ProductModel? product,
      QuestionCommonModel? parentQuestion}) {
    bool enable = question.maCauHoi != 'xxx' && question.maCauHoi != 'xxx';
    //  return Obx(() {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');
    if (!enable) {
      return ViewInput(
        question: question,
        value: val,
      );
    }
    if (((question.maCauHoi == "A5_1" || question.maCauHoi == "A6_1") &&
            question.maPhieu == AppDefine.maPhieuLT) ||
        (question.maCauHoi == "A7_1_M" &&
            question.maPhieu == AppDefine.maPhieuLTMau)) {
      return Obx(() {
        var axLTVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}}_${question.cauHoiUUID}_1_$axLTVal';
        return InputIntView(
          key: ValueKey(vkey),
          question: question,
          onChange: (value) => {},
          value: axLTVal,
          enable: false,
          type: "int",
          txtStyle: styleMediumBold.copyWith(color: primaryColor),
          hintText: "Tự động tính.",
        );
      });
    } else if (question.maCauHoi == "A6_6" || question.maCauHoi == "A7_8_1") {
      return Obx(() {
        var valA6_6_6_7 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}${question.maCauHoi}${question.cauHoiUUID}_$valA6_6_6_7'),
          question: question,
          onChange: (value) => (),
          enable: false,
          subName: subName,
          value: valA6_6_6_7,
          txtStyle: styleMediumBold.copyWith(color: primaryColor),
        );
      });
    } else if (question.maCauHoi == "A6_4") {
      return Obx(() {
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}${question.maCauHoi}${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          enable: enable,
          subName: subName,
          value: val,
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
        );
      });
    }

    // return Obx(() {
    var val2 = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    return InputInt(
      key: ValueKey(
          '${question.maPhieu}${question.maCauHoi}${question.cauHoiUUID}'),
      question: question,
      onChange: (value) => controller.onChangeInput(question.maPhieu!,
          question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
      enable: enable,
      subName: subName,
      value: val2,
      validator: (String? value) => controller.onValidate(
          question.bangDuLieu!,
          question.maCauHoi!,
          question.maCauHoi,
          value,
          question.giaTriNN,
          question.giaTriLN,
          question.loaiCauHoi!,
          true,
          question.maPhieu!),
      flteringTextInputFormatterRegExp: wFilterInput,
    );
    // });
    // return InputInt(
    //   key: ValueKey('${question.maPhieu}${question.maCauHoi}${question.cauHoiUUID}'),
    //   question: question,
    //   onChange: (value) => controller.onChangeInput(question.maPhieu!,
    //       question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
    //   enable: enable,
    //   subName: subName,
    //   value: val,
    //   validator: (String? value) => controller.onValidate(
    //       question.bangDuLieu!,
    //       question.maCauHoi!,
    //       question.maCauHoi,
    //       value,
    //       question.giaTriNN,
    //       question.giaTriLN,
    //       question.loaiCauHoi!,
    //       true,question.maPhieu!),
    //   flteringTextInputFormatterRegExp: wFilterInput,
    // );
    //  });
  }

  _renderQuestionType2WithSub(QuestionCommonModel question,
      {String? subName,
      ProductModel? product,
      QuestionCommonModel? parentQuestion}) {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');
    if ((question.maCauHoi == "A7_M" || question.maCauHoi == "A7_1_M") &&
        question.maPhieu == AppDefine.maPhieuLTMau) {
      return Obx(() {
        var aValue = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}}_${question.cauHoiUUID}_1_$aValue';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputIntView(
              key: ValueKey(vkey),
              question: question,
              onChange: (value) => {},
              value: aValue,
              enable: false,
              type: "int",
              txtStyle: styleMediumBold.copyWith(color: primaryColor),
              hintText: "Tự động tính.",
            ),
            if (question.danhSachCauHoiCon!.isNotEmpty)
              Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyDarkBorder, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: _buildQuestion3(question))
          ],
        );
      });
    } else if ((question.maCauHoi == "A4_M") &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      return Obx(() {
        var a45VTMauVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}}_${question.cauHoiUUID}_1_$a45VTMauVal';
        return InputIntView(
          key: ValueKey(vkey),
          question: question,
          onChange: (value) => {},
          value: a45VTMauVal,
          enable: false,
          type: "int",
          txtStyle: styleMediumBold.copyWith(color: primaryColor),
          hintText: "Tự động tính.",
        );
      });
    } else if ((question.maCauHoi == "A5") &&
        question.maPhieu == AppDefine.maPhieuVT) {
      return Obx(() {
        var a11VTVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}}_${question.cauHoiUUID}_1_$a11VTVal';
        return Column(children: [
          InputIntView(
            key: ValueKey(vkey),
            question: question,
            onChange: (value) => {},
            value: a11VTVal,
            enable: false,
            type: "int",
            txtStyle: styleMediumBold.copyWith(color: primaryColor),
            hintText: "Tự động tính.",
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            warningText: warningWithText(question, a11VTVal),
          ),
        ]);
      });
    } else if ((question.maCauHoi == "A6" || question.maCauHoi == "A11") &&
        question.maPhieu == AppDefine.maPhieuVT) {
      return Obx(() {
        var a11VTVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}}_${question.cauHoiUUID}_1_$a11VTVal';
        return Column(children: [
          InputIntView(
            key: ValueKey(vkey),
            question: question,
            onChange: (value) => {},
            value: a11VTVal,
            enable: false,
            type: "int",
            txtStyle: styleMediumBold.copyWith(color: primaryColor),
            hintText: "Tự động tính.",
          ),
        ]);
      });
    } else if ((question.maCauHoi == "A5" || question.maCauHoi == "A6") &&
        question.maPhieu == AppDefine.maPhieuLT) {
      return Obx(() {
        var axLTVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}}_${question.cauHoiUUID}_1_$axLTVal';
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InputIntView(
            key: ValueKey(vkey),
            question: question,
            onChange: (value) => {},
            value: axLTVal,
            enable: false,
            type: "int",
            txtStyle: styleMediumBold.copyWith(color: primaryColor),
            hintText: "Tự động tính.",
          ),
          if (question.danhSachCauHoiCon!.isNotEmpty)
            Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: _buildQuestion3(question))
        ]);
      });
    }
    return Obx(() {
      var val2 = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}${question.maCauHoi}${question.cauHoiUUID}'),
            question: question,
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            enable: true,
            subName: subName,
            value: val2,
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            flteringTextInputFormatterRegExp: wFilterInput,
          ),
          buildWarningText(question, val2),
          if (question.danhSachCauHoiCon!.isNotEmpty)
            Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: _buildQuestion3(question))
        ],
      );
    });
  }

  // _questionSubType2(QuestionCommonModel question,
  //     {QuestionCommonModel? parentQuestion}) {
  //   switch (question.loaiCauHoi) {
  //     case 1:
  //       if (question.bangChiTieu == '2') {
  //         // return _renderChiTieuDongCotType1(question);
  //       } else {
  //         return _renderQuestionType1(question);
  //       }

  //     case 2:
  //       return _renderQuestionType2(question);
  //     case 3:
  //       return _renderQuestionType3(question);
  //     case 4:
  //       return _renderQuestionType4(question);
  //     case 5:
  //       if (question.bangChiTieu == tableDmDanToc) {
  //         return buildDmDanToc(question);
  //       } else {
  //         return _renderQuestionType5Dm(question);
  //       }
  //     default:
  //       return Container();
  //   }
  // }

  _renderQuestionType3(
    QuestionCommonModel question, {
    String? subName,
    ProductModel? product,
  }) {
    if ((question.maCauHoi == colPhieuMauTBA3_1T &&
            question.bangDuLieu == tablePhieuMauTB) ||
        (question.maCauHoi == colPhieuMauTBA3T &&
            question.bangDuLieu == tablePhieuMauTB) ||
        question.maCauHoi == colPhieuMauTBA4T &&
            question.bangDuLieu == tablePhieuMauTB ||
        (question.maCauHoi == "A12" &&
            question.maPhieu == AppDefine.maPhieuVT) ||
        ((question.maCauHoi == "A5_M" ||
                question.maCauHoi == "A9_M" ||
                question.maCauHoi == "A10_M") &&
            question.maPhieu == AppDefine.maPhieuVTMau) ||
        ((question.maCauHoi == "A7_M" ||
                question.maCauHoi == "A7_1_M" ||
                question.maCauHoi == "A8_M" ||
                question.maCauHoi == "A9_M" ||
                question.maCauHoi == "A10_M") &&
            question.maPhieu == AppDefine.maPhieuLTMau)) {
      return Obx(() {
        var valA32 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        var valRep = valA32 ?? 0;
        var vkey =
            '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}_${question.maCauHoi}_${question.cauHoiUUID}_1_$valRep';
        if (valA32 == null) {}
        return Column(children: [
          InputIntView(
            key: ValueKey(vkey),
            question: question,
            onChange: (value) => {},
            value: valA32,
            enable: false,
            type: "double",
            txtStyle: styleMediumBold.copyWith(color: primaryColor),
            hintText: "Tự động tính.",
            decimalDigits: 2,
          ),
          buildWarningText(question, valA32)
        ]);
      });
    } else if (question.maCauHoi == colPhieuNganhTMA3T &&
        question.bangDuLieu == tablePhieuNganhTM) {
      return Obx(() {
        var a3TVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var a2TMVal = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuNganhTMA2);
        if (a2TMVal == 1) {
          if (a3TVal == null) {
            var vkey1 =
                '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}_${question.maPhieu}_${question.cauHoiUUID}_1_${a3TVal ?? 0}';
            return InputIntView(
              key: ValueKey(vkey1),
              question: question,
              onChange: (value) => {},
              value: a3TVal,
              enable: false,
              type: "double",
              txtStyle: styleMediumBold.copyWith(color: primaryColor),
              hintText: "Tự động tính.",
              decimalDigits: 2,
            );
          }

          var vkey =
              '${question.maPhieu}_${question.manHinh}_${question.bangDuLieu}_${question.maPhieu}_${question.cauHoiUUID}_1_$a3TVal';

          return InputIntView(
            key: ValueKey(vkey),
            question: question,
            onChange: (value) => {},
            value: a3TVal,
            enable: false,
            type: "double",
            txtStyle: styleMediumBold.copyWith(color: primaryColor),
            hintText: "Tự động tính.",
            decimalDigits: 2,
          );
        }
        return const SizedBox();
      });
    } else if (question.maCauHoi == colPhieuNganhTMA3 &&
        question.bangDuLieu == tablePhieuNganhTM) {
      return Obx(() {
        var a3TMVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var a2TMVal = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuNganhTMA2);
        if (a2TMVal == 1) {
          var decimalDigits = 2;
          return InputInt(
            key: ValueKey(
                '${question.maPhieu}-${question.maCauHoi}-${question.maPhieu}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            subName: subName,
            value: a3TMVal,
            type: 'double',
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            decimalDigits: decimalDigits,
          );
        }
        return const SizedBox();
      });
    }

    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    if (question.maCauHoi == "A6_5" ||
        question.maCauHoi == "A6_11" ||
        question.maCauHoi == "A6_12" ||
        question.maCauHoi == "A7_9" ||
        question.maCauHoi == "A9_5" ||
        question.maCauHoi == "A9_6" ||
        question.maCauHoi == "A9_8") {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      decimalDigits = 2;
    }
    if (question.maCauHoi == colPhieuMauTBA3_2_1) {
      decimalDigits = 2;
      return Obx(() {
        var a3_3Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA3_2);
        return InputInt(
          key: ValueKey('${question.maPhieu}_${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      });
    } else if (question.maCauHoi == colPhieuMauTBA4_2) {
      decimalDigits = 2;
      return Obx(() {
        var a4_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA4_2);
        return InputInt(
          key: ValueKey('${question.maPhieu}_${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          subName: subName,
          value: a4_2Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: warningWithText(question, a4_2Value),
        );
      });
    } else if (question.maCauHoi == colPhieuMauTBA4_3) {
      decimalDigits = 2;

      return Obx(() {
        var a1_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA1_2);
        if (a1_2Value != 1) {
          return const SizedBox();
        }
        var a4_3Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA4_3);
        return InputInt(
          key: ValueKey('${question.maPhieu}_${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          subName: subName,
          value: a4_3Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: warningWithText(question, a4_3Value),
        );
      });
    }

    if (question.maCauHoi == colPhieuNganhVTA3_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      return Obx(() {
        //decimalDigits=2;
        var a3MValue = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuNganhVTA3_M);
        return Column(children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            subName: subName,
            value: a3MValue,
            type: 'double',
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: 2,
          ),
          buildWarningText(question, a3MValue)
        ]);
      });
    }
    if (question.maCauHoi == colPhieuNganhVTA7_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      return Obx(() {
        var a7MValue = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuNganhVTA7_M);
        return Column(children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            subName: subName,
            value: a7MValue,
            type: 'double',
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
          ),
          buildWarningText(question, a7MValue)
        ]);
      });
    }
    if (question.maCauHoi == colPhieuNganhVTA8_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      return Obx(() {
        var a8MValue = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuNganhVTA8_M);
        return Column(children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            subName: subName,
            value: a8MValue,
            type: 'double',
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
          ),
          buildWarningText(question, a8MValue)
        ]);
      });
    }
    if (question.maCauHoi == "A7_4_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      return Obx(() {
        var a7_1TBVal = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_1);
        if (a7_1TBVal != 1) {
          return const SizedBox();
        }
        var a7_3MVal = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_3_M);
        if (a7_3MVal != 1) {
          return const SizedBox();
        }
        decimalDigits = 2;
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: warningWithText(question, val),
        );
      });
    }
    if (question.maCauHoi == "A7_6_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      return Obx(() {
        var a7_5MVal = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_5_M);
        if (a7_5MVal != 1) {
          return const SizedBox();
        }
        decimalDigits = 2;
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: warningWithText(question, val),
        );
      });
    }

    if (question.maCauHoi == colPhieuMauTBA7_8_M) {
      return Obx(() {
        decimalDigits = 2;
        var a9_7Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_7_M);
        // var a9_8Value = controller.getValueByFieldName(
        //     question.bangDuLieu!, columnPhieuMauA9_8);
        if (a9_7Value != 1) {
          return const SizedBox();
        }
        return InputInt(
          key:
              ValueKey('${question.maPhieu}_${question.cauHoiUUID}_$a9_7Value'),
          question: question,
          onChange: (value) => controller.onChangeInput(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: warningWithText(question, val),
        );
      });
    }

    if ((question.maCauHoi == colPhieuMauTBA7_3) &&
        question.maPhieu == AppDefine.maPhieuTB) {
      return Obx(() {
        var a7_2Val = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_2);
        if (a7_2Val != null && a7_2Val == 2) {
          return const SizedBox();
        }
        decimalDigits = 2;
        return Column(children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            subName: subName,
            value: val,
            type: 'double',
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
          ),
          buildWarningText(question, val)
        ]);
      });
    }
    decimalDigits = 2;
    return Column(children: [
      InputInt(
        key: ValueKey(
            '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
        question: question,
        onChange: (value) => controller.onChangeInput(question.maPhieu!,
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        subName: subName,
        value: val,
        type: 'double',
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true,
            question.maPhieu!),
        flteringTextInputFormatterRegExp: wFilterInput,
        decimalDigits: decimalDigits,
      ),
      buildWarningText(question, val)
    ]);
  }

  _renderQuestionType4(QuestionCommonModel question, {String? subName}) {
    if (question.maCauHoi == colPhieuMauTBA1_5_1) {
      return Obx(() {
        var a1_5Val = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA1_5);
        var a1_5_1 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        if (a1_5Val == 1) {
          return InputString(
            key: ValueKey('${question.maPhieu}_${question.maCauHoi}'),
            onChange: (value) => controller.onChangeInput(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value),
            question: question,
            subName: subName,
            value: a1_5_1,
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
          );
        }
        return const SizedBox();
      });
    }
    var resVal = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);

    return InputString(
      key: ValueKey('${question.maPhieu}_${question.maCauHoi}'),
      onChange: (value) => controller.onChangeInput(question.maPhieu!,
          question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
      question: question,
      subName: subName,
      value: resVal,
      validator: (String? value) => controller.onValidate(
          question.bangDuLieu!,
          question.maCauHoi!,
          question.maCauHoi,
          value,
          question.giaTriNN,
          question.giaTriLN,
          question.loaiCauHoi!,
          true,
          question.maPhieu!),
    );
  }

  // renderThongTinNguoiDungDau(QuestionCommonModel question, {String? subName}) {
  //   if (question.danhSachCauHoiCon != null) {
  //     List<QuestionCommonModel> questionsCon = question.danhSachCauHoiCon!;
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         RichTextQuestion(question.tenCauHoi ?? '', level: question.cap!),
  //         Container(
  //             margin: const EdgeInsets.fromLTRB(
  //                 0.0, 0.0, 0.0, AppValues.marginBottomBox),
  //             padding: const EdgeInsets.all(AppValues.paddingBox),
  //             decoration: BoxDecoration(
  //                 border: Border.all(color: greyDarkBorder, width: 1),
  //                 borderRadius: const BorderRadius.all(Radius.circular(5.0)),
  //                 color: Colors.white),
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ListView.builder(
  //                       itemCount: questionsCon.length,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       shrinkWrap: true,
  //                       itemBuilder: (_, index) {
  //                         QuestionCommonModel questionItem =
  //                             questionsCon[index];
  //                         return _questionItemNguoiDungDau(questionItem,
  //                             parentQuestion: question);
  //                       })
  //                 ]))
  //       ],
  //     );
  //   }
  //   return RichTextQuestion(
  //       controller.questions[controller.questionIndex.value].tenCauHoi ?? '',
  //       level: controller.questions[controller.questionIndex.value].cap!,
  //       notes: controller.questions[controller.questionIndex.value].giaiThich ??
  //           '');
  // }

  // _questionItemNguoiDungDau(QuestionCommonModel question,
  //     {QuestionCommonModel? parentQuestion}) {
  //   switch (question.loaiCauHoi) {
  //     case 1:
  //       if (question.bangChiTieu == '2') {
  //         // return _renderChiTieuDongCotType1(question);
  //       } else {
  //         return _renderQuestionType1(question);
  //       }

  //     case 2:
  //       return _renderQuestionType2(question);
  //     case 3:
  //       return _renderQuestionType3(question);
  //     case 4:
  //       return _renderQuestionType4(question);
  //     case 5:
  //       if (question.bangChiTieu == tableDmDanToc) {
  //         return buildDmDanToc(question);
  //       } else {
  //         return _renderQuestionType5Dm(question);
  //       }
  //     default:
  //       return Container();
  //   }
  // }

  buildDmDanToc(QuestionCommonModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextQuestion(
          question.tenCauHoi ?? '',
          level: 3,
        ),
        Obx(() {
          var val = controller.getValueDanTocByFieldName(
              question.bangDuLieu!, question.maCauHoi!);

          return SearchDanToc(
            key: ValueKey(
                '${question.maPhieu}${question.maCauHoi}${question.cauHoiUUID}'),
            // listValue: controller.tblDmVsicIO,
            onSearch: (pattern) => controller.onSearchDmDanToc(pattern),
            value: val,

            onChange: (inputValue) => controller.onChangeInputDanToc(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi!,
                inputValue),
            isError: controller.searchResult.value,
            validator: (String? inputValue) => controller.onValidateInputDanToc(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                inputValue,
                question.loaiCauHoi!),
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }

//Co khong ko dong cot
  _renderQuestionType5Dm(QuestionCommonModel question, {String? subName}) {
    if (question.maCauHoi == "A1_1") {
      return Obx(() {
        // var a1_4Val = controller.getValueByFieldName(question.bangDuLieu!,question.maCauHoi!);
        var a1_1val = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}$a1_1val'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: a1_1val,
            ),
            buildGhiRo(question, a1_1val)
          ],
        );
      });
    } else if (question.maCauHoi == colPhieuMauTBA1_3_5) {
      return Obx(() {
        var a1_3_5Val = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        //  var a1_5_3val = controller.getValueByFieldName(question.bangDuLieu!,"A1_5_3");
        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}$a1_3_5Val'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: a1_3_5Val,
            ),
            buildError(question, a1_3_5Val),
            buildWarningText(question, a1_3_5Val)
          ],
        );
      });
    }
    if (question.maCauHoi == "A7_3_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      return Obx(() {
        var a7_1TBVal = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_1);
        if (a7_1TBVal != 1 && a7_1TBVal != "1") {
          return const SizedBox();
        }
        var a7_3MVal = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}$a7_3MVal'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: a7_3MVal,
            ),
            buildWarningText(question, a7_3MVal),
          ],
        );
      });
    }

    return Obx(() {
      if (question.maCauHoi == colPhieuMauTBA1_2 &&
          question.maPhieu == AppDefine.maPhieuTB) {
        var a1_1Val = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA1_1);
        if (a1_1Val == 6) {
          return const SizedBox();
        }
      }
      if ((question.maCauHoi == colPhieuMauTBA7_2) &&
          question.maPhieu == AppDefine.maPhieuTB) {
        var a7_1Val = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA7_1);
        if (a7_1Val != null && a7_1Val == 2) {
          return const SizedBox();
        }
      }

      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);

      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey(
                '${question.maPhieu}${question.cauHoiUUID}_${question.maPhieu}_${question.maCauHoi}${val}'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: question.bangChiTieu,
            onChange: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value,
                dmItem),
            value: val,
            titleGhiRoText: 'Ghi rõ',
            onChangeGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
          ),
          buildGhiRo(question, val),
          buildWarningText(question, val, fieldName: question.maCauHoi!),
          if (question.danhSachCauHoiCon != null &&
              question.danhSachCauHoiCon!.isNotEmpty)
            _buildQuestion3(question),
        ],
      );
    });
  }

  buildQuestionA6_1(QuestionCommonModel question, {String? subName}) {
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
      return Column(
        children: [
          SelectStringCTDm(
            key: ValueKey(
                '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}$val'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: question.bangChiTieu,
            onChangeSelectStringDm: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value,
                dmItem),
            value: val,
            titleGhiRoText: 'Ghi rõ',
            onChangeSelectStringDmGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
          ),
          buildGhiRo(question, val),
        ],
      );
    });
  }

  buildGhiRo(QuestionCommonModel question, selectedValue) {
    if ((selectedValue == 5 && question.bangChiTieu == tableCTDmDiaDiemSXKD) &&
        question.maCauHoi == colPhieuMauTBA1_1) {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_GhiRo');
      var fieldNameGhiRo = '${question.maCauHoi}_GhiRo';
      return InputStringCTDm(
        key: ValueKey(
            '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null),
        titleText: 'Ghi rõ',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            fieldNameGhiRo,
            inputValue,
            5,
            250,
            4,
            true,
            question.maPhieu!),
      );
    } else if ((selectedValue == 1 &&
        question.bangChiTieu == tableDmCoKhong &&
        question.maCauHoi == "A1_7")) {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_1');
      var fieldNameGhiRo = '${question.maCauHoi}_1';
      return InputStringCTDm(
        key: ValueKey(
            '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null,
            fieldNameGhiRo: fieldNameGhiRo),
        titleText: 'Mã số thuế',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            fieldNameGhiRo,
            inputValue,
            5,
            250,
            4,
            true,
            question.maPhieu!),
      );
    }
    return const SizedBox();
  }

  ///END:: Build cho A43
  /******/
  ///BEGIN:: Build câu vừa có chỉ tiêu dòng và chỉ tiêu cột
  buildQuestionChiTieuDongCot(QuestionCommonModel mainQuestion,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    var chiTieuCots = mainQuestion.danhSachChiTieu ?? [];
    var chiTieuDongs = mainQuestion.danhSachChiTieuIO ?? [];
    chiTieuCots.retainWhere((x) {
      return x.loaiCauHoi != null;
    });
    String dsLoaiNangLuongA6_1 = '';
    if (mainQuestion.maCauHoi == "A6_1_M") {
      if (controller.dsChiTieuDongA6_1TB.value != null &&
          controller.dsChiTieuDongA6_1TB.value.isNotEmpty) {
        var ct = controller.dsChiTieuDongA6_1TB.value
            .map((ctDong) => ctDong.tenChiTieu)
            .toList();
        if (ct != null && ct.isNotEmpty) {
          dsLoaiNangLuongA6_1 = ct.join(', ');
        }
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(
          mainQuestion.tenCauHoi ?? '',
          level: mainQuestion.cap ?? 3,
          moTaSanPham: (mainQuestion.maCauHoi == "A6_1_M" &&
                  mainQuestion.maPhieu == AppDefine.maPhieuMau)
              ? dsLoaiNangLuongA6_1
              : '',
        ),
        if (mainQuestion.maCauHoi == "A6_1" &&
            mainQuestion.maPhieu == AppDefine.maPhieuTB) ...[
          Obx(() => buildWarningText(mainQuestion, 0, isShow: true))
        ],
        if (mainQuestion.maCauHoi == "A6_1_M" &&
            mainQuestion.maPhieu == AppDefine.maPhieuMau) ...[
          Obx(() => buildError(mainQuestion, 0))
        ],
        if (mainQuestion.maCauHoi == "A6_1" &&
            mainQuestion.maPhieu == AppDefine.maPhieuTB) ...[
          Obx(() => buildError(mainQuestion, null))
        ],
        ListView.builder(
            key: ObjectKey(chiTieuCots),
            itemCount: chiTieuDongs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, indexIO) {
              ChiTieuDongModel chiTieuDong = chiTieuDongs[indexIO];
              return buildChiTieuDongCotItem(
                  mainQuestion, chiTieuDong, chiTieuCots);
            })
      ],
    );
  }

  buildChiTieuDongCotItem(QuestionCommonModel mainQuestion,
      ChiTieuDongModel chiTieuDong, List<ChiTieuModel> chiTieuCots) {
    ///(CHỈ HIỂN THỊ NHỮNG NĂNG LƯỢNG CÓ CÂU 6.1 = "CÓ" Ở PHIẾU TOÀN BỘ)
    if (mainQuestion.maCauHoi == "A6_1_M" &&
        mainQuestion.maPhieu == AppDefine.maPhieuMau) {
      var a6_1fieldName = 'A6_1_${chiTieuDong.maSo}_1';
      if (chiTieuDong.maSo == "1_1" || chiTieuDong.maSo == "1_2") {
        a6_1fieldName = 'A6_1_1_1';
      } else if (chiTieuDong.maSo == "6_1") {
        a6_1fieldName = 'A6_1_6_1';
      } else if (chiTieuDong.maSo == "7_1") {
        a6_1fieldName = 'A6_1_7_1';
      } else if (chiTieuDong.maSo == "10_1") {
        a6_1fieldName = 'A6_1_10_1';
      }
      var a6_1Val = controller.getValueByFieldName(
          mainQuestion.bangDuLieu!, a6_1fieldName);
      if (a6_1Val != 1 && a6_1Val != "1") {
        return const SizedBox();
      }
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichTextQuestionChiTieu(
            chiTieuDong.tenChiTieu ?? '',
            prefixText: chiTieuDong.maSo!.contains("_")
                ? chiTieuDong.maSo!.replaceAll('_', '.')
                : chiTieuDong.maSo!,
            seperateSign: ' - ',
            level: 3,
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(
                  0.0, 0.0, 0.0, AppValues.marginBottomBox),
              padding: const EdgeInsets.all(AppValues.paddingBox),
              decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
                      ? greyDarkBorder2
                      : Colors.white),
              child: Column(
                children: [
                  ListView.builder(
                      key: ObjectKey(chiTieuDong),
                      itemCount: chiTieuCots.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        ChiTieuModel chitieuCot = chiTieuCots[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (chitieuCot.loaiChiTieu.toString() ==
                                    AppDefine.loaiChiTieu_1 ||
                                chitieuCot.loaiChiTieu.toString() ==
                                    AppDefine.loaiChiTieu_2)
                              renderChiTieuDongCotQuestionByType(
                                  mainQuestion, chiTieuDong, chitieuCot)
                            else
                              const SizedBox(),
                          ],
                        );
                      }),
                ],
              )),
        ]);
  }

  renderChiTieuDongCotQuestionByType(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    switch (chiTieuCot.loaiCauHoi) {
      case 0:
        RichTextQuestionChiTieu(
          chiTieuCot.tenChiTieu ?? '',
          level: 2,
        );
      case 2:
        return renderChiTieuDongCotQuestionType2(
            question, chiTieuDong, chiTieuCot);
      case 3:
        return renderChiTieuDongCotQuestionType3(
            question, chiTieuDong, chiTieuCot);
      case 5:
        if (controller.isA1GhiRoF(question, chiTieuDong, chiTieuCot)) {
          return buildNganhVTGhiRo(question, chiTieuDong, chiTieuCot);
        } else if (controller.isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
          return buildNganhVTGhiRo(question, chiTieuDong, chiTieuCot);
        }
        return renderQuestionType5DmChiTieuDongCot(
            question, chiTieuDong, chiTieuCot, tableDmCoKhong);
      default:
        return Container();
    }
  }

  renderChiTieuDongCotQuestionType2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if (controller.isA1NganhVT(question, chiTieuDong, chiTieuCot) ||
          controller.isA7NganhVT(question, chiTieuDong, chiTieuCot) ||
          (question.maCauHoi == "A1" &&
              question.maPhieu == AppDefine.maPhieuLT)) {
        return renderChiTieuDongCotType2ByMaChiTieu(
            question, chiTieuDong, chiTieuCot,
            value: value);
      }
      return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType2ByMaChiTieu(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp('[0-9]');

    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if (question.maCauHoi == "A1" &&
          question.maPhieu == AppDefine.maPhieuVT) {
        //  13. Xe ô tô khác 1 (GHI RÕ ______________) 15. Phương tiện chở khách khác (ghi rõ__)
        if (chiTieuDong.maSo == "13" || chiTieuDong.maSo == "15") {
          return const SizedBox();
        } else {
          var a1_Maso_CotFieldName =
              '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
          var a1MaSoCotVal = controller.getValueByFieldName(
              question.bangDuLieu!, a1_Maso_CotFieldName);
          if (a1MaSoCotVal == 1) {
            return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
          } else {
            return const SizedBox();
          }
        }
      } else if (question.maCauHoi == "A7" &&
          question.maPhieu == AppDefine.maPhieuVT) {
        //  13. Xe ô tô khác 1 (GHI RÕ ______________) 15. Phương tiện chở khách khác (ghi rõ__)
        if (chiTieuDong.maSo == "17" || chiTieuDong.maSo == "18") {
          return const SizedBox();
        } else {
          var a1_Maso_CotFieldName =
              '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
          var a1MaSoCotVal = controller.getValueByFieldName(
              question.bangDuLieu!, a1_Maso_CotFieldName);
          if (a1MaSoCotVal == 1) {
            return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
          } else {
            return const SizedBox();
          }
        }
      } else if (question.maCauHoi == "A1" &&
          question.maPhieu == AppDefine.maPhieuLT) {
        var a1_Maso_CotFieldName =
            '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
        var a1MaSoCotVal = controller.getValueByFieldName(
            question.bangDuLieu!, a1_Maso_CotFieldName);
        if (a1MaSoCotVal == 1) {
          return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
        } else {
          return const SizedBox();
        }
      }
      return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
    });
  }

  buildNganhVTGhiRo(QuestionCommonModel question, ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot) {
    return Obx(() {
      if (controller.tblPhieuNganhVTGhiRos.isNotEmpty) {
        String maCauHoiMaSo = '${question.maCauHoi}_${chiTieuDong.maSo}';

        var ghiRoDefault = controller.tblPhieuNganhVTGhiRos
            .where((s) => s.sTT == 1 && s.maCauHoi == maCauHoiMaSo)
            .firstOrNull;
        var lastGhiRo = controller.tblPhieuNganhVTGhiRos
            .where((s) => s.maCauHoi == maCauHoiMaSo)
            .lastOrNull;
        var ghiRoItemA1Item = controller.tblPhieuNganhVTGhiRos
            .where((s) => s.maCauHoi == maCauHoiMaSo)
            .toList();
        var ghiRoItemA1SubItem = controller.tblPhieuNganhVTGhiRos
            .where((s) => s.maCauHoi == maCauHoiMaSo && s.sTT != 1)
            .toList();
        int lastStt = 0;
        if (lastGhiRo != null) {
          lastStt = lastGhiRo.sTT!;
        }
        return Column(
            children: ghiRoItemA1Item.asMap().entries.map((entry) {
          int idxSp = entry.key;

          TablePhieuNganhVTGhiRo ghiRoItem = entry.value;
          if (ghiRoItem.sTT != 1) {
            idxSp += 1;
          }
          String addNewCaption = '';
          String orderCaption = '';
          if (ghiRoItem.maCauHoi == "A1_13") {
            addNewCaption = 'Thêm Xe ô tô khác';
            orderCaption = 'Xe ô tô khác $idxSp';
          } else if (ghiRoItem.maCauHoi == "A1_15") {
            addNewCaption = 'Thêm Phương tiện chở khách khác';
            orderCaption = 'Phương tiện chở khách khác $idxSp';
          } else if (ghiRoItem.maCauHoi == "A7_17") {
            addNewCaption = 'Thêm Ô tô tải khác';
            orderCaption = 'Ô tô tải khác $idxSp';
          } else if (ghiRoItem.maCauHoi == "A7_18") {
            addNewCaption = 'Thêm Phương tiện chở hàng khác';
            orderCaption = 'Phương tiện chở hàng khác $idxSp';
          }
          return Column(
            children: [
              if (ghiRoItem.sTT! == 1)
                renderQuestionType5DmChiTieuDongCotNganhVTGhiRo(question,
                    chiTieuDong, chiTieuCot, tableDmCoKhong, ghiRoItem)
              else
                //Obx(() {
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              primary1LighterColor, //const Color.fromARGB(255, 4, 116, 228),
                          width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ghiRoItem.sTT! != 1)
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primary1LighterColor,
                                      primary1LighterColor,
                                      primary1LighterColor,
                                      primary1LighterColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(
                                          5.0))), // Adds a gradient background and rounded corners to the container
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          orderCaption,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 62, 65, 68),
                                          ),
                                        )),
                                        if (ghiRoItem.sTT != 1)
                                          ElevatedButton(
                                              onPressed: () {
                                                controller
                                                    .onDeletePhieuNganhVTGhiRo(
                                                        question,
                                                        chiTieuDong,
                                                        chiTieuCot,
                                                        ghiRoItem);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  splashFactory:
                                                      InkRipple.splashFactory,
                                                  fixedSize: const Size(80, 28),
                                                  foregroundColor: Colors.red,
                                                  backgroundColor: Colors.white,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppValues
                                                                  .borderLv1)),
                                                  elevation: 1.0,
                                                  side: const BorderSide(
                                                      color: Colors.red)),
                                              child: const Text('Xoá')),
                                      ],
                                    ),
                                  ])),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child:
                                renderQuestionType5DmChiTieuDongCotNganhVTGhiRo(
                                    question,
                                    chiTieuDong,
                                    chiTieuCot,
                                    tableDmCoKhong,
                                    ghiRoItem))
                      ],
                    )),
              //    }),
              if (lastStt > 0 && lastStt == ghiRoItem.sTT!)
                if (controller.countHasMorePhieuNganhVTGhiRo(
                        tablePhieuNganhVTGhiRo, ghiRoItem) >
                    0) ...[
                  const SizedBox(height: 16),
                  Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add_outlined),
                        label: Text(addNewCaption),
                        onPressed: () =>
                            controller.addNewRowonPhieuNganhVTGhiRo(
                                question, chiTieuDong, chiTieuCot, ghiRoItem),
                        style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                width: 1.0, color: primaryLightColor),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppValues.borderLv5),
                            ),
                            foregroundColor: primaryColor),
                      ))
                ],
              const SizedBox(height: 8)
            ],
          );
        }).toList());
      }
      return const SizedBox();
    });
  }

  renderQuestionType5DmChiTieuDongCotNganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String tenDanhMuc,
      TablePhieuNganhVTGhiRo ghiRoItem) {
    if (controller.isA1GhiRoF(question, chiTieuDong, chiTieuCot) ||
        controller.isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
      return Obx(() {
        var fieldName = colPhieuNganhVTGhiRoC1;

        var xVal = controller.getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo,
            fieldName,
            ghiRoItem.maCauHoi!,
            ghiRoItem.sTT!,
            id: ghiRoItem.id!);

        var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
        return Column(
          children: [
            if (ghiRoItem.sTT == 1) ...[
              SelectIntCTDm(
                key: ValueKey(
                    '${question.maPhieu}${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_${ghiRoItem.maCauHoi}_${ghiRoItem.sTT}_${ghiRoItem.id}_$xVal'),
                question: question,
                listValue: dmChiTieu,
                tenDanhMuc: tenDanhMuc,
                onChange: (value, dmItem) => controller.onSelectDmA1_A7(
                    question,
                    question.bangDuLieu!,
                    question.maCauHoi,
                    fieldName,
                    value,
                    dmItem,
                    chiTieuDong: chiTieuDong,
                    chiTieuCot: chiTieuCot,
                    ghiRoItem: ghiRoItem),
                value: xVal,
                hienThiTenCauHoi: false,
                enable: ghiRoItem.sTT == 1 ? true : false,
              )
            ],
            if (xVal == 1) ...[
              buildChiTieuDongCotItemNganhVTGhiRo(
                  question, chiTieuDong, question.danhSachChiTieu!, ghiRoItem),
              renderQuestionType4NganhVTGhiRo(
                  question, chiTieuDong, chiTieuCot, ghiRoItem)
            ]
          ],
        );
      });
    }
  }

  buildChiTieuDongCotItemNganhVTGhiRo(
      QuestionCommonModel mainQuestion,
      ChiTieuDongModel chiTieuDong,
      List<ChiTieuModel> chiTieuCots,
      TablePhieuNganhVTGhiRo ghiRoItem) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              key: ObjectKey(chiTieuDong),
              itemCount: chiTieuCots.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                ChiTieuModel chitieuCot = chiTieuCots[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chitieuCot.loaiChiTieu.toString() ==
                            AppDefine.loaiChiTieu_1 ||
                        chitieuCot.loaiChiTieu.toString() ==
                            AppDefine.loaiChiTieu_2) ...[
                      renderChiTieuDongCotQuestionByTypeNganhVTGhiRo(
                          mainQuestion, chiTieuDong, chitieuCot, ghiRoItem),
                    ] else
                      const SizedBox(),
                  ],
                );
              }),
        ]);
  }

  renderChiTieuDongCotQuestionByTypeNganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem,
      {String? subName,
      String? value}) {
    switch (chiTieuCot.loaiCauHoi) {
      case 0:
        RichTextQuestionChiTieu(
          chiTieuCot.tenChiTieu ?? '',
          level: 2,
        );
      case 2:
        return renderChiTieuDongCotType2NganhVTGhiRo(
            question, chiTieuDong, chiTieuCot, ghiRoItem);
      case 3:
        return renderChiTieuDongCotType3NganhVTGhiRo(
            question, chiTieuDong, chiTieuCot, ghiRoItem);
      case 5:
        // if (controller.isA1GhiRoF(question, chiTieuDong, chiTieuCot) ||
        //     controller.isA7GhiRoF(question, chiTieuDong, chiTieuCot)) {
        //   return renderQuestionType5DmChiTieuDongCotNganhVTGhiRo(
        //       question, chiTieuDong, chiTieuCot, tableDmCoKhong,ghiRoItem);
        // }
        return const SizedBox();
      default:
        return Container();
    }
  }

  renderChiTieuDongCotType2NganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem) {
    var fieldNameMaCauHoiMaSo = 'C_${chiTieuCot.maChiTieu}';
    var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong.maSo}';
    if (question.maCauHoi == "A1" && question.maPhieu == AppDefine.maPhieuVT ||
        question.maCauHoi == "A7" && question.maPhieu == AppDefine.maPhieuVT) {
      return Obx(() {
        var a1Val = controller.getValueVTGhiRoByFieldNameFromDB(
            tablePhieuNganhVTGhiRo,
            fieldNameMaCauHoiMaSo,
            ghiRoItem.maCauHoi!,
            ghiRoItem.sTT,
            id: ghiRoItem.id);
        String vKey =
            '${question.maPhieu}_${question.maCauHoi}_${fieldNameMaCauHoiMaSo}_${ghiRoItem.maCauHoi}_${ghiRoItem.sTT}_${ghiRoItem.id}';
        if (question.maCauHoi == "A1" &&
            question.maPhieu == AppDefine.maPhieuVT &&
            chiTieuCot.maChiTieu == "4") {
          vKey = '${vKey}_$a1Val';
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputIntChiTieu(
              key: ValueKey(vKey),
              type: 'int',
              onChange: (value) =>
                  controller.onChangeInputChiTieuDongCotNganhVTGhiRo(
                      question, chiTieuDong, chiTieuCot, ghiRoItem, value),
              chiTieuCot: chiTieuCot,
              chiTieuDong: chiTieuDong,
              showDvtTheoChiTieuDong:
                  question.buocNhay == 'exit' ? true : false,
              enable: (question.maCauHoi == "A1" &&
                      question.maPhieu == AppDefine.maPhieuVT &&
                      chiTieuCot.maChiTieu == "4")
                  ? false
                  : true,
              value: a1Val,
              validator: (inputValue) =>
                  controller.onValidateInputChiTieuDongCot(
                      question, chiTieuCot, chiTieuDong, inputValue,
                      typing: true,
                      fieldName: fieldNameMaCauHoiMaSo,
                      ghiRoItem: ghiRoItem),
              warningText: warningWithText(question, a1Val,
                  fieldName: fieldNameMaCauHoiMaSo),
            ),
          ],
        );
      });
    }
  }

  renderChiTieuDongCotType3NganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem,
      {String? subName}) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    if (question.maCauHoi == 'A7' &&
        (chiTieuCot.maChiTieu == '3' || chiTieuCot.maChiTieu == "4")) {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      decimalDigits = 2;
    }
    return Obx(() {
      var fieldNameMaCauHoiMaSo = 'C_${chiTieuCot.maChiTieu}';
      var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong.maSo}';

      var a1Val = controller.getValueVTGhiRoByFieldNameFromDB(
          tablePhieuNganhVTGhiRo,
          fieldNameMaCauHoiMaSo,
          ghiRoItem.maCauHoi!,
          ghiRoItem.sTT,
          id: ghiRoItem.id);
      String vKey =
          '${question.maPhieu}${question.maCauHoi}_${fieldNameMaCauHoiMaSo}_${ghiRoItem.maCauHoi}_${ghiRoItem.sTT}_${ghiRoItem.id}';
      if (chiTieuCot.maChiTieu == "4") {
        vKey = '${vKey}_$a1Val';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputIntChiTieu(
            key: ValueKey(vKey),
            type: 'double',
            onChange: (value) =>
                controller.onChangeInputChiTieuDongCotNganhVTGhiRo(
                    question, chiTieuDong, chiTieuCot, ghiRoItem, value),
            chiTieuCot: chiTieuCot,
            chiTieuDong: chiTieuDong,
            subName: subName,
            enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                    (chiTieuCot.maChiTieu == "4"))
                ? false
                : true,
            value: a1Val,
            validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
                question, chiTieuCot, chiTieuDong, inputValue,
                fieldName: fieldNameMaCauHoiMaSo),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
          ),
        ],
      );
    });
  }

  renderQuestionType4NganhVTGhiRo(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      TablePhieuNganhVTGhiRo ghiRoItem,
      {String? subName}) {
    return Obx(() {
      var fieldNameMaCauHoiMaSo = 'C_GhiRo';
      var maCauHoiMaSo = '${chiTieuCot.maCauHoi}_${chiTieuDong.maSo}';
      var a1GhiRoVal = controller.getValueVTGhiRoByFieldNameFromDB(
          tablePhieuNganhVTGhiRo,
          fieldNameMaCauHoiMaSo,
          ghiRoItem.maCauHoi!,
          ghiRoItem.sTT,
          id: ghiRoItem.id);

      return InputStringCTDm(
        key: ValueKey(
            '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeInputChiTieuDongCotNganhVTGhiRo(
            question, chiTieuDong, chiTieuCot, ghiRoItem, value,
            fieldNameVTGhiRo: fieldNameMaCauHoiMaSo),
        titleText: 'Ghi rõ',
        level: 3,
        value: a1GhiRoVal,
        validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
            question, chiTieuCot, chiTieuDong, inputValue,
            fieldName: fieldNameMaCauHoiMaSo),
      );
    });
  }

  buildGhiRoNganhLTA1(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String fieldNameLoaiKhac,
      selectedValue) {
    //  1.5. Loại khác (ghi rõ___________)
    if ((selectedValue == 1 &&
            question.maCauHoi == "A1" &&
            question.maPhieu == AppDefine.maPhieuLT) &&
        fieldNameLoaiKhac == colPhieuNganhLTA1_5_1) {
      var fieldNameGhiRo = colPhieuNganhLTA1_5_GhiRo;
      var ghiRoValue =
          controller.getValueByFieldName(question.bangDuLieu!, fieldNameGhiRo);

      return InputStringCTDm(
        key: ValueKey(
            '${question.maPhieu}${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null,
            fieldNameGhiRo: fieldNameGhiRo),
        titleText: 'Ghi rõ',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            fieldNameGhiRo,
            inputValue,
            5,
            250,
            4,
            true,
            question.maPhieu!),
      );
    }
    return const SizedBox();
  }

  renderChiTieuDongCotType2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp('[0-9]');
    return Obx(() {
      var fieldNameMaCauHoiMaSo = controller.getFieldNameByMaCauChiTieuDongCot(
          chiTieuCot, chiTieuDong)!;
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      String vKey =
          '${question.maPhieu}${question.maCauHoi}_$fieldNameMaCauHoiMaSo';
      if (controller.isA1NganhVT(question, chiTieuDong, chiTieuCot)) {
        if (chiTieuCot.maChiTieu == "4") {
          vKey =
              '${question.maPhieu}${question.maCauHoi}_$fieldNameMaCauHoiMaSo$val';
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputIntChiTieu(
              key: ValueKey(vKey),
              type: 'int',
              onChange: (value) => controller.onChangeInputChiTieuDongCot(
                  question.bangDuLieu!, question.maCauHoi, fieldNameMaCauHoiMaSo, value,
                  question: question,
                  chiTieuCot: chiTieuCot,
                  chiTieuDong: chiTieuDong),
              chiTieuCot: chiTieuCot,
              chiTieuDong: chiTieuDong,
              showDvtTheoChiTieuDong:
                  question.buocNhay == 'exit' ? true : false,
              subName: subName,
              enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                      ((question.maCauHoi == "A1" || question.maCauHoi == "A7") &&
                          question.maPhieu == AppDefine.maPhieuVT &&
                          chiTieuDong.loaiChiTieu == "2" &&
                          (chiTieuCot.maChiTieu == AppDefine.maChiTieu_3 ||
                              chiTieuCot.maChiTieu == AppDefine.maChiTieu_4)))
                  ? false
                  : true,
              value: val,
              validator: (inputValue) =>
                  controller.onValidateInputChiTieuDongCot(
                      question, chiTieuCot, chiTieuDong, inputValue,
                      typing: true, fieldName: fieldNameMaCauHoiMaSo),
              flteringTextInputFormatterRegExp: wFilterInput,
              warningText: buildWarningTextDongCot(question, chiTieuDong, chiTieuCot, fieldNameMaCauHoiMaSo, val)),
        ],
      );
    });
  }

  renderChiTieuDongCotQuestionType3(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    //  return Obx(() {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, fieldNameMaCauHoiMaSo);
    if ((question.maCauHoi == "A7_4" &&
            question.maPhieu == AppDefine.maPhieuTB) ||
        (question.maCauHoi == "A1" &&
            question.maPhieu == AppDefine.maPhieuVT) ||
        (question.maCauHoi == "A7" &&
            question.maPhieu == AppDefine.maPhieuVT) ||
        (question.maCauHoi == "A6_1_M" &&
            question.maPhieu == AppDefine.maPhieuMau)) {
      return renderChiTieuDongCotType3ByMaChiTieu(
          question, chiTieuDong, chiTieuCot,
          value: value);
    }
    return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
    // });
  }

  renderChiTieuDongCotType3ByMaChiTieu(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp('[0-9]');

    return Obx(() {
      var fieldNameMaCauHoiMaSo = controller.getFieldNameByMaCauChiTieuDongCot(
          chiTieuCot, chiTieuDong)!;
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if ((question.maCauHoi == "A7_4" &&
              question.maPhieu == AppDefine.maPhieuTB) ||
          (question.maCauHoi == "A1" &&
              question.maPhieu == AppDefine.maPhieuVT) ||
          (question.maCauHoi == "A7" &&
              question.maPhieu == AppDefine.maPhieuVT)) {
        var aDongCotFieldName = '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
        var aDongCotVal = controller.getValueByFieldName(
            question.bangDuLieu!, aDongCotFieldName);
        if (aDongCotVal == 1) {
          return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
        } else {
          return const SizedBox();
        }
      } else if (question.maCauHoi == "A6_1_M" &&
          question.maPhieu == AppDefine.maPhieuMau) {
        return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
      }
      return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType3(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName}) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    if (question.maCauHoi == 'A8_1' && chiTieuCot.maChiTieu == '2') {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      decimalDigits = 2;
    }

    return Obx(() {
      var fieldNameMaCauHoiMaSo = controller.getFieldNameByMaCauChiTieuDongCot(
          chiTieuCot, chiTieuDong)!;
      if (question.maCauHoi == "A6_1_M" ||
          question.maPhieu == AppDefine.maPhieuMau) {
        if (chiTieuCot.maChiTieu == "1") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_2";
        } else if (chiTieuCot.maChiTieu == "2") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_3";
        } else if (chiTieuCot.maChiTieu == "1_1") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_1_1";
        } else if (chiTieuCot.maChiTieu == "1_2") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_1_2";
        } else if (chiTieuCot.maChiTieu == "16_1") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_6_1";
        } else if (chiTieuCot.maChiTieu == "7_1") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_7_1";
        } else if (chiTieuCot.maChiTieu == "10_1") {
          fieldNameMaCauHoiMaSo = "A6_1_${chiTieuDong.maSo}_10_1";
        }
      }
      var xVal = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      String vKey =
          '${question.maPhieu}${question.maCauHoi}_$fieldNameMaCauHoiMaSo';
      if (controller.isA7NganhVT(question, chiTieuDong, chiTieuCot)) {
        vKey =
            '${question.maPhieu}${question.maCauHoi}_$fieldNameMaCauHoiMaSo$xVal';
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputIntChiTieu(
            key: ValueKey(vKey),
            type: 'double',
            onChange: (value) => controller.onChangeInputChiTieuDongCot(
                question.bangDuLieu!,
                question.maCauHoi,
                fieldNameMaCauHoiMaSo,
                value,
                question: question,
                chiTieuCot: chiTieuCot,
                chiTieuDong: chiTieuDong),
            chiTieuCot: chiTieuCot,
            chiTieuDong: chiTieuDong,
            subName: subName,
            enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                    ((question.maCauHoi == "A1" || question.maCauHoi == "A7") &&
                        question.maPhieu == AppDefine.maPhieuVT &&
                        chiTieuDong.loaiChiTieu == "2" &&
                        (chiTieuCot.maChiTieu == AppDefine.maChiTieu_3 ||
                            chiTieuCot.maChiTieu == AppDefine.maChiTieu_4)))
                ? false
                : true,
            value: xVal,
            validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
                question, chiTieuCot, chiTieuDong, inputValue,
                fieldName: fieldNameMaCauHoiMaSo),
            showDvtTheoChiTieuDong: (question.maPhieu == AppDefine.maPhieuMau &&
                    question.maCauHoi == "A6_1_M" &&
                    chiTieuCot.maChiTieu == "1")
                ? true
                : false,
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
            warningText: buildWarningTextDongCot(
                question, chiTieuDong, chiTieuCot, fieldNameMaCauHoiMaSo, xVal),
          ),
        ],
      );
    });
  }

  renderQuestionType5DmChiTieuDongCot(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String tenDanhMuc) {
    if ((question.maCauHoi == "A1" &&
            question.maPhieu == AppDefine.maPhieuVT) ||
        (question.maCauHoi == "A7" &&
            question.maPhieu == AppDefine.maPhieuVT)) {
      return Obx(() {
        var wFilterInput = RegExp('[0-9]');
        int decimalDigits = 0;
        var fieldName = controller.getFieldNameByMaCauChiTieuDongCot(
            chiTieuCot, chiTieuDong);

        var xVal =
            controller.getValueByFieldName(question.bangDuLieu!, fieldName);
        var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.maPhieu}${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$xVal'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: tenDanhMuc,
              onChange: (value, dmItem) => controller.onSelectDmA1_A7(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  fieldName,
                  value,
                  dmItem,
                  chiTieuDong: chiTieuDong,
                  chiTieuCot: chiTieuCot),
              value: xVal,
              onChangeGhiRo: (value, dmItem) =>
                  controller.onChangeGhiRoDm(question, value, dmItem),
              hienThiTenCauHoi: false,
            ),
            if (chiTieuCot.maChiTieu == '0')
              buildGhiRoNganhLTA1(
                  question, chiTieuDong, chiTieuCot, fieldName, xVal),
          ],
        );
      });
    }

    if (question.maCauHoi == "A1" && question.maPhieu == AppDefine.maPhieuLT) {
      return Obx(() {
        var wFilterInput = RegExp('[0-9]');
        int decimalDigits = 0;
        var fieldName = controller.getFieldNameByMaCauChiTieuDongCot(
            chiTieuCot, chiTieuDong);
        var xVal =
            controller.getValueByFieldName(question.bangDuLieu!, fieldName);
        var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.maPhieu}_${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$xVal'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: tenDanhMuc,
              onChange: (value, dmItem) => controller.onSelectDmLTA1(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  fieldName,
                  value,
                  dmItem,
                  chiTieuDong: chiTieuDong,
                  chiTieuCot: chiTieuCot),
              value: xVal,
              onChangeGhiRo: (value, dmItem) =>
                  controller.onChangeGhiRoDm(question, value, dmItem),
              hienThiTenCauHoi: false,
            ),
            if (xVal == 1 &&
                chiTieuDong.maSo ==
                    '5') //chiTieuDong.loaiChiTieu == AppDefine.loaiChiTieu_3
              buildGhiRoNganhLTA1(
                  question, chiTieuDong, chiTieuCot, fieldName, xVal),
          ],
        );
      });
    }

    return Obx(() {
      var wFilterInput = RegExp('[0-9]');
      int decimalDigits = 0;
      var fieldName =
          controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong);
      //'${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_${chiTieuCot.maChiTieu}';
      var xVal =
          controller.getValueByFieldName(question.bangDuLieu!, fieldName);
      var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey(
                '${question.maPhieu}${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$xVal'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: tenDanhMuc,
            onChange: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                fieldName,
                value,
                dmItem,
                chiTieuDong: chiTieuDong,
                chiTieuCot: chiTieuCot),
            value: xVal,
            onChangeGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
            hienThiTenCauHoi: false,
          ),
          buildWarningText(question, xVal, isShow: false),
          buildGhiRo(question, xVal),
        ],
      );
    });
  }

  renderQuestionType5DmChiTieuDongCotA9_4(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, String tenDanhMuc) {
    return Obx(() {
      var fieldName =
          controller.getFieldNameByMaCauChiTieuDongCotA9_4(chiTieuDong);
      //'${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_${chiTieuCot.maChiTieu}';
      var val = controller.getValueByFieldName(question.bangDuLieu!, fieldName);
      var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey(
                '${question.maPhieu}${question.cauHoiUUID}_${chiTieuDong.maSo}'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: tenDanhMuc,
            onChange: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                fieldName,
                value,
                dmItem),
            value: val,
            onChangeGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
            hienThiTenCauHoi: false,
          ),
        ],
      );
    });
  }

  renderQuestionType7(QuestionCommonModel question) {
    return Obx(() {
      var a4_3Value = controller.getValueByFieldName(question.bangDuLieu!,
          colPhieuMauTBA9_M); //9. Trong năm 2025, cơ sở có hoạt động logictics
      if (a4_3Value == 1) {
        var val = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        return Column(
          children: [
            SelectMultipleIntDm(
              question: question,
              key: ValueKey('${question.maPhieu}${question.cauHoiUUID}'),
              listValue: controller.parseDmLogisticToChiTieuModel() ?? [],
              onChange: (value) => controller.onSelect(question.bangDuLieu!,
                  question.maCauHoi!, question.maCauHoi!, value.join(';')),
              value: val,
            ),
            buildWarningText(question, val),
            if ((val.toString().contains("1") ||
                    val.toString().contains("2")) &&
                question.danhSachCauHoiCon!.isNotEmpty)
              buildSubQuestionA4_4(question),
          ],
        );
      }
      return const SizedBox();
    });
  }

  buildSubQuestionA4_4(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> subQuestions = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: subQuestions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel subQuestionsItem = subQuestions[index];
            return renderQuestionType3A4_4(subQuestionsItem);
          });
    }
  }

  renderQuestionType3A4_4(QuestionCommonModel question) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    var a10MVal = controller.getValueByFieldName(
        question.bangDuLieu!, colPhieuMauTBA10_M);
    if (a10MVal.toString().contains("1") &&
        question.maCauHoi == colPhieuMauTBA10_1_M) {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return InputInt(
        key: ValueKey(
            '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
        question: question,
        onChange: (value) => controller.onChangeInput(question.maPhieu!,
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        value: val,
        type: 'double',
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true,
            question.maPhieu!),
        flteringTextInputFormatterRegExp: wFilterInput,
        decimalDigits: decimalDigits,
        warningText: warningWithText(question, val),
      );
    } else if (a10MVal.toString().contains("2") &&
        question.maCauHoi == colPhieuMauTBA10_2_M) {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return InputInt(
        key: ValueKey(
            '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
        question: question,
        onChange: (value) => controller.onChangeInput(question.maPhieu!,
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        value: val,
        type: 'double',
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true,
            question.maPhieu!),
        flteringTextInputFormatterRegExp: wFilterInput,
        decimalDigits: decimalDigits,
        warningText: warningWithText(question, val),
      );
    }
    return const SizedBox();
  }

  buildSubQuestion(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> subQuestions = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: subQuestions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel subQuestionsItem = subQuestions[index];

            switch (subQuestionsItem.loaiCauHoi) {
              case 4:
                return _renderQuestionType4(subQuestionsItem);
              case 3:
                return _renderQuestionType3(subQuestionsItem);

              default:
                return Container();
            }
          });
    }
  }

  ///Phần V
  buildPhanV(QuestionCommonModel mainQuestion, {String? subName}) {
    return Obx(() {
      // var yesNoMoreProduct =
      //     controller.getValueA5_0(mainQuestion.bangChiTieu!, "A5_0");
      var a5_7Value =
          controller.getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA5T);
      if (controller.tblPhieuMauTBSanPham != null &&
          controller.tblPhieuMauTBSanPham.isNotEmpty) {
        if (mainQuestion.danhSachCauHoiCon != null &&
            mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
          var lastProduct = controller.tblPhieuMauTBSanPham.lastOrNull;
          int lastStt = 0;
          if (lastProduct != null) {
            lastStt = lastProduct.sTTSanPham!;
          }
          return Column(
              children: controller.tblPhieuMauTBSanPham.map<Widget>((product) {
            List<QuestionCommonModel> questionsCon =
                mainQuestion.danhSachCauHoiCon!;

            var questionA5_7 = questionsCon
                .where((x) => x.maCauHoi == colPhieuMauTBA5T)
                .first; //"A5_7" cũ

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // if (controller.countProduct(tablePhieuMauSanPham) == 1) ...[
                //   InputIntView(
                //     key: ValueKey('${question.maPhieu}${questionA5_7.maCauHoi}_$a5_7Value'),
                //     question: questionA5_7,
                //     onChange: (value) => (),
                //     value: a5_7Value,
                //     enable: false,
                //   ),
                // ],
                if (product.sTTSanPham! == controller.sttProduct.value)
                  ListView.builder(
                      //   key: ValueKey(product),
                      itemCount: questionsCon.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        QuestionCommonModel questionC = questionsCon[index];
                        return questionPhanVItem(questionC, product);
                      })
                else
                  Obx(() {
                    return Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0, 2),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                          border: Border.all(color: greyDarkBorder, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.sTTSanPham! !=
                                controller.sttProduct.value)
                              Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 240, 212, 154),
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 240, 212, 154),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(
                                              5.0))), // Adds a gradient background and rounded corners to the container
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Sản phẩm thứ ${product.sTTSanPham}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 62, 65, 68),
                                              ),
                                            ),
                                            if (controller.allowDeleteProduct(
                                                    product) ==
                                                true)
                                              ElevatedButton(
                                                  onPressed: () {
                                                    controller.onDeleteProduct(
                                                        product.id);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      splashFactory: InkRipple
                                                          .splashFactory,
                                                      foregroundColor:
                                                          Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(AppValues
                                                                  .borderLv1)),
                                                      elevation: 1.0,
                                                      side: const BorderSide(
                                                          color: Colors.red)),
                                                  child: const Text('Xoá')),
                                          ],
                                        ),
                                      ])),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: ListView.builder(
                                  key: ValueKey<QuestionCommonModel>(
                                      mainQuestion),
                                  itemCount: questionsCon.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    QuestionCommonModel questionC =
                                        questionsCon[index];
                                    return questionPhanVItem(
                                        questionC, product);
                                  }),
                            )
                          ],
                        ));
                  }),

                if (lastStt > 0 && lastStt == product.sTTSanPham!) ...[
                  InputIntView(
                    key: ValueKey(
                        '${questionA5_7.maPhieu}${questionA5_7.maCauHoi}_$a5_7Value'),
                    question: questionA5_7,
                    onChange: (value) => (),
                    value: a5_7Value,
                    enable: false,
                    type: "double",
                    decimalDigits: 2,
                    txtStyle: styleMedium.copyWith(color: primaryColor),
                  ),
                  buildError(questionA5_7, a5_7Value),
                  const SizedBox(
                    height: 15,
                  ),
                  if (controller.countHasMoreProduct(tablePhieuMauTBSanPham) >
                      0)
                    Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add_outlined),
                          label: const Text("Thêm sản phẩm"),
                          onPressed: () => controller.addNewRowProduct(),
                          style: ElevatedButton.styleFrom(
                              splashFactory: InkRipple.splashFactory,
                              side: const BorderSide(
                                  width: 1.0, color: primaryLightColor),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppValues.borderLv5),
                              ),
                              foregroundColor: primaryColor),
                        )),
                  const SizedBox(height: 16)
                ]
              ],
            );
          }).toList());
        }
        return const SizedBox();
      }
      return const SizedBox();
    });
  }

  questionPhanVItem(
      QuestionCommonModel question, TablePhieuMauTBSanPham product,
      {QuestionCommonModel? parentQestion}) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    var a5_1_2Val =
        controller.getValueSanPham(question.bangDuLieu!, 'A5_1_2', product.id!);
    switch (question.maCauHoi) {
      case "A5_1":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichTextQuestion(
              question.tenCauHoi ?? '',
              level: question.cap ?? 2,
            ),
            buildPhanVType0Sub(question, product)
          ],
        );
      case "A5_2":
        decimalDigits = 2;
        var a5_2Val = product.a5_2;
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}${question.maCauHoi}-${product.id}-${product.sTTSanPham}'),
          question: question,
          onChange: (value) => controller.onChangeInputPhanV(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          value: a5_2Val,
          type: 'double',
          validator: (String? value) => controller.onValidateInputA5(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              product.id!,
              value ?? value!.replaceAll(' ', ''),
              0,
              0,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              product.sTTSanPham!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          subName: product.a5_1_1 ?? '',
          warningText: warningWithText(question, a5_2Val, product: product),
        );

      default:
        return Container();
    }
  }

  buildPhanVType0Sub(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionCon = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 4:
                return renderPhanVType4(questionConItem, product);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderPhanVType4(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    if (question.maCauHoi == "A5_1_1") {
      //return Obx(() {
      var a5_1_1 = controller.getValueSanPham(
          question.bangDuLieu!, colPhieuMauTBSanPhamA5_1_1, product.id!);

      String vkey =
          '${question.maPhieu}_${question.maCauHoi}_${product.id}_${product.sTTSanPham}_1';

      return InputString(
        //  key: ValueKey<TablePhieuMauTBSanPham>(product),
        key: ValueKey(vkey),
        onChange: (value) => controller.onChangeInputPhanV(
            question.maPhieu!,
            question.bangDuLieu!,
            question.maCauHoi,
            question.maCauHoi,
            product.id!,
            value),
        question: question,
        value: a5_1_1,
        validator: (String? value) => controller.onValidateInputA5(
            question.maPhieu!,
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            product.id!,
            value ?? value!.replaceAll(' ', ''),
            0,
            0,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            product.sTTSanPham!,
            true),
        maxLine: 5,
      );
      // });
    } else if (question.maCauHoi == "A5_1_2") {
      var a5_1_2;
      if (product != null) {
        a5_1_2 = product.a5_1_2;
      }
      return InkWell(
        onTap: () {
          controller.onOpenDialogSearch(question, question.maCauHoi!, product,
              product.id!, product.sTTSanPham!, product.a5_1_1 ?? '', a5_1_2);
        },
        child: IgnorePointer(
            child: InputStringVcpa(
          key: ValueKey(
              '${question.maPhieu}_${question.maCauHoi}_${product.id}_${product.sTTSanPham}_2$a5_1_2'),
          onChange: (value) => controller.onChangeInputPhanV(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          question: question,
          value: a5_1_2,
          validator: (String? value) => controller.onValidateInputA5(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              product.id!,
              value ?? value!.replaceAll(' ', ''),
              0,
              0,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              product.sTTSanPham!,
              true),
          readOnly: false,
          suffix: const Icon(
            Icons.arrow_drop_down,
            color: primaryColor,
          ),
        )),
      );
    }
  }

  renderPhanVType2(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    var val;
    var dvt = '';
    // if (product != null) {
    //   if (question.maCauHoi == "A5_3") {
    //     //   val = product.a5_3;
    //     // } else if (question.maCauHoi == "A5_3_1") {
    //     //   val = product.a5_3_1;
    //     //   dvt = product.donViTinh != null &&
    //     //           product.donViTinh != '' &&
    //     //           question.dVT != null &&
    //     //           question.dVT != ''
    //     //       ? question.dVT!
    //     //           .replaceAll('[ĐVT]', '${product.donViTinh!} ')
    //     //           .replaceAll('  ', ' ')
    //     //       : '';
    //   } else if (question.maCauHoi == "A5_4") {
    //     val = product.a5_2;
    //   }
    // }
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     InputInt(
    //       question: question,
    //       onChange: (value) => controller.onChangeInputPhanV(
    //           question.bangDuLieu!,
    //           question.maCauHoi,
    //           question.maCauHoi,
    //           product.id!,
    //           value),
    //       value: val,
    //       validator: (String? value) => controller.onValidate(
    //           question.bangDuLieu!,
    //           question.maCauHoi!,
    //           question.maCauHoi,
    //           value,
    //           question.giaTriNN,
    //           question.giaTriLN,
    //           question.loaiCauHoi!,
    //           true,question.maPhieu!),
    //       flteringTextInputFormatterRegExp: wFilterInput,
    //       decimalDigits: decimalDigits,
    //       showDtv: true,
    //       rightString: dvt,
    //     ),
    //     renderPhanVType2Sub(question, product)
    //   ],
    // );
  }

  renderPhanVType3(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    var val;
    var dvt = '';
    var a5_1_2Val =
        controller.getValueSanPham(question.bangDuLieu!, 'A5_1_2', product.id!);
    if (product != null) {
      // if (question.maCauHoi == "A5_3") {
      //   val = product.a5_3;
      // } else if (question.maCauHoi == "A5_3_1") {
      //   val = product.a5_3_1;
      //   dvt = product.donViTinh != null &&
      //           product.donViTinh != '' &&
      //           question.dVT != null &&
      //           question.dVT != ''
      //       ? question.dVT!
      //           .replaceAll('[ĐVT]', '${product.donViTinh!} ')
      //           .replaceAll('  ', ' ')
      //       : '';
      // } else if (question.maCauHoi == "A5_4") {
      //   val = product.a5_4;
      // }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputInt(
          key: ValueKey(
              '${question.maPhieu}_${question.maCauHoi}-${product.id}-${product.sTTSanPham}-${question.sTT}-$a5_1_2Val'),
          question: question,
          onChange: (value) => controller.onChangeInputPhanV(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          value: val,
          type: "double",
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true,
              question.maPhieu!),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          showDtv: true,
          rightString: dvt,
        ),
        renderPhanVType3Sub(question, product)
      ],
    );
  }

  renderPhanVType2Sub(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    if (question.danhSachCauHoiCon != null &&
        question.danhSachCauHoiCon!.isNotEmpty) {
      var questionCon = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 2:
                return renderPhanVType2(questionConItem, product);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderPhanVType3Sub(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    if (question.danhSachCauHoiCon != null &&
        question.danhSachCauHoiCon!.isNotEmpty) {
      var questionCon = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 3:
                return renderPhanVType3(questionConItem, product);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderPhanVType5(
      QuestionCommonModel question, TablePhieuMauTBSanPham product) {
    return Obx(() {
      var val = controller.getValueSanPham(
          question.bangDuLieu!, question.maCauHoi!, product.id!);

      var dmChiTieu = controller.tblDmCoKhong;
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey(
                '${question.maPhieu}_${question.cauHoiUUID}${question.maCauHoi}$val'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: tableDmCoKhong,
            onChange: (value, dmItem) => controller.onSelectDmPhanV(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                product.id!,
                value,
                dmItem),
            value: val,
            isbg: true,
          ),
          renderPhanVType5_6_1(question, product)
        ],
      );
    });
  }

  renderPhanVType5_6_1(
      QuestionCommonModel mainQuestion, TablePhieuMauTBSanPham product) {
    if (mainQuestion.danhSachCauHoiCon != null &&
        mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
      var questionCon = mainQuestion.danhSachCauHoiCon!;
      var wFilterInput = RegExp('[0-9]');
      int decimalDigits = 2;
      var a5_6Val =
          controller.getValueByFieldName(tablePhieuNganhTM, colPhieuNganhTMA2);
      if (a5_6Val != null && (a5_6Val == 1 || a5_6Val == '1')) {
        return ListView.builder(
            itemCount: questionCon.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              QuestionCommonModel questionConItem = questionCon[index];
              switch (questionConItem.loaiCauHoi) {
                case 3:
                  var val;
                  if (product != null) {
                    if (questionConItem.maCauHoi == colPhieuNganhTMA3) {
                      val = product.a5_1_1;
                    }
                  }
                  return InputInt(
                    question: questionConItem,
                    onChange: (value) => controller.onChangeInputPhanV(
                        questionConItem.maPhieu!,
                        questionConItem.bangDuLieu!,
                        questionConItem.maCauHoi,
                        questionConItem.maCauHoi,
                        product.id!,
                        value),
                    value: val,
                    type: 'double',
                    validator: (String? value) => controller.onValidate(
                        questionConItem.bangDuLieu!,
                        questionConItem.maCauHoi!,
                        questionConItem.maCauHoi,
                        value,
                        questionConItem.giaTriNN,
                        questionConItem.giaTriLN,
                        questionConItem.loaiCauHoi!,
                        true,
                        questionConItem.maPhieu!),
                    flteringTextInputFormatterRegExp: wFilterInput,
                    decimalDigits: decimalDigits,
                  );
                default:
                  return Container();
              }
            });
      }
      return const SizedBox();
    }
  }

  buildPhanVA5_0(
      QuestionCommonModel questionA5_0, TablePhieuMauTBSanPham product,
      {QuestionCommonModel? parentQuestion}) {
    // return Obx(() {
    var val = controller.getValueA5_0(
        questionA5_0.bangDuLieu!, questionA5_0.maCauHoi!);
    return Column(
      children: [
        NewYesNoQuestion(
          key: ValueKey('${questionA5_0.maPhieu}_${questionA5_0.maCauHoi}_'),
          onChange: (value) => controller.onSelectYesNoProduct(
              questionA5_0.bangDuLieu!,
              questionA5_0.maCauHoi!,
              questionA5_0.maCauHoi!,
              product.id!,
              value),
          question: questionA5_0,
          value: val,
          child: const Column(
            children: [],
          ),
        ),
      ],
    );
    // });
  }

/*****Begin NganhCN***/
  buildNganhCN(QuestionCommonModel mainQuestion, {String? subName}) {
    return Obx(() {
      if (controller.tblPhieuNganhCNDistinctCap5 != null &&
          controller.tblPhieuNganhCNDistinctCap5.isNotEmpty) {
        var lastProduct = controller.tblPhieuNganhCNDistinctCap5.lastOrNull;
        // int lastStt = 0;
        // if (lastProduct != null) {
        //   lastStt = lastProduct.sTT_SanPham!;
        // }
        return Column(
            children: controller.tblPhieuNganhCNDistinctCap5
                .asMap()
                .entries
                .map((entry) {
          int idx = entry.key;
          idx += 1;
          TablePhieuNganhCNCap5 productCap5 = entry.value;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            decoration: BoxDecoration(
              border: Border.all(color: greyDarkBorder, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(children: [
              IntrinsicHeight(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    margin: const EdgeInsets.only(top: 0),
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 234, 232, 226),
                            spreadRadius: 1, // How much the shadow spreads
                            blurRadius: 1, // How blurred the shadow is
                            offset:
                                Offset(0, 1), // X and Y offset of the shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(
                                5.0))), // Adds a gradient background and rounded corners to the container
                    child: Text(
                      "$idx. Sản phẩm ${productCap5.maNganhC5} - ${productCap5.moTaSanPham}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    )),
              ),
              buildNganhCNDetail(mainQuestion, productCap5, subName: subName),
              // if (lastStt > 0 && lastStt == productCap5.sTT_SanPham!) ...[

              if (controller.countHasMoreProductNganhCN(
                      tablePhieuNganhCN, productCap5.maNganhC5 ?? '') >
                  0) ...[
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  margin: const EdgeInsets.all(0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add_outlined),
                        label: Text("Thêm sản phẩm cấp 8"),
                        onPressed: () =>
                            controller.addNewRowProductNganhCN(productCap5),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            side: const BorderSide(
                                width: 1.0, color: primaryLightColor),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppValues.borderLv5),
                            ),
                            foregroundColor: primaryColor),
                      )),
                ),
                const SizedBox(height: 8)
              ]
            ]
                //  ]
                ),
          );
        }).toList());
      }
      return const SizedBox();
    });
  }

  buildNganhCNDetail(
      QuestionCommonModel mainQuestion, TablePhieuNganhCNCap5 productCap5,
      {String? subName}) {
    return Obx(() {
      if (controller.tblPhieuNganhCN != null &&
          controller.tblPhieuNganhCN.isNotEmpty) {
        if (mainQuestion.danhSachCauHoiCon != null &&
            mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
          var tblNganhCN = controller.tblPhieuNganhCN
              .where((x) => x.maNganhC5 == productCap5.maNganhC5)
              .toList();
          // var lastProduct = controller.tblPhieuNganhCN.lastOrNull;
          // int lastStt = 0;
          // if (lastProduct != null) {
          //   lastStt = lastProduct.sTT_SanPham!;
          // }
          return Column(
              children: tblNganhCN.asMap().entries.map((entry) {
            int idxSp = entry.key;
            idxSp += 1;
            TablePhieuNganhCN product = entry.value;
            List<QuestionCommonModel> questionsCon =
                mainQuestion.danhSachCauHoiCon!;

            return Column(
              children: [
                if (product.sTT_SanPham! == controller.sttProduct.value)
                  ListView.builder(
                      //   key: ValueKey(product),
                      itemCount: questionsCon.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        QuestionCommonModel questionC = questionsCon[index];
                        return questionNganhCNItem(
                            questionC, product, productCap5);
                      })
                else
                  Obx(() {
                    return Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 4, 116, 228),
                              width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.sTT_SanPham! !=
                                controller.sttProduct.value)
                              Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 234, 232, 226),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(
                                              5.0))), // Adds a gradient background and rounded corners to the container
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Sản phẩm thứ ${idxSp}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 62, 65, 68),
                                              ),
                                            ),
                                            if (controller
                                                    .allowDeleteProductNganhCN(
                                                        product) ==
                                                true)
                                              ElevatedButton(
                                                  onPressed: () {
                                                    controller
                                                        .onDeleteProductNganhCN(
                                                            product,
                                                            productCap5);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      splashFactory: InkRipple
                                                          .splashFactory,
                                                      fixedSize: Size(80, 24),
                                                      foregroundColor:
                                                          Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(AppValues
                                                                  .borderLv1)),
                                                      elevation: 1.0,
                                                      side: const BorderSide(
                                                          color: Colors.red)),
                                                  child: const Text('Xoá')),
                                          ],
                                        ),
                                      ])),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: ListView.builder(
                                  key: ValueKey<QuestionCommonModel>(
                                      mainQuestion),
                                  itemCount: questionsCon.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    QuestionCommonModel questionC =
                                        questionsCon[index];
                                    return questionNganhCNItem(
                                        questionC, product, productCap5);
                                  }),
                            )
                          ],
                        ));
                  }),
                const SizedBox(
                  height: 8,
                )
              ],
            );
          }).toList());
        }
        return const SizedBox();
      }
      return const SizedBox();
    });
  }

  questionNganhCNItem(QuestionCommonModel question, TablePhieuNganhCN product,
      TablePhieuNganhCNCap5 productCap5,
      {QuestionCommonModel? parentQestion}) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(
          question.tenCauHoi ?? '',
          level: question.cap ?? 2,
        ),
        buildNganhCNType0Sub(question, product, productCap5)
      ],
    );
  }

  buildNganhCNType0Sub(QuestionCommonModel question, TablePhieuNganhCN product,
      TablePhieuNganhCNCap5 productCap5) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionCon = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 0:
                return buildNganhCNType0Sub2(
                    questionConItem, product, productCap5);
              case 3:
                return renderNganhCNType4(
                    questionConItem, product, productCap5);
              case 4:
                return renderNganhCNType4(
                    questionConItem, product, productCap5);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  buildNganhCNType0Sub2(QuestionCommonModel question, TablePhieuNganhCN product,
      TablePhieuNganhCNCap5 productCap5) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionCon = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 0:
                return buildNganhCNType0Sub2(
                    questionConItem, product, productCap5);
              case 3:
                return renderNganhCNType4(
                    questionConItem, product, productCap5);
              case 4:
                return renderNganhCNType4(
                    questionConItem, product, productCap5);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderNganhCNType4(QuestionCommonModel question, TablePhieuNganhCN product,
      TablePhieuNganhCNCap5 productCap5) {
    if (question.maCauHoi == "A1_1") {
      return Obx(() {
        var a1_1 = controller.getValueSanPham(
            question.bangDuLieu!, colPhieuNganhCNA1_1, product.id!);

        String vkey =
            '${question.maPhieu}_${question.maCauHoi}_${product.id}_${product.maNganhC5}_${product.sTT_SanPham}_1';

        return InputString(
          key: ValueKey(vkey),
          onChange: (value) => controller.onChangeInputPhanV(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          question: question,
          value: a1_1,
          validator: (String? value) => controller.onValidateNganhCN(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              product.id!,
              value ?? value!.replaceAll(' ', ''),
              0,
              0,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              product.sTT_SanPham!,
              true),
          maxLine: 5,
          warningText: warningWithText(question, a1_1, product: product),
        );
      });
    } else if (question.maCauHoi == "A1_2") {
      var a1_2;
      if (product != null) {
        a1_2 = product.a1_2;
      }
      return InkWell(
        onTap: () {
          controller.onOpenDialogSearchCap8(
              question,
              question.maCauHoi!,
              product,
              product.id!,
              product.sTT_SanPham!,
              product.a1_1 ?? '',
              a1_2,
              productCap5);
        },
        child: IgnorePointer(
            child: InputStringVcpa(
          key: ValueKey(
              '${question.maPhieu}_${question.maCauHoi}_${product.id}_${product.sTT_SanPham}_2$a1_2'),
          onChange: (value) => controller.onChangeInputPhanV(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          question: question,
          value: a1_2,
          validator: (String? value) => controller.onValidateNganhCN(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              product.id!,
              value ?? value!.replaceAll(' ', ''),
              0,
              0,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              product.sTT_SanPham!,
              true),
          readOnly: false,
          suffix: const Icon(
            Icons.arrow_drop_down,
            color: primaryColor,
          ),
          warningText: warningWithText(question, a1_2, product: product),
        )),
      );
    } else if (question.maCauHoi == "A2_1") {
      return Obx(() {
        var a2_1 = controller.getValueSanPham(
            question.bangDuLieu!, colPhieuNganhCNA2_1, product.id!);

        String vkey =
            '${question.maPhieu}_${question.maCauHoi}_${product.id}-${product.maNganhC5}_${product.sTT_SanPham}_3_$a2_1';

        return InputString(
          key: ValueKey(vkey),
          onChange: (value) => controller.onChangeInputPhanV(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          question: question,
          value: a2_1,
          validator: (String? value) => controller.onValidateNganhCN(
              question.maPhieu!,
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              product.id!,
              value ?? value!.replaceAll(' ', ''),
              0,
              0,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              product.sTT_SanPham!,
              true),
          enable: false,
        );
      });
    } else if (question.maCauHoi == "A2_2") {
      return renderNganhCNType3(question, product, productCap5);
    }
    return const SizedBox();
  }

  renderNganhCNType3(QuestionCommonModel question, TablePhieuNganhCN product,
      TablePhieuNganhCNCap5 productCap5) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    return Obx(() {
      var val;
      var dvt = '';
      var a2_1Val = controller.getValueSanPham(
          question.bangDuLieu!, colPhieuNganhCNA2_2, product.id!);
      if (product != null) {
        if (question.maCauHoi == "A2_2") {
          val = product.a2_2;
          dvt = product.a2_1 ?? '';
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}_${question.maCauHoi}-${product.id}-${product.maNganhC5}-${product.sTT_SanPham}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInputPhanV(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                product.id!,
                value),
            value: val,
            type: "double",
            validator: (String? value) => controller.onValidateNganhCN(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                product.id!,
                value ?? value!.replaceAll(' ', ''),
                0,
                0,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                product.sTT_SanPham!,
                true),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
            showDtv: true,
            rightString: dvt,
            warningText: warningWithText(question, val, product: product),
          ),
        ],
      );
    });
  }

/*****End: NganhCN***/
  buildNganhTM(QuestionCommonModel question, {String? subName}) {
    //  return Obx(() {
    if (question.danhSachCauHoiCon != null &&
        question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionsCon = question.danhSachCauHoiCon!;
      return Column(children: [
        ListView.builder(
            //   key: ValueKey(product),
            itemCount: questionsCon.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              QuestionCommonModel questionC = questionsCon[index];
              return buildNganhTMDetail(questionC, parentQuestion: question);
            })
      ]);
    }

    return const SizedBox();
    // });
  }

  buildNganhTMDetail(QuestionCommonModel mainQuestion,
      {QuestionCommonModel? parentQuestion, String? subName}) {
    return Obx(() {
      var a1TValue =
          controller.getValueByFieldName(tablePhieuNganhTM, colPhieuNganhTMA1T);
      if (controller.tblPhieuNganhTMSanPhamView != null &&
          controller.tblPhieuNganhTMSanPhamView.isNotEmpty) {
        if (mainQuestion.danhSachCauHoiCon != null &&
            mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
          var lastProduct = controller.tblPhieuNganhTMSanPhamView.lastOrNull;
          int lastStt = 0;
          if (lastProduct != null) {
            lastStt = lastProduct.sTT_SanPham!;
          }
          var questionA1T = parentQuestion!.danhSachCauHoiCon!
              .where((x) => x.maCauHoi == colPhieuNganhTMA1T)
              .first;
          return Column(
              children: controller.tblPhieuNganhTMSanPhamView
                  .asMap()
                  .entries
                  .map((entry) {
            var idx = entry.key;
            idx = idx + 1;
            var product = entry.value;
            List<QuestionCommonModel> questionsCon =
                mainQuestion.danhSachCauHoiCon!;

            return Column(
              children: [
                //  Obx(() {
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                      border: Border.all(color: greyDarkBorder, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 240, 212, 154),
                                    Color.fromARGB(255, 234, 232, 226),
                                    Color.fromARGB(255, 234, 232, 226),
                                    Color.fromARGB(255, 240, 212, 154),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(
                                        5.0))), // Adds a gradient background and rounded corners to the container
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${idx}. Mã sản phẩm: ${product.maNganhC5}",// - Ngành: ${product.maLV}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 62, 65, 68),
                                        ),
                                      ),
                                      if (product.maLV != null &&
                                          product.maLV != '')
                                        Text(
                                          "Ngành: ${product.maLV}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 62, 65, 68),
                                          ),
                                        ),
                                    ],
                                  ),
                                ])),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: ListView.builder(
                              key: ValueKey<QuestionCommonModel>(mainQuestion),
                              itemCount: questionsCon.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                QuestionCommonModel questionC =
                                    questionsCon[index];
                                return buildNganhTMItem(questionC, product);
                              }),
                        )
                      ],
                    )),
                //}),
                if (lastStt > 0 && lastStt == product.sTT_SanPham!) ...[
                  InputIntView(
                    key: ValueKey(
                        '${questionA1T.maPhieu}${questionA1T.maCauHoi}_$a1TValue'),
                    question: questionA1T,
                    onChange: (value) => (),
                    value: a1TValue,
                    enable: false,
                    type: "double",
                    hintText: "Tự động tính",
                    decimalDigits: 2,
                    txtStyle: styleMedium.copyWith(color: primaryColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ]
              ],
            );
          }).toList());
        }
        return const SizedBox();
      }
      return const SizedBox();
    });
  }

  buildNganhTMItem(
      QuestionCommonModel question, TablePhieuNganhTMSanPhamView product,
      {QuestionCommonModel? parentQestion}) {
    // controller.getValueSanPham(question.bangDuLieu!, 'A5_1_2', product.id!);
    //  switch (question.maCauHoi) {
    //  case "A1":
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [renderNganhTMType(question, product)],
    );

    //  default:
    //     return Container();
    //   }
  }

  renderNganhTMType(
      QuestionCommonModel question, TablePhieuNganhTMSanPhamView product) {
    if (question.maCauHoi == "A1_1") {
      var a1_1Val = controller.getValueSanPhamByStt(tablePhieuMauTBSanPham,
          colPhieuMauTBSanPhamA5_1_1, product.sTT_SanPham!);
      String vkey =
          '${question.maPhieu}_${question.maCauHoi}_${product.id}_${product.sTT_SanPham}';

      return TextString(
        //  key: ValueKey<TablePhieuMauTBSanPham>(product),
        key: ValueKey(vkey),
        question: question,
        value: a1_1Val,
        enable: false,
        textStyle: styleMedium.copyWith(color: primaryDarkColor),
        borderColor: greyDarkBorder,
      );
      // });
    } else if (question.maCauHoi == 'A1_2') {
      var wFilterInput = RegExp('[0-9]');
      int decimalDigits = 2;
      var val = product.a1_2;
      var dvt = 'Triệu đồng';
      // var a5_1_2Val = controller.getValueSanPham(
      //     question.bangDuLieu!, 'A1_2', product.id!);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputInt(
            key: ValueKey(
                '${question.maPhieu}_${question.maCauHoi}-${product.id}-${product.sTT_SanPham}-${question.sTT}'),
            question: question,
            onChange: (value) => controller.onChangeInputPhanV(
                question.maPhieu!,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                product.id!,
                value),
            value: val,
            type: "double",
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true,
                question.maPhieu!),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
            showDtv: true,
            rightString: dvt,
            warningText: warningWithText(question, val, product: product),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  buildError(
    QuestionCommonModel question,
    value,
  ) {
    if (question.maCauHoi == colPhieuMauTBA1_3_5) {
      var a1_3_2val = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_3_2);
      if (value == 6 && a1_3_2val > 2008) {
        return Text(
          'Lỗi: Dưới 17 tuổi mà đã tốt nghiệp cao đẳng.',
          style: const TextStyle(color: errorColor),
        );
      }
      if (value == 7 && a1_3_2val > 2006) {
        return Text(
          'Lỗi: Tuổi dưới 19 mà tốt nghiệp đại học.',
          style: const TextStyle(color: errorColor),
        );
      }
      if (value == 8 && a1_3_2val > 2005) {
        return Text(
          'Lỗi: Dưới 20 tuổi mà đã tốt nghiệp thạc sỹ.',
          style: const TextStyle(color: errorColor),
        );
      }
      if ((value == 9 || value == 10) && a1_3_2val > 2002) {
        return Text(
          'Lỗi: Dưới 23 tuổi mà tốt nghiệp trình độ tiến sỹ hoặc sau tiến sỹ.',
          style: const TextStyle(color: errorColor),
        );
      }
    } else if (question.maCauHoi == colPhieuMauTBA5T &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var validRes = controller.onValidateInputA5T(
          question.maPhieu!, question.bangDuLieu!, question.maCauHoi!, true);
      if (validRes != null && validRes != '') {
        return Text(
          validRes,
          style: const TextStyle(color: errorColor, fontSize: 13.0),
          textAlign: TextAlign.left,
        );
      }
    }
    //else if (question.maCauHoi == colPhieuNganhVTA5 &&
    //     question.maPhieu == AppDefine.maPhieuVT) {
    //   var validRes = controller.onValidateA1VTHK(question, null, null,
    //       colPhieuNganhVTA5, value != null ? value.toString() : '',
    //       typing: true);
    //   if (validRes != null && validRes != '') {
    //     return Padding(
    //       padding: EdgeInsets.only(left: 16.0),
    //       child: Text(
    //         validRes,
    //         style: const TextStyle(color: errorColor, fontSize: 13.0),
    //         textAlign: TextAlign.left,
    //       ),
    //     );
    //   }
    // }
    else if (question.maCauHoi == "A6_1_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var validResHK = controller.doanhThuNganhVTHK.value > 0 &&
          controller.tongKhoiLuongTieuDungNangLuong.value == 0;
      var validResHH = controller.doanhThuNganhVTHH.value > 0 &&
          controller.tongKhoiLuongTieuDungNangLuong.value == 0;
      if (validResHK) {
        var doanhThuHKText = toCurrencyString(
            controller.doanhThuNganhVTHK.value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return Text(
          'Doanh thu tại C5.2_ngành Vận tải hành khách ($doanhThuHKText) > 0 và C1_Khối lượng tiêu dùng tất cả năng lượng = 0',
          style: const TextStyle(color: errorColor, fontSize: 13.0),
          textAlign: TextAlign.left,
        );
      }
      if (validResHH) {
        var doanhThuHHText = toCurrencyString(
            controller.doanhThuNganhVTHH.value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return Text(
          'Doanh thu tại C5.2_ngành Vận tải hàng hóa ($doanhThuHHText) > 0 và C1_Khối lượng tiêu dùng tất cả năng lượng = 0',
          style: const TextStyle(color: errorColor, fontSize: 13.0),
          textAlign: TextAlign.left,
        );
      }
    } else if (question.maCauHoi == "A6_1" &&
        question.maPhieu == AppDefine.maPhieuTB) {
      //Cơ sở thuộc ngành 49. Dịch vụ vận tải đường sắt, đường bộ và đường ống hoặc mã 50.
      //Dịch vụ vận tải đường thủy (trừ mã 49313 hoặc 49334) mà C6.1 mã 1 đến mã 9 đều =2. không;

      List<String> a6_1Cot1Val = [];
      for (var i = 1; i <= 9; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var a8_1_x_1Value =
            controller.getValueByFieldName(question.bangDuLieu!, fName1);
        if (a8_1_x_1Value != null) {
          if (a8_1_x_1Value.toString() == '2') {
            a6_1Cot1Val.add(a8_1_x_1Value.toString());
          }
        }
      }

      if (a6_1Cot1Val.isNotEmpty && a6_1Cot1Val.length == 9) {
        var vcpa49_50 = controller.validateA6_1MaSanPhamPhanV();
        if (vcpa49_50 == '49') {
          String msg =
              'Cơ sở thuộc ngành 49. Dịch vụ vận tải đường sắt, đường bộ và đường ống mà không sử dụng năng lượng điện/than/xăng/các loại dầu (C6.1 mã 1 đến mã 5 đều chọn mã 2. Không)?';
          return Text(
            msg,
            style: const TextStyle(color: errorColor, fontSize: 13.0),
            textAlign: TextAlign.left,
          );
        }
        if (vcpa49_50 == '50') {
          String msg =
              'Cơ sở thuộc ngành 50. Dịch vụ vận tải đường thủy (trừ mã 49313 hoặc 49334) mà không sử dụng năng lượng điện/than/xăng/các loại dầu (C6.1 mã 1 đến mã 5 đều chọn mã 2. Không)?';
          return Text(
            msg,
            style: const TextStyle(color: errorColor, fontSize: 13.0),
            textAlign: TextAlign.left,
          );
        }
      }

      List<String> a6_1Cot1Val2 = [];
      for (var i = 1; i <= 11; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var a8_1_x_1Value =
            controller.getValueByFieldName(question.bangDuLieu!, fName1);

        if (a8_1_x_1Value != null) {
          if (a8_1_x_1Value.toString() == '2') {
            a6_1Cot1Val2.add(a8_1_x_1Value.toString());
          }
        }
      }
      if (a6_1Cot1Val2.isNotEmpty && a6_1Cot1Val2.length == 9) {
        var vcpa49_50 = controller.validateA6_1MaSanPhamPhanV();
        if (vcpa49_50 == '50') {
          String msg =
              'Ngành là dịch vụ lưu trú (Mã ngành cấp 2 là 55) mà không sử dụng bất kỳ loại năng lượng nào?';
          return Text(
            msg,
            style: const TextStyle(color: errorColor, fontSize: 13.0),
            textAlign: TextAlign.left,
          );
        }
      }
    }
    return const SizedBox();
  }

  buildWarningText(QuestionCommonModel question, selectedValue,
      {String? fieldName, bool? isShow}) {
    if (question.maCauHoi == colPhieuMauTBA1_3_2 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var a1_3_2Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_3_2);
      if (controller.validateNotEmptyString(a1_3_2Value.toString())) {
        if (a1_3_2Value < 1946 || a1_3_2Value > 2008) {
          return wText(
              'Câu 1.3.2 "Chủ cơ sở nhỏ hơn 18 tuổi Chủ cơ sở lớn hơn 80 tuổi');
        }
      }
      return const SizedBox();
    } else if (question.maCauHoi == colPhieuMauTBA1_3_5 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (controller
          .validateEmptyString(selectedValue.toString().replaceAll(' ', ''))) {
        return const SizedBox();
      }

      var a1_3_2Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_3_2);
      var tblTDCM = controller.tblDmTrinhDoChuyenMon
          .where((x) => x.ma == selectedValue)
          .firstOrNull;
      String selectedText = tblTDCM!.ten ?? '';
      if (selectedValue == 1) {
        return wText('$selectedText.');
      }
      if (selectedValue == 2) {
        return wText('$selectedText.');
      }
      if (selectedValue == 3) {
        return wText('$selectedText.');
      }
      if (selectedValue == 4) {
        return wText('$selectedText.');
      }
      if (selectedValue == 6 && (a1_3_2Value == 2007 || a1_3_2Value == 2008)) {
        return wText(
            'Năm sinh = $a1_3_2Value mà tốt nghiệp trình độ cao đẳng (=6).');
      }
      if (selectedValue == 7 && (a1_3_2Value == 2005 || a1_3_2Value == 2006)) {
        return wText(
            'Năm sinh = $a1_3_2Value mà tốt nghiệp trình độ đại học  (=7).');
      }
      if (selectedValue == 7 && (a1_3_2Value == 2003 || a1_3_2Value == 2004)) {
        return wText(
            'Năm sinh = $a1_3_2Value mà tốt nghiệp trình độ tiến sỹ trở lên (=8).');
      }
      if (selectedValue == 7 && (a1_3_2Value == 2001 || a1_3_2Value == 2002)) {
        return wText(
            'Năm sinh = $a1_3_2Value mà tốt nghiệp trình độ tiến sỹ trở lên (=9|10).');
      }
      return const SizedBox();
    } else if (question.maCauHoi == colPhieuMauTBA1_5 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      //Quoc tich
      var a1_3_4Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_3_4);
      var a1_4Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_4);
      var a1_5_1Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_5_1);
      if (selectedValue != null && selectedValue == 1) {
        return const SizedBox();
      }
      if (a1_5_1Value == null || a1_5_1Value == '') {
        //Cơ sở có đăng ký kinh doanh mà không có mã số thuế?
        return wText('Cơ sở có đăng ký kinh doanh mà không có mã số thuế?.');
      } else if (a1_4Value == 1 && selectedValue == 2) {
        return wText(
            'Cơ sở Có giấy chứng nhận đăng ký kinh doanh (C1.4=1) mà Không có MST (C1.5=2)?');
      } else if (a1_4Value == 2 && selectedValue == 1) {
        return wText(
            'Cơ sở Chưa có giấy chứng nhận đăng ký kinh doanh (C1.4=2) mà Có MST (C1.5=1)');
      } else if (a1_4Value == 3 && selectedValue == 1) {
        return wText(
            'Cơ sở Đã đăng ký kinh doanh nhưng chưa được cấp (C1.4=3) mà có mã số thuế (C1.5=1)');
      } else if (a1_4Value == 4 && selectedValue == 1) {
        return wText(
            'Cơ sở Đã đăng ký kinh doanh nhưng chưa được cấp (C1.4=3) mà có mã số thuế (C1.5=1)');
      } else if (a1_3_4Value == 1 &&
          a1_5_1Value != null &&
          a1_5_1Value != '' &&
          a1_5_1Value.toString().length == 12) {
        return wText(
            'Chủ cơ sở là người có quốc tịch Việt Nam mà MST  khác 12  số (Quốc tịch Việt Nam MST cơ sở chính là CCCD 12 chữ số)?');
      } else if (a1_3_4Value == 2 &&
          a1_5_1Value != null &&
          a1_5_1Value != '' &&
          a1_5_1Value.toString().length == 10) {
        return wText('Chủ cơ sở là người nước ngoài  mà MST khác 10 chữ số?');
      }
    } else if (question.maCauHoi == colPhieuMauTBA3_1T &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (selectedValue != null &&
          controller.validateEqual0InputValue(
              selectedValue.toString().replaceAll(' ', ''))) {
        return wText('Cơ sở không có TSCĐ có đúng không?');
      }
    } else if (question.maCauHoi == colPhieuMauTBA3_2 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var a3_2Val = selectedValue != null
          ? AppUtils.convertStringToDouble(
              selectedValue.toString().replaceAll(' ', ''))
          : 0;
      if (a3_2Val != null && a3_2Val > 30000) {
        return wText('Số tiền vốn bỏ ra quá lớn> 30 tỷ');
      }
    } else if (question.maCauHoi == colPhieuMauTBA4_1 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (selectedValue != null && selectedValue < 3) {
        return wText('Cơ sở có số tháng kinh doanh<3');
      }
    } else if (question.maCauHoi == colPhieuMauTBA4T &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var a4TValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA4T);
      var a3_2Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA3_2);
      if (a4TValue != null && a3_2Value != null && a4TValue < a3_2Value) {
        var a4TValueText = toCurrencyString(a4TValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        var a3_2ValueText = toCurrencyString(a3_2Value.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return wText(
            'Tổng doanh thu (gồm tiền vốn và lãi) ($a4TValueText)  < Số tiền vốn tại thời điểm 31/12/2025 ở C3.2 ($a3_2ValueText)');
      }
    } else if (question.maCauHoi == "A6_1" &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (isShow != null && isShow == false) {
        return const SizedBox();
      }
      var a3_1_2_1TB = controller.getValueByFieldName(
          tablePhieuMauTB, colPhieuMauTBA3_1_2_1);
      List<String> a6_1Cot1Val = [];
      for (var i = 1; i <= 9; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var a6_1_x_1Value =
            controller.getValueByFieldName(tablePhieuMauTB, fName1);

        if (a6_1_x_1Value != null) {
          if (a6_1_x_1Value.toString() == '2') {
            a6_1Cot1Val.add(fName1);
          }
        }
      }
      if (a6_1Cot1Val.isNotEmpty && a6_1Cot1Val.length == 9) {
        if (a3_1_2_1TB != null && a3_1_2_1TB > 0) {
          //
          return wText(
              'Cơ sở có TSCĐ là phương tiện vận tải (C3.1.2>0) mà Không sử dụng bất kỳ loại năng lượng nào cho phương tiện vận tải (C6.1_ các mã từ 1 đến 9 đều =2. Không)?');
        }
        var resCN = controller.validateA6_1MaSanPhamPhanV();
        if (resCN == 'cn10to39') {
          return wText(
              'Mã ngành cấp 2 thuộc ngành Công nghiệp (Mã ngành>=10 vaf <=39) mà không sử dụng bất kỳ loại năng lượng nào cho phương tiện vận tải (C6.1_ các mã từ 1 đến 9 đều =2. Không)?');
        }
        if (resCN == '4647') {
          return wText(
              'Mã ngành cấp 2 thuộc ngành Bán buôn, bán lẻ (Mã ngành=46|47) mà Không sử dụng bất kỳ loại năng lượng nào cho phương tiện vận tải (C6.1_ các mã từ 1 đến 9 đều =2. Không)?');
        }
      } else {
        return const SizedBox();
      }

      List<String> a6_1Cot1Val2 = [];
      for (var i = 1; i <= 11; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var a6_1_x_1Value =
            controller.getValueByFieldName(tablePhieuMauTB, fName1);

        if (a6_1_x_1Value != null) {
          if (a6_1_x_1Value.toString() == '2') {
            a6_1Cot1Val2.add(a6_1_x_1Value.toString());
          }
        }
      }
      if (a6_1Cot1Val2.isNotEmpty) {
        return wText(
            'Cơ sở không sử dụng bất kỳ loại năng lượng nào cho hoạt động SXKD của cơ sở có đúng không?');
      }
    } else if (question.maCauHoi == colPhieuMauTBA7_1 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (selectedValue != null && selectedValue == 2) {
        var res = controller.validateA6_1MaSanPhamPhanV();
        if (res == "93290") {
          return wText(
              'Mã ngành sản phẩm = 93290. Dịch vụ vui chơi giải trí khác mà Không sử dụng internet (C7.1=2)');
        }
        if (res == '62010To62090') {
          return wText(
              'Mã ngành thuộc ngành 62. Dịch vụ lập trình máy tính, tư vấn và dịch vụ khác liên quan đến máy tính mà Không sử dụng internet (C7.1=2)');
        }
      }
    } else if (question.maCauHoi == colPhieuMauTBA7_3 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var a4TValue =
          controller.getValueByFieldName(tablePhieuMauTB, colPhieuMauTBA4T);

      if (a4TValue != null && controller.validateEqual0InputValue(a4TValue)) {
        return wText(
            'Hộ có bán sản phẩm trên internet mà tỷ trọng doanh thu bằng 0? (Cơ sở chưa có doanh thu có đúng không?)');
      }
    } else if (question.maCauHoi == colPhieuNganhVTA1_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      var a1MValue = controller.getValueByFieldName(
          tablePhieuNganhVT, colPhieuNganhVTA1_M);

      if (a1MValue != null && controller.validateEqual0InputValue(a1MValue)) {
        return wText(
            'Cơ sở hoạt động vận tải mà số chuyến vận chuyển hành khách =0 ?');
      }
      int a1MVal = a1MValue != null ? AppUtils.convertStringToInt(a1MValue) : 0;
      if (a1MVal != null && a1MVal > 100) {
        return wText(
            'Số chuyển vận chuyển khách bình quân 1 tháng > 100 chuyến có đúng không?');
      }
    } else if (question.maCauHoi == colPhieuNganhVTA2_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      var a6TBValue =
          controller.getValueByFieldName(tablePhieuNganhVT, colPhieuNganhVTA6);

      int a6TBVal =
          a6TBValue != null ? AppUtils.convertStringToInt(a6TBValue) : 0;
      int a2MVal = selectedValue != null
          ? AppUtils.convertStringToInt(
              selectedValue.toString().replaceAll(' ', ''))
          : 0;
      if (a6TBVal != null && a2MVal != null && a2MVal > a6TBVal) {
        var a2MValText = toCurrencyString(a2MVal.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);
        var a6TBValText = toCurrencyString(a6TBVal.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 0);
        return wText(
            'Số khách bình quân 1 chuyến tại C2 là $a2MValText hành khách quá nhiều? Số khách bình quân 1 chuyến tại C2 là $a2MValText hành khách > Tổng tải trọng tại C6-VT=$a6TBValText ?');
      }
    } else if (question.maCauHoi == colPhieuNganhVTA3_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      var a3MValue = controller.getValueByFieldName(
          tablePhieuNganhVT, colPhieuNganhVTA3_M);

      double a3MVa =
          a3MValue != null ? AppUtils.convertStringToDouble(a3MValue) : 0;
      if (a3MVa != null && a3MVa > 100) {
        return wText('Số km bình quân 1 chuyến > 100 km có đúng không?');
      }
    } else if (question.maCauHoi == colPhieuNganhVTA6_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      var a6MValue = controller.getValueByFieldName(
          tablePhieuNganhVT, colPhieuNganhVTA6_M);

      if (a6MValue != null && controller.validateEqual0InputValue(a6MValue)) {
        return wText(
            'Cơ sở hoạt động vận tải mà số chuyến vận chuyển hàng hóa =0 ?');
      }
      int a6MVal = a6MValue != null ? AppUtils.convertStringToInt(a6MValue) : 0;
      if (a6MVal != null && a6MVal > 100) {
        return wText(
            ' Số chuyển vận chuyển hàng hóa bình quân 1 tháng > 100 chuyến có đúng không?');
      }
    } else if (question.maCauHoi == colPhieuNganhVTA7_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      var a12TBValue =
          controller.getValueByFieldName(tablePhieuNganhVT, colPhieuNganhVTA12);

      double a12TBVal =
          a12TBValue != null ? AppUtils.convertStringToDouble(a12TBValue) : 0;
      double a7MVal = selectedValue != null
          ? AppUtils.convertStringToDouble(
              selectedValue.toString().replaceAll(' ', ''))
          : 0;
      if (a12TBValue != null && a12TBValue != null && a7MVal > a12TBValue) {
        var a7MValText = toCurrencyString(a7MVal.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        var a12TBValText = toCurrencyString(a12TBValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return wText(
            'Khối lượng hàng hóa bình quân 1 chuyến tại C7 là $a7MValText tấn > Tổng tải trọng tại C12-Phiếu VT = $a12TBValText tấn?');
      }
    } else if (question.maCauHoi == colPhieuNganhVTA8_M &&
        question.maPhieu == AppDefine.maPhieuVTMau) {
      if (selectedValue != null && selectedValue != '') {
        double a8MVal = selectedValue != null
            ? AppUtils.convertStringToDouble(
                selectedValue.toString().replaceAll(' ', ''))
            : 0;
        if (a8MVal != null && a8MVal > 250) {
          return wText('Số km bình quân 1 chuyến > 250 km có đúng không?');
        }
      }
    } else if (question.maCauHoi == colPhieuNganhLTA1_M &&
        question.maPhieu == AppDefine.maPhieuLTMau) {
      if (selectedValue != null && selectedValue != '') {
        if (controller.validateEqual0InputValue(
            selectedValue.toString().replaceAll(' ', ''))) {
          return wText('Lượt khách ngủ qua đêm của cơ sở=0 có đúng không?');
        }
      }
    } else if (question.maCauHoi == colPhieuNganhLTA2_M &&
        question.maPhieu == AppDefine.maPhieuLTMau) {
      if (selectedValue != null && selectedValue != '') {
        if (controller.validateEqual0InputValue(
            selectedValue.toString().replaceAll(' ', ''))) {
          return wText(
              'Lượt khách không ngủ qua đêm của cơ sở=0 có đúng không?');
        }
        var a1_MValue = controller.getValueByFieldName(
            tablePhieuNganhLT, colPhieuNganhLTA1_M);
        double a1_MVal =
            a1_MValue != null ? AppUtils.convertStringToDouble(a1_MValue) : 0;
        double a2_MVal = a1_MValue != null
            ? AppUtils.convertStringToDouble(
                selectedValue.toString().replaceAll(' ', ''))
            : 0;

        if (a2_MVal < a1_MVal) {
          return wText(
              'Số lượt khách không ngủ qua đêm < Số lượt khách ngủ qua đêm có đúng không');
        }
      }
    } else if (question.maCauHoi == colPhieuNganhLTA3_M &&
        question.maPhieu == AppDefine.maPhieuLTMau) {
      if (selectedValue != null && selectedValue != '') {
        var a5Value = controller.getValueByFieldName(
            tablePhieuNganhLT, colPhieuNganhLTA5);
        double a5_MVal =
            a5Value != null ? AppUtils.convertStringToDouble(a5Value) : 0;

        double a3_MVal = a5Value != null
            ? AppUtils.convertStringToDouble(
                selectedValue.toString().replaceAll(' ', ''))
            : 0;

        var c5x31 = a5_MVal * 31;
        if (a3_MVal > c5x31) {
          var a3MText = toCurrencyString(a3_MVal.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 0);
          return wText(
              'Số ngày sử dụng phòng bình quân 1 tháng quá lớn là $a3MText ngày phòng?');
        }
      }
    } else if (question.maCauHoi == colPhieuNganhLTA4_M &&
        question.maPhieu == AppDefine.maPhieuLTMau) {
      if (selectedValue != null && selectedValue != '') {
        var a1_1_1Value = controller.getValueByFieldName(
            tablePhieuNganhLT, colPhieuNganhLTA1_1_1);
        var a1_2_1Value = controller.getValueByFieldName(
            tablePhieuNganhLT, colPhieuNganhLTA1_2_1);
        var a3MValue = controller.getValueByFieldName(
            tablePhieuNganhLT, colPhieuNganhLTA3_M);
        double a3MVal =
            a3MValue != null ? AppUtils.convertStringToDouble(a3MValue) : 0;
        double a4MVal = selectedValue != null
            ? AppUtils.convertStringToDouble(
                selectedValue.toString().replaceAll(' ', ''))
            : 0;
        double resA4ChiaA3 = 0.0;
        if (a4MVal > 0 && a3MVal > 0) {
          resA4ChiaA3 = a4MVal / a3MVal;
        }

        if (a1_1_1Value == 1 && a1_2_1Value == 1 && resA4ChiaA3 > 10) {
          var a3MValText = toCurrencyString(a3MValue.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 1);
          var a4MValText = toCurrencyString(a4MVal.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 1);
          return wText(
              'Số ngày sử dụng giường bình quân tại C4 = $a4MValText > 10 lần số ngày sử dụng phòng tại C3 = $a3MValText ?');
        }
      }
    } else if (question.maCauHoi == colPhieuNganhLTA6_M &&
        question.maPhieu == AppDefine.maPhieuLTMau) {
      var a6_MLTValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuNganhLTA6_M);
      if (a6_MLTValue != null && a6_MLTValue != '') {
        double a6_MVal = a6_MLTValue != null
            ? AppUtils.convertStringToDouble(
                a6_MLTValue.toString().replaceAll(' ', ''))
            : 0;
        if (a6_MVal < 20) {
          return wText(
              'Giá bình quân 1 khách/1 đêm < 20 nghìn đồng có đúng không?');
        }
        if (a6_MVal > 1500) {
          return wText(
              'Giá bình quân 1 khách/1 đêm > 1,5 triệu đồng có đúng không?');
        }
      }
    } else if (question.maCauHoi == "A9_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var a9_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA9_M);
      var a7_3_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_3_M);
      var a7_5_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_5_M);

      if (a9_MValue != null && a9_MValue == 2) {
        if ((a7_3_MValue != null && a7_3_MValue == 1) ||
            (a7_5_MValue != null && a7_5_MValue == 1)) {
          return wText(
              'Cơ sở có hoạt động cung cấp sản phẩm dịch vụ qua website, ứng dụng trực tuyến, nền tảng trung gian (shoppee, booking,…) C3=| C5=1 mà lại không có hoạt động logistic (vận chuyển hàng hóa … ) C9=2?');
        }
      }
    }
    return const SizedBox();
  }

  warningWithText(QuestionCommonModel question, selectedValue,
      {dynamic product, String? fieldName}) {
    if (question.maCauHoi == colPhieuMauTBA4_2 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (selectedValue != null &&
          controller.validateEqual0InputValue(selectedValue)) {
        var a4_1Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA4_1);
        if (a4_1Value != null && a4_1Value > 3) {
          return 'Cảnh báo: Doanh thu cơ sở =0 mà số tháng hoạt động của cơ sở tại C4.1>3 tháng?';
        }
      }
    } else if (question.maCauHoi == colPhieuMauTBA4_3 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var a4_3Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA4_3);
      if (a4_3Value != null && controller.validateEqual0InputValue(a4_3Value)) {
        var a1_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBA1_2);
        if (a1_2Value != null && a1_2Value == 1) {
          return 'Cảnh báo: Cơ sở thuê/mượn địa điểm (C1.2=1) mà C4.3=0. Tiền thuê địa điểm=0';
        }
      }
    } else if (question.maCauHoi == colPhieuMauTBSanPhamA5_2 &&
        question.maPhieu == AppDefine.maPhieuTB) {
      if (product != null) {
        TablePhieuMauTBSanPham? productTMSP = product as TablePhieuMauTBSanPham;
        var a5_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, colPhieuMauTBSanPhamA5_2);
        if (a5_2Value != null &&
            controller.validateEqual0InputValue(a5_2Value)) {
          return productTMSP != null
              ? productTMSP.a5_1_1 != null
                  ? 'Cảnh báo: Doanh thu [SP ${productTMSP.a5_1_1!}] = 0'
                  : 'Cảnh báo: Doanh thu = 0'
              : 'Cảnh báo: Doanh thu = 0';
        }
      }
    } else if (question.maCauHoi == "A1_1" &&
        question.maPhieu == AppDefine.maPhieuCN) {
      if (selectedValue != null && selectedValue.toString().length < 3) {
        return 'Cảnh báo: Mô tả sản phẩm quá ngắn';
      }
    } else if (question.maCauHoi == "A1_2" &&
        question.maPhieu == AppDefine.maPhieuCN) {
      if (selectedValue != null && selectedValue != '') {
        //Mã ngành >=10101001 và <=39000203) và C6.1_1. Điện=2| C6.1_2.Than=2 hoặc C6.1_9_LPG=2
        //(Không sử dụng điện/xăng/LPG cho hoạt động SXKD của cơ sở có đúng không?
        var a6_1_1_1 = controller.getValueByFieldName(
            tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
        var a6_1_2_1 = controller.getValueByFieldName(
            tablePhieuMauTB, colPhieuMauTBA6_1_2_1);
        var a6_1_9_1 = controller.getValueByFieldName(
            tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
        if ((a6_1_1_1 != null && a6_1_1_1 == 2) ||
            (a6_1_2_1 != null && a6_1_2_1 == 2) ||
            (a6_1_9_1 != null && a6_1_9_1 == 2)) {
          var hasSanPham =
              controller.dsMaSanPhamNganhCN.contains(selectedValue);
          if (hasSanPham) {
            return 'Cảnh báo: Mã ngành thuộc ngành Công nghiệp (Mã từ 10101001 đên 39000203) mà Không sử dụng điện/xăng/LPG cho hoạt động SXKD của cơ sở có đúng không (C6.1_1. Điện=2| C6.1_2.Than=2 hoặc C6.1_9_LPG=2)?';
          }
        }
        if (product != null) {
          TablePhieuNganhCN? productCN = product as TablePhieuNganhCN;
          var a5_2TBSp = controller.tblPhieuMauTBSanPham.value
              .where((x) => x.a5_1_2 == productCN!.maNganhC5)
              .firstOrNull;
          if (a5_2TBSp != null) {
            var a5_2Val = a5_2TBSp.a5_2 ?? 0;
            if (a5_2Val > 100) {
              var a2_1Val = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA2_1);
              if (a2_1Val != null && a2_1Val == 1) {
                return 'Cảnh báo: Mã ngành >= 141001111 và Mã ngành <= 14300200. Sản xuất trang phục và doanh thu bình quân 1 tháng tại C5.2 >= 100 triệu mà Tổng số lao động 31/12/2025 chỉ có 1 lao động là chủ cơ sở (C2.1=1) là quá ít so doanh thu quá lớn có đúng không?';
              }
            }
          }
        }
      }
    } else if (question.maCauHoi == "A2_2" &&
        question.maPhieu == AppDefine.maPhieuCN) {
      if (selectedValue != null && selectedValue != '') {
        if (selectedValue > 1000) {
          return 'Cảnh báo: Khối lượng sản phẩm lớn>1000';
        }
      }
    } else if (fieldName == 'C_2' &&
        question.maPhieu == AppDefine.maPhieuVT &&
        question.maCauHoi == "A1") {
      if (selectedValue != null && selectedValue != '') {
        if (selectedValue > 0) {
          var a6_1Dien = controller.getValueByFieldName(
              tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
          var a6_1Xang = controller.getValueByFieldName(
              tablePhieuMauTB, colPhieuMauTBA6_1_3_1);
          var a6_1Diezel = controller.getValueByFieldName(
              tablePhieuMauTB, colPhieuMauTBA6_1_5_1);
          if (a6_1Dien != null &&
              a6_1Dien == 2 &&
              a6_1Diezel != null &&
              a6_1Diezel == 2 &&
              a6_1Dien != null &&
              a6_1Dien == 2) {
            return 'Cảnh báo: Cơ sở vận tải có các loại xe mà không sử dụng năng lượng Xăng, điện, Dầu diezel (C6.1_1=2, C6.1_3=2, C6.1_5=2)';
          }
        }
      }
    } else if (question.maCauHoi == "A5" &&
        question.maPhieu == AppDefine.maPhieuVT) {
      if (selectedValue != null && selectedValue != '') {
        if (selectedValue > 30) {
          return 'Cảnh báo: Tổng số phương tiện của cơ sở > 30 xe/tàu có đúng không?';
        }
      }
    } else if (fieldName == 'C_2' &&
        question.maPhieu == AppDefine.maPhieuVT &&
        question.maCauHoi == "A7") {
      if (selectedValue != null && selectedValue != '') {
        if (selectedValue > 0) {
          var a6_1Dien = controller.getValueByFieldName(
              tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
          var a6_1Xang = controller.getValueByFieldName(
              tablePhieuMauTB, colPhieuMauTBA6_1_3_1);
          var a6_1Diezel = controller.getValueByFieldName(
              tablePhieuMauTB, colPhieuMauTBA6_1_5_1);
          if (a6_1Dien != null &&
              a6_1Dien == 2 &&
              a6_1Diezel != null &&
              a6_1Diezel == 2 &&
              a6_1Dien != null &&
              a6_1Dien == 2) {
            return 'Cảnh báo: Cơ sở vận tải có loại xe/tàu (C8.Số lượng xe >0) mà không sử dụng năng lượng Xăng, điện, Dầu diezel (C6.1_1=2, C6.1_3=2, C6.1_5=2))';
          }
        }
      }
    } else if (question.maCauHoi == "A11" &&
        question.maPhieu == AppDefine.maPhieuVT) {
      if (selectedValue != null && selectedValue != '') {
        if (selectedValue > 30) {
          return 'Cảnh báo: Tổng số phương tiện của cơ sở >30 xe/tàu có đúng không?';
        }
      }
    } else if (question.maCauHoi == "A1_2" &&
        question.maPhieu == AppDefine.maPhieuTM) {
      if (selectedValue != null && selectedValue != '') {
        // Đối với ngành G: 500 < Số tiền vốn < 5
        if (product != null) {
          TablePhieuNganhTMSanPhamView? productTMSP =
              product as TablePhieuNganhTMSanPhamView;
          if (productTMSP != null && productTMSP.maLV == 'G') {
            if (selectedValue < 5) {
              return 'Cảnh báo: Đối với ngành G: C1 số tiền vốn đã bỏ ra nhỏ hơn 5 triệu đồng có đúng không?';
            }
            if (selectedValue > 500) {
              return 'Cảnh báo: Đối với ngành G: C1 số tiền vốn đã bỏ ra lớn hơn 500 triệu đồng có đúng không?';
            }
          }
          //Đối với ngành 6810: 5000 < Số tiền vốn < 500
          if (productTMSP.maNganhC5 != null) {
            if (productTMSP.maNganhC5!.substring(0, 4) == '6810') {
              if (selectedValue < 500) {
                return 'Cảnh báo: Đối với ngành 6810: C1 số tiền vốn đã bỏ ra nhỏ hơn 500 triệu đồng có đúng không?';
              }
              if (selectedValue > 5000) {
                return 'Cảnh báo: Đối với ngành 6810: C1 số tiền vốn đã bỏ ra lớn hơn 5 tỷ đồng có đúng không?';
              }
            }
          }
        }
      }
    } else if (question.maCauHoi == "A7_4_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var a7_4_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_4_M);
      if (a7_4_MValue != null && a7_4_MValue != '') {
        double a7_4_MVal = a7_4_MValue != null
            ? AppUtils.convertStringToDouble(
                a7_4_MValue.toString().replaceAll(' ', ''))
            : 0;
        if (controller.validateEqual0InputValue(a7_4_MVal)) {
          return 'Cơ sở có bán hàng, cung cấp dịch vụ qua Website C3 = 1 mà Tỷ trong doanh thu=0 -> có phải cơ sở chưa có doanh thu hay không?';
        }
      }
    } else if (question.maCauHoi == "A7_6_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var a7_6_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_6_M);
      double a7_6_MVal = a7_6_MValue != null
          ? AppUtils.convertStringToDouble(
              a7_6_MValue.toString().replaceAll(' ', ''))
          : 0;
      if (controller.validateEqual0InputValue(a7_6_MVal)) {
        return 'Cơ sở có bán hàng, cung cấp dịch vụ qua Website C3 = 1 mà Tỷ trong doanh thu=0 -> có phải cơ sở chưa có doanh thu hay không?';
      }
    } else if (question.maCauHoi == "A7_8_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var a7_8_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_8_M);
      double a7_8_MVal = a7_8_MValue != null
          ? AppUtils.convertStringToDouble(
              a7_8_MValue.toString().replaceAll(' ', ''))
          : 0;
      if (a7_8_MVal > 100000) {
        return 'Doanh thu giao đến khách hàng quá lớn >=100 tỷ có đúng không?';
      }
    } else if (question.maCauHoi == "A10_1_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var a10_1_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA10_1_M);
      var a4TValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA4T);

      double a10_1_MVal = a10_1_MValue != null
          ? AppUtils.convertStringToDouble(a10_1_MValue)
          : 0;
      double a4TVal =
          a4TValue != null ? AppUtils.convertStringToDouble(a4TValue) : 0;
      if (a10_1_MVal != null && a10_1_MVal > a4TValue) {
        var a10_1_MValText = toCurrencyString(a10_1_MVal.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        var a4TValueText = toCurrencyString(a4TValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Số tiền chi hoạt động logistic tại 10.1 là $a10_1_MValText triệu đồng > Tổng doanh thu cả năm của cơ sở là $a4TValueText triệu đồng?';
      }
    } else if (question.maCauHoi == "A10_2_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      var a10_2_MValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA10_2_M);
      var a4TValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA4T);

      double a10_2_MVal = a10_2_MValue != null
          ? AppUtils.convertStringToDouble(a10_2_MValue)
          : 0;
      double a4TVal =
          a4TValue != null ? AppUtils.convertStringToDouble(a4TValue) : 0;
      if (a10_2_MVal != null && a10_2_MVal > a4TValue) {
        var a10_1_MValText = toCurrencyString(a10_2_MVal.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        var a4TValueText = toCurrencyString(a4TValue.toString(),
            thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
            mantissaLength: 2);
        return 'Số tiền chi hoạt động logistic tại 10.2 là $a10_1_MValText triệu đồng > Tổng doanh thu cả năm của cơ sở là $a4TValueText triệu đồng?';
      }
    }
  }

  buildWarningTextDongCot(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String fieldName,
      value) {
    if (question.maCauHoi == 'A3_1' &&
        question.maPhieu == AppDefine.maPhieuTB) {
      var a1_2TValue = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA1_2);
      if (value != null && value > 0 && a1_2TValue != null && a1_2TValue == 1) {
        return 'Cảnh báo: Cơ sở có địa điểm là đi thuê/mượn (C1.2 = 1) mà có tài sản cố định là nhà xưởng, cửa hàng C3.1.1 > 0)?';
      }
    }
    if (question.maCauHoi == 'A7_4' &&
        question.maPhieu == AppDefine.maPhieuTB) {
      //C7.4_3=1. Có và C7.1=2;
      var a7_4_3_1Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_4_3_1);
      var a7_1Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_1);
      if (a7_4_3_1Value != null &&
          a7_4_3_1Value == 1 &&
          a7_1Value != null &&
          a7_1Value == 2) {
        return 'Cảnh báo: Cơ sở có phát sinh chi phí về thuê đường truyền internet, cước điện thoại (C7.4_3 = 1) mà Không sử dụng internet cho mục đích SXKD (C7.1=2)';
      }
      //(C7.4_1 >0 hoặc C7.4_2>0) và C3.4.1_ TSCĐ về Thiết bị dụng cụ quản lý=0
      var a7_4_1_2Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_4_1_2);
      var a7_4_2_2Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA7_4_2_2);

      var a3_1_4_1Value = controller.getValueByFieldName(
          question.bangDuLieu!, colPhieuMauTBA3_1_4_1);
      if (((a7_4_1_2Value != null && a7_4_1_2Value > 0) ||
              (a7_4_2_2Value != null && a7_4_2_2Value > 0)) &&
          (a3_1_4_1Value != null && a3_1_4_1Value == 0)) {
        return 'Cảnh báo: Cơ sở có phát sinh chi phí về mua, thuê phần cứng hoặc thuê mua phần mềm (C7.4_1 ($a7_4_1_2Value) > 0  hoặc C7.4_2 ($a7_4_2_2Value) >  0) mà C3.4.1_TSCĐ về Thiết bị dụng cụ quản lý=0';
      }
    } else if (question.maCauHoi == "A1" &&
        question.maPhieu == AppDefine.maPhieuVT) {
      var fieldNameMaCauHoiMaSo =
          '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_2';
      var fieldCoKhong = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_1';
      var a1_1Val =
          controller.getValueByFieldName(tablePhieuNganhVT, fieldCoKhong);
      if (fieldName == fieldNameMaCauHoiMaSo) {
        if (a1_1Val != null && a1_1Val == 1) {
          if (value != null && value != '') {
            if (value > 0) {
              //C2_ Số lượng xe>0 và C6.1_ 1. điện và 3. xăng và 5. dầu Diezel =0;
              var a6_1Dien = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
              var a6_1Xang = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_3_1);
              var a6_1Diezel = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_5_1);
              if (a6_1Dien != null &&
                  a6_1Dien == 2 &&
                  a6_1Diezel != null &&
                  a6_1Diezel == 2 &&
                  a6_1Dien != null &&
                  a6_1Dien == 2) {
                return 'Cảnh báo: Cơ sở vận tải có các loại xe mà không sử dụng năng lượng Xăng, điện, Dầu diezel (C6.1_1=2, C6.1_3=2, C6.1_5=2)';
              }
            }
            //- Tổng số lượng xe>0 và C3..1.2_TSCĐ là phương tiện vận tải cột a. Tổng giá trị TSCD=0?;
            //TSCD
            var a3_1_2_1TB = controller.getValueByFieldName(
                tablePhieuMauTB, colPhieuMauTBA3_1_2_1);
            if (a3_1_2_1TB != null &&
                controller.validateEqual0InputValue(a3_1_2_1TB)) {
              return 'Cảnh báo: Cơ sở có phương tiện vận tải nhưng Tài sản cố định là phương tiện vận tải tại C3.1.2_giá trị=0 có đúng không?';
            }
            //- Tổng số lượng xe tại C2 >0 và C3..1.2_TSCĐ là phương tiện vận tải cột a. Tổng giá trị TSCD>0 và <100 ?
            if (a3_1_2_1TB != null && a3_1_2_1TB > 0 && a3_1_2_1TB < 100) {
              return 'Cảnh báo: Cơ sở có phương tiện vận tải nhưng Giá trị Tài sản cố định (xe/tàu) thấp < 100 triệu đồng có đúng không?';
            }
          }
        }
      }
    } else if (question.maCauHoi == "A7" &&
        question.maPhieu == AppDefine.maPhieuVT) {
      var fieldNameMaCauHoiMaSo =
          '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_2';
      var fieldCoKhong = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_1';
      var a1_1Val =
          controller.getValueByFieldName(tablePhieuNganhVT, fieldCoKhong);
      if (fieldName == fieldNameMaCauHoiMaSo) {
        if (a1_1Val != null && a1_1Val == 1) {
          if (value != null && value != '') {
            if (value > 0) {
              //C2_ Số lượng xe>0 và C6.1_ 1. điện và 3. xăng và 5. dầu Diezel =0;
              var a6_1Dien = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
              var a6_1Xang = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_3_1);
              var a6_1Diezel = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_5_1);
              if (a6_1Dien != null &&
                  a6_1Dien == 2 &&
                  a6_1Diezel != null &&
                  a6_1Diezel == 2 &&
                  a6_1Dien != null &&
                  a6_1Dien == 2) {
                return 'Cảnh báo: Cơ sở vận tải có loại xe/tàu (C8>0) mà không sử dụng năng lượng Xăng, điện, Dầu diezel (C6.1_1=2, C6.1_3=2, C6.1_5=2)';
              }
            }
            //- Tổng số lượng xe>0 và C3..1.2_TSCĐ là phương tiện vận tải cột a. Tổng giá trị TSCD=0?;
            //TSCD
            var a3_1_2_1TB = controller.getValueByFieldName(
                tablePhieuMauTB, colPhieuMauTBA3_1_2_1);
            if (a3_1_2_1TB != null &&
                controller.validateEqual0InputValue(a3_1_2_1TB)) {
              return 'Cảnh báo: Cơ sở có phương tiện vận tải nhưng Tài sản cố định là phương tiện vận tải tại C3.1.2_giá trị=0 có đúng không?';
            }
            //- Tổng số lượng xe tại C2 >0 và C3..1.2_TSCĐ là phương tiện vận tải cột a. Tổng giá trị TSCD>0 và <100 ?
            if (a3_1_2_1TB != null && a3_1_2_1TB > 0 && a3_1_2_1TB < 100) {
              return 'Cảnh báo: Cơ sở có phương tiện vận tải nhưng Giá trị Tài sản cố định tại C3.1.2 thấp < 100 triệu đồng có đúng không?';
            }
          }
        }
      }
    } else if (question.maCauHoi == "A1" &&
        question.maPhieu == AppDefine.maPhieuLT) {
      var c3Field = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_3'; //C3
      var c3_1Field = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_4'; //3.1
      var aC4Field = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_5'; //C4
      var a4_1Field = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_6'; //C4.1

      var fieldCoKhong = '${chiTieuDong!.maCauHoi}_${chiTieuDong!.maSo}_1';

      var a1_1Val =
          controller.getValueByFieldName(tablePhieuNganhVT, fieldCoKhong);

      var c3Value = controller.getValueByFieldName(tablePhieuNganhVT, c3Field);
      var c3_1Value =
          controller.getValueByFieldName(tablePhieuNganhVT, c3_1Field);
      var c4Value = controller.getValueByFieldName(tablePhieuNganhVT, aC4Field);
      var c4_1Value =
          controller.getValueByFieldName(tablePhieuNganhVT, a4_1Field);

      int c3Val = c3Value != null ? AppUtils.convertStringToInt(c3Value) : 0;
      int c3_1Val =
          c3_1Value != null ? AppUtils.convertStringToInt(c3_1Value) : 0;
      int c4Val = c4Value != null ? AppUtils.convertStringToInt(c4Value) : 0;
      int c4_1Val =
          c4_1Value != null ? AppUtils.convertStringToInt(c4_1Value) : 0;

      if (fieldName == c3Field) {
        //Tích chọn Có mà số phòng C3=0;
        if (a1_1Val != null && a1_1Val == 1) {
          if (value != null && value != '') {
            if (controller.validateEqual0InputValue(value)) {
              return 'Cảnh báo: Có cơ sở lưu trú mà Số phòng C3=0';
            }
            //C3<C3.1;
            if (c3Val < c3_1Val) {
              return 'Cảnh báo: Số phòng tăng mới trong năm 2025> Số phòng tại thời điểm 31/12/2025';
            }
            //C3>0 và C6.1_Điện=2;
            if (c3Val > 0) {
              var a6_1_1_1Dien = controller.getValueByFieldName(
                  tablePhieuMauTB, colPhieuMauTBA6_1_1_1);
              if (a6_1_1_1Dien != null && a6_1_1_1Dien == 2) {
                return 'Cảnh báo: Cơ sở kinh doanh dịch vụ lưu trú có số phòng>0 mà không sử dụng năng lượng là điện?';
              }
            }
          }
        }
      }
      if (fieldName == aC4Field) {
        if (a1_1Val != null && a1_1Val == 1) {
          if (value != null && value != '') {
            //C4<C4.1;
            if (c4Val < c4_1Val) {
              return 'Cảnh báo: Số giường tăng mới trong năm 2025> số giường tại thời điểm 31/12/2025';
            }
            //Số giường tại C4 gấp >4 lần số phòng tại C3
            var gap4C3 = c3Val * 4;
            if (c4Val > gap4C3) {
              return 'Cảnh báo: Số giường tại 31/12/2025 gấp [$c4Val] mà số phòng của cơ sở là [$c3Val] có đúng không?';
            }
          }
        }
      }
    } else if (question.maCauHoi == "A6_1_M" &&
        question.maPhieu == AppDefine.maPhieuMau) {
      if (chiTieuCot.maChiTieu == "2") {
        //C2> C5.2_Tổng doanh thu bình quân tháng tất cả các sản phẩm;
        if (value != null && value != '') {
          double aVal = AppUtils.convertStringToDouble(
              value.toString().replaceAll(' ', ''));

          if (aVal > controller.tongDoanhThuTatCaSanPham.value) {
            var aValText = toCurrencyString(aVal.toString(),
                thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
                mantissaLength: 2);
            var tongDTText = toCurrencyString(
                controller.tongDoanhThuTatCaSanPham.value.toString(),
                thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
                mantissaLength: 2);
            return 'Giá trị tiêu thụ bình quân tại C2 là $aValText > Doanh thu bình quân của cơ sở tại C5.2 là $tongDTText?';
          }
        }
      }

      if (chiTieuDong.maSo == "1" || chiTieuDong.maSo == "2") {
        if (value != null && value != '') {
          double aVal = AppUtils.convertStringToDouble(
              value.toString().replaceAll(' ', ''));
          //Mã ngành cấp 2 là ngành công nghiệp (mã ngành >=10 và <=39) và C1_Điện hoặc Gas hoặc Than=0;
          if (controller.validateEqual0InputValue(0) &&
              controller.hasMaNganhCN10T039.isNotEmpty) {
            return 'Cơ sở kinh doanh trong ngành Công nghiệp (mã ngành >=10 và <=39) mà khối lượng tiêu dùng Điện hoặc Than hoặc Gas=0?';
          }

          //Mã ngành Vận tải hành khách (49210-49220-49290-49312-49313-49319-49321-49329-50111-50112-50211-50212) và C1_ ĐIện hoặc Xăng hoặc Dầu diezel=0;
          if (controller.validateEqual0InputValue(0) &&
              controller.hasMaNganhVTHK.isNotEmpty) {
            return 'Mã ngành của cơ sở là Vận tải hành khách mà Khối lượng tiêu dùng bình quân tháng của  ĐIện hoặc Xăng hoặc Dầu diezel=0?';
          }
          //Mã ngành vận tải hàng hóa thuộc mã 49331-49332-49333-49334-49339-50121-50122-50221-50222 và C1_ ĐIện hoặc Xăng hoặc Dầu diezel=0;
          if (controller.validateEqual0InputValue(0) &&
              controller.hasMaNganhVTHH.isNotEmpty) {
            return 'Mã ngành của cơ sở là Vận tải hàng hóa mà  Khối lượng tiêu dùng bình quân tháng của  ĐIện hoặc Xăng hoặc Dầu diezel=0?';
          }
        }
      }
      if (chiTieuCot.maChiTieu == "1" || chiTieuCot.maChiTieu == "2") {
        if (value != null && value != '') {
          double aVal = AppUtils.convertStringToDouble(
              value.toString().replaceAll(' ', ''));
          var aValText = toCurrencyString(aVal.toString(),
              thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
              mantissaLength: 2);
          //- C1>50 000 ;
          if (chiTieuCot.maChiTieu == "1") {
            if (aVal > 50000) {
              return 'Khối lượng tiêu thụ $aValText > 50 000 ${chiTieuDong.dVT}';
            }
          }

          ///C2> 100
          if (chiTieuCot.maChiTieu == "2") {
            if (aVal > 100) {
              return 'Giá trị tiêu thụ bình quân 1 tháng ($aValText) > 100 triệu?';
            }
          }
        }
      }
    }
    return '';
  }

  ///
  Widget wText(String message) {
    return Text(
      'Cảnh báo: $message',
      style: const TextStyle(color: Colors.orange),
    );
  }
}
