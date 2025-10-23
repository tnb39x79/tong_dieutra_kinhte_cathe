import 'dart:developer';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/button/i_button.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/searchable/dropdown_category.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_controller.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/animated_toggle_switch.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_linhvuc.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/model/linh_vuc/linh_vuc_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/constants.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/models/predict_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/services/industry_code_evaluator.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart';

class VcpaSearchService extends StatefulWidget {
  const VcpaSearchService(
      {super.key,
      this.keywordText,
      this.linhVuc,
      this.initialValue,
      this.capSo,
      this.onChangeListViewItem,
      this.productItem,
      this.searchType,
      this.maNganhCap5,
      this.moTaMaNganhCap5,
      this.isInitSearch});

  final String? keywordText;
  final String? linhVuc;
  final String? initialValue;
  final Function(TableDmMotaSanpham, dynamic, int)? onChangeListViewItem;
  final dynamic productItem;
  final String? maNganhCap5;
  final String? moTaMaNganhCap5;
  final bool? isInitSearch;

  ///0: AI; 1: Danh muc
  final int? searchType;

  ///capSo: là cấp của mã sản phẩm bao nhiêu? 1 hoặc 2, hoặc 3,...
  final int? capSo;

  @override
  State<VcpaSearchService> createState() => _VcpaSearchServiceState();
}

class _VcpaSearchServiceState extends State<VcpaSearchService> {
  final phieuTBController = Get.find<QuestionPhieuTBController>();

  /// Sử dụng IndustryCodeEvaluator để lấy mã ngành từ model AI
//  final industryEvaluator = IndustryCodeEvaluator(isDebug: kDebugMode);

  final vcpaAIRepository = Get.find<VcpaVsicAIRepository>();
  final TextEditingController searchController = TextEditingController();

  bool canClear = false;
  bool isLoading = false;

  List<TableDmMotaSanpham> dataResult = [];
  TableDmLinhvuc? linhVucItem;
  List<TableDmLinhvuc> linhVucs = [];
  // LinhVuc? _linhVuc;
  // List<LinhVuc> _linhVucItems = [];
  //bool industryInitialed = false;
  String? errorMessage;
  String? responseMessage;
  bool hasLocalAI = false;

  bool hasShowDialogSearchMode = false;

  ///Defaut: 100
  int topK = 100;
  int? selectedIndex;
  //bool isOnline = true;

  /// Get the current Documents directory path (iOS-safe)
  Future<String> _getDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Convert relative path to absolute path using current Documents directory
  Future<String> _getAbsolutePath(String relativePath) async {
    // If already absolute, return as-is
    if (relativePath.startsWith('/')) {
      return relativePath;
    }

    final documentsPath = await _getDocumentsDirectoryPath();
    return '$documentsPath/$relativePath';
  }

  /// Get absolute path from stored relative path (iOS-safe)
  Future<String?> _getStoredAbsolutePath(String prefKey) async {
    String? relativePath;

    switch (prefKey) {
      case 'dataModelSuggestionsPath':
        relativePath = AppPref.dataModelSuggestionsPath;
        break;
    }

    if (relativePath == null || relativePath.isEmpty) {
      return null;
    }

    return await _getAbsolutePath(relativePath);
  }

  @override
  void initState() {
    super.initState();
    searchController.text = widget.keywordText ?? "";
    // log('Search api: ${widget.search}');
    canClear = searchController.text.isNotEmpty;
    linhVucItem = null;
    // loadSavedPreference();
    initData();
    // Handle initial fetch if there's search text
    if (searchController.text.isNotEmpty) {
      handleInitialFetch();
    }
  }

  /// Load saved preference for search mode
  Future<void> loadSavedPreference() async {
    await checkLocalAI();

    // Always show choice dialog when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSearchChoiceDialog();
    });
  }

  /// Check if local AI data is available
  Future<void> checkLocalAI() async {
    try {
      final currentFilePath =
          await _getStoredAbsolutePath('dataModelSuggestionsPath');

      if (currentFilePath != null && currentFilePath.isNotEmpty) {
        final fileExists = await File(currentFilePath).exists();
        hasLocalAI = fileExists;
        setState(() {});
      }

      debugPrint('Local AI available: $hasLocalAI');
    } catch (e) {
      debugPrint('Error checking local AI: $e');
      hasLocalAI = false;
    }
  }

  initData() async {
    /// lấy toàn bộ lĩnh vực
    final lvs = phieuTBController.tblLinhVucSp.value;
    // linhVuc.sort((a, b) => a.maLV!.compareTo(b.maLV!));
    linhVucs = lvs;

    final itemSps = await phieuTBController.dmMotaSanphamProvider
        .getByVcpaCap5(widget.initialValue ?? '');
    // if (itemSps.isNotEmpty) {
    //   var itemSp = TableDmMotaSanpham.fromJson(itemSps);

    //   final initLinhVuc =
    //       linhVucs.firstWhereOrNull((l) => l.maLV == itemSp?.maLV);
    //   linhVucItem = initLinhVuc;
    // }
    setState(() {});
  }

  /// Handle initial fetch during initialization
  Future<void> handleInitialFetch() async {
    if (widget.searchType == 0) {
      if (hasShowDialogSearchMode) return;
      await checkLocalAI();

      // If local AI is available, use it directly
      if (hasLocalAI) {
        await searchOffline();
        return;
      }

      // If no local AI, show choice dialog
      //   showInitialChoiceDialog();
    } else if (widget.searchType == 1) {
      hasShowDialogSearchMode = true;
      await searchFromDanhMuc();
    } else {
      return;
    }
  }

  /// Show choice dialog during initialization when local AI is not available
  void showInitialChoiceDialog() {
    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Chưa có dữ liệu AI'),
        content: const Text(
            'Chưa có dữ liệu AI. Bạn muốn tải xuống AI hay sử dụng online?'),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back(); // Close dialog
              handleOnlineAPICall();
            },
            child: const Text('Dùng Online'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back(); // Close dialog
              Get.toNamed(AppRoutes.downloadModelAI_V2)?.then((value) async {
                debugPrint('Downloaded AI: $value');
                setState(() {
                  isLoading = true;
                });
                await checkLocalAI();
                setState(() {
                  isLoading = false;
                });
              }); // Navigate to AI download screen
            },
            child: const Text('Tải xuống'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show choice dialog when search button is clicked
  // void showSearchChoiceDialog() {
  //   if (hasShowDialogSearchMode) return;
  //   hasShowDialogSearchMode = true;
  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text('Chọn phương thức tìm kiếm'),
  //       content: const Text('Bạn muốn sử dụng online hay tải xuống AI?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Get.back(); // Close dialog
  //             setState(() {
  //               isOnline = true;
  //             });
  //             handleOnlineAPICall();
  //           },
  //           child: const Text('Dùng Online'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Get.back(); // Close dialog
  //             Get.toNamed(AppRoutes.downloadModelAI_V2)?.then((value) async {
  //               debugPrint('Downloaded AI: $value');
  //               setState(() {
  //                 isLoading = true;
  //               });
  //               await checkLocalAI();
  //               setState(() {
  //                 isLoading = false;
  //               });
  //             }); // Navigate to AI download screen
  //           },
  //           child: const Text('Tải xuống'),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }
  void showSearchChoiceDialog() {
    // Prevent showing the dialog multiple times in the same session
    if (hasShowDialogSearchMode) return;

    hasShowDialogSearchMode = true;

    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Chọn phương thức tìm kiếm'),
        content: const Text(
            'Bạn muốn sử dụng tìm kiếm Online hay Offline?\n\nOnline: Sử dụng API trực tuyến\nOffline: Sử dụng AI đã tải xuống'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back();
              setState(() {
                //  isOnline = true;
                phieuTBController.isSearchOnline.value = true;
              });
              // Call API when user chooses Online
              if (searchController.text.trim().isNotEmpty) {
                handleOnlineAPICall();
              }
            },
            child: const Text('Dùng Online'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () async {
              Get.back();
              // Check if AI is downloaded
              if (hasLocalAI) {
                setState(() {
                  //isOnline = false;
                  phieuTBController.isSearchOnline.value = false;
                });
                // Call local AI if search text exists
                if (searchController.text.trim().isNotEmpty) {
                  await searchOffline();
                }
              } else {
                // Show download dialog
                showDownloadDialog();
              }
            },
            child: const Text('Dùng Offline'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show download dialog when AI is not available
  void showDownloadDialog() {
    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Chưa có dữ liệu AI'),
        content:
            const Text('Chưa có dữ liệu AI Offline. Bạn muốn tải xuống ngay?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back();
              // Default to online mode
              setState(() {
                //  isOnline = true;
                phieuTBController.isSearchOnline.value = true;
                phieuTBController.isSearchOnlineSwitch.value = true;
              });
              if (searchController.text.trim().isNotEmpty) {
                handleOnlineAPICall();
              }
            },
            child: const Text('Dùng Online'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.downloadModelAI_V2)?.then((value) async {
                debugPrint('Downloaded AI: $value');
                setState(() {
                  isLoading = true;
                });
                await checkLocalAI();
                if (hasLocalAI) {
                  setState(() {
                    //  isOnline = false;
                    phieuTBController.isSearchOnline.value = false;
                    phieuTBController.isSearchOnlineSwitch.value = false;
                  });
                }
                setState(() {
                  isLoading = false;
                });
              });
            },
            child: const Text('Tải xuống'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showOfflineNotAvailableDialog() {
    Get.dialog(
      AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Chưa có dữ liệu AI'),
        content: const Text(
            'Chưa có dữ liệu AI Offline. Bạn muốn tải xuống ngay hay chuyển sang Online?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back();
              // Switch to online mode
              // setState(() {
              //   isOnline = true;
              // });
              phieuTBController.isSearchOnline.value = true;
              handleOnlineAPICall();
            },
            child: const Text('Dùng Online'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                side: BorderSide(width: 1, color: primaryColor),
                splashFactory: InkRipple.splashFactory,
                overlayColor: primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor),
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.downloadModelAI_V2)?.then((value) async {
                debugPrint('Downloaded AI: $value');
                setState(() {
                  isLoading = true;
                });
                await checkLocalAI();
                setState(() {
                  isLoading = false;
                });
                // If AI is now available, perform the search
                if (hasLocalAI && searchController.text.trim().isNotEmpty) {
                  // setState(() {
                  //   isOnline = false;
                  // });
                  phieuTBController.isSearchOnline.value = false;
                  await searchOffline();
                }
              });
            },
            child: const Text('Tải xuống'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Handle online API call with proper error handling
  Future<void> handleOnlineAPICall() async {
    // Check network connectivity first
    if (NetworkService.connectionType == Network.none) {
      setState(() {
        errorMessage =
            'Không có kết nối internet. Vui lòng kiểm tra và thử lại.';
      });
      return;
    }

    // Proceed with online API call
    await searchOnline();
  }

  /// Fetch data from local AI
  Future<void> searchOffline() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      dataResult = await searchVcpa(isOnline: false);
    } catch (e) {
      //logError("Error loading data from local AI: $e");
      setState(() {
        errorMessage =
            'Có lỗi xảy ra khi sử dụng AI offline. Vui lòng kiểm tra dữ liệu AI hoặc kết nối mạng.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Fetch data from online API
  Future<void> searchOnline() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      // Double-check network connection
      if (NetworkService.connectionType == Network.none) {
        setState(() {
          errorMessage =
              'Không có kết nối internet. Vui lòng kiểm tra và thử lại.';
        });
        return;
      }

      dataResult = await searchVcpa(isOnline: true);
      debugPrint('Final data: ${dataResult.length}');
    } catch (e) {
      debugPrint("Error loading data from online API: $e");
      setState(() {
        errorMessage =
            'Đã có lỗi xảy ra. Vui lòng kiểm tra kết nối mạng hoặc tải xuống AI.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> searchFromDanhMuc() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      dataResult = await getVcpaDanhMuc();
      debugPrint('Final data from danh muc: ${dataResult.length}');
    } catch (e) {
      debugPrint("Error loading data from danh muc: $e");
      setState(() {
        errorMessage = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<TableDmMotaSanpham>> searchVcpa({bool isOnline = false}) async {
    final sanPhams = isOnline ? await getVcpaOnline() : await getVcpaOffline();
    final searchText = searchController.text.trim().toLowerCase();

    final filteredData = sanPhams.where((e) {
      final linhvuc = linhVucs.firstWhereOrNull((l) => l.maLV == e.maLV);
      final tuKhoa = ''; //linhvuc?.tuKhoa ?? '';

      // Split search text into words for word boundary matching
      final searchWords = searchText.split(RegExp(r'\s+'));

      final isMatching = tuKhoa.split(';').any((keyword) {
        if (keyword.trim().isEmpty) return false;

        final cleanKeyword = keyword.trim().toLowerCase();

        // For multi-word keywords, check if the entire phrase exists in search text
        if (cleanKeyword.contains(' ')) {
          return searchText.contains(cleanKeyword);
        }

        // For single-word keywords, check exact word boundary match
        return searchWords.any((searchWord) => searchWord == cleanKeyword);
      });

      debugPrint(
          'Product ${e.maSanPham} - ${e.maVSIC} - ${e.tenVSIC} with keywords "${linhvuc?.tuKhoa}" isMatching: $isMatching (searchText: "$searchText")');
      return isMatching;
    }).toList();

    debugPrint('Filtered data: ${filteredData.length}');
    return filteredData.isEmpty ? sanPhams : filteredData;
  }

  /// Get suggestions from local AI
  Future<List<TableDmMotaSanpham>> getVcpaOffline() async {
    final keyword = searchController.text.trim();
    try {
      if (!phieuTBController.isInitializedEvaluator.value) {
        responseMessage = 'Đang khởi tạo AI Model';
        // ngăn chặn block ui với dialog
        await Future.delayed(const Duration(milliseconds: 300));
        await phieuTBController.initializeEvaluator();
        if (phieuTBController.isInitializedEvaluator.value) {
          responseMessage = 'Đã khởi tạo AI Model thành công.';
        }
        //
      }
      await Future.delayed(const Duration(milliseconds: 300));
      responseMessage = null;
      final predictions =
          await phieuTBController.evaluator.predict([keyword], topK: topK);
      List<PredictionResult> _results =
          predictions.isNotEmpty ? predictions.first : [];

      List<Map> vcpaCap5s = await phieuTBController.dmMotaSanphamProvider
          .mapResultAIToDmSanPhamOffline(
              _results, linhVucItem != null ? linhVucItem!.maLV ?? '' : '',
              capSo: widget.capSo, maNganhCap5: widget.maNganhCap5 ?? '');
      var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));
      debugPrint('OFFLINE SEARCH RESULT ${result.length}');

      return result.toList();
    } catch (e) {
      errorMessage = 'Có lỗi: $e';
      return [];
    }
  }

  /// Get suggestions from online API
  Future<List<TableDmMotaSanpham>> getVcpaOnline() async {
    final response = await vcpaAIRepository
        .searchVcpaVsicByAI('vcpa', searchController.text, limitNum: topK);

    if (response.statusCode == 200) {
      if (response.body != null) {
        if (response.body!.isNotEmpty) {
          var res = response.body!;

          List<Map> vcpaCap5s = await phieuTBController.dmMotaSanphamProvider
              .mapResultAIToDmSanPham(
                  res, linhVucItem != null ? linhVucItem!.maLV ?? '' : '',
                  capSo: widget.capSo, maNganhCap5: widget.maNganhCap5 ?? '');
          var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));

          log('SEARCH RESULT: ${result.length}');
          return result.toList();
        }
      }
    } else if (response.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'no_connect_internet'.tr;
    } else if (response.statusCode.toString() == ApiConstants.requestTimeOut) {
      errorMessage = 'Request timeout.';
    } else {
      errorMessage = (response.message != null || response.message != "")
          ? 'Có lỗi: ${response.message} '
          : 'Có lỗi: ${response.statusCode} ';
    }
    return [];
  }

  Future<List<TableDmMotaSanpham>> getVcpaDanhMuc() async {
    List<Map> vcpaCap5s = await phieuTBController.dmMotaSanphamProvider
        .searchVcpaCap5ByLinhVuc(
            searchController.text,
            linhVucItem != null ? linhVucItem!.maLV ?? '' : '',
            widget.capSo ?? 5,
            maNganhCap5: widget.maNganhCap5 ?? '');
    var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));
    return result.toList();
  }

  List<TableDmMotaSanpham> getLinhVuc(List<TableDmMotaSanpham> products) {
    final uniqueIndustries = <String>{};
    return products
        .where((item) => item.maLV != null && uniqueIndustries.add(item.maLV!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          child: InputDecorator(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryLightColor, width: 2.0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownCategory(
                onLinhVucSelected: (item) {
                  setState(() {
                    linhVucItem = item;
                  });
                },
                danhSachLinhVuc: linhVucs,
                linhVucItemSelected: linhVucItem,
              ))),
        ),
        // if (widget.searchType == 0)
        // IntrinsicWidth(
        //   child: Padding(
        //     padding: const EdgeInsets.only(
        //       left: 10,
        //       top: 0,
        //     ),
        //     child: Center(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           splashFactory: InkRipple.splashFactory,
        //           overlayColor: phieuTBController.isSearchOnline.value ?successColor.withValues(alpha: 0.2): Colors.grey.shade100,
        //           fixedSize: const Size(200, 48),
        //           padding: const EdgeInsets.symmetric(
        //               horizontal: 12, vertical: 14),
        //           backgroundColor:phieuTBController.isSearchOnline.value ?successColor.withValues(alpha: 0.1): Colors.grey.shade200,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(AppValues.borderLv1),
        //           ),
        //           elevation: 0,
        //           minimumSize: Size.fromHeight(40),
        //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //           side: BorderSide(
        //             color: Colors.grey.shade200, // Your desired border color
        //             width: 1, // Optional: border width
        //           ),
        //         ),
        //         onPressed: () {
        //           setState(() {
        //            // isOnline = !isOnline; // Toggle the state
        //             phieuTBController.isSearchOnline.value=!phieuTBController.isSearchOnline.value;
        //           });
        //           if (phieuTBController.isSearchOnline.value == false) {
        //             if (!hasLocalAI) {
        //               showDownloadDialog();
        //             }
        //           }
        //         },
        //         child: Text(
        //           phieuTBController.isSearchOnline.value ? 'Online' : 'Offline',
        //           style: TextStyle(
        //               color: phieuTBController.isSearchOnline.value ?successColor : Colors.black),
        //         ), // Change label based on state
        //       ),
        //     ),
        //   ),
        // ),
        if (widget.searchType == 0)
          IntrinsicWidth(
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 0,
                  ),
                  child: Center(
                      child: AdvancedSwitch(
                    controller: phieuTBController.isSearchOnlineSwitch,
                    initialValue: phieuTBController.isSearchOnline.value,
                    activeColor: Colors.green,
                    inactiveColor: Color.fromARGB(255, 242, 196, 105),
                    activeChild: Text('Online'),
                    inactiveChild: Text('Offline'),
                    borderRadius: BorderRadius.all(
                        const Radius.circular(AppValues.borderLv1)),
                    width: 70.0,
                    height: 30.0,
                    enabled: true,
                    disabledOpacity: 0.5,
                    onChanged: (value) => onSearchModeChange(value),
                  )))),
      ]),

      // Divider(),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: WidgetFieldInput(
              controller: searchController,
              hint: "Mã/tên sản phẩm/mô tả sản phẩm",
              suffix: buildClear(),
              onChanged: (p0) => _onTextChanged(),
              enable: !isLoading,
            ),
          ),
          IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                top: 4,
              ),
              child: IButton(
                label: "Tìm kiếm",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                onPressed: isLoading ? null : () => onSearchButtonPressed(),
              ),
            ),
          )
        ],
      ),
      buildMoTaCap5(),
      Expanded(child: buildListItem())
    ]);
  }

  Widget buildClear() {
    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  ),
                )
              : canClear
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      highlightColor: primaryLightColor,
                      onPressed: () {
                        searchController.clear();
                        _onTextChanged();
                        // Clear data when text is cleared
                        setState(() {
                          dataResult = [];
                          errorMessage = null;
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      highlightColor: primaryLightColor,
                      onPressed: onSearchButtonPressed,
                    )),
    );
  }

  /// Handle text changes (only update UI state, don't trigger search)
  void _onTextChanged() {
    setState(() {
      canClear = searchController.text.isNotEmpty;
    });
  }

  void onSearchModeChange(value) {
    phieuTBController.isSearchOnline.value = value;
    phieuTBController.isSearchOnlineSwitch.value = value;
    if (phieuTBController.isSearchOnline.value == false) {
      if (!hasLocalAI) {
        showDownloadDialog();
      }
    }
  }

  /// Handle search button press (always show choice dialog)
  void onSearchButtonPressed() async {
    FocusScope.of(context).unfocus();
    if (searchController.text.trim().isEmpty) {
      setState(() {
        dataResult = [];
        errorMessage = null;
        responseMessage = null;
      });
      return;
    }
    if (widget.searchType == 0) {
      // await checkLocalAI();
      // Always show choice dialog when search button is clicked
      if (phieuTBController.isSearchOnline.value) {
        await handleOnlineAPICall();
      } else {
        if (hasLocalAI) {
          await searchOffline();
          return;
        } else {
          _showOfflineNotAvailableDialog();
        }
      }
      // showSearchChoiceDialog();
    } else if (widget.searchType == 1) {
      await searchFromDanhMuc();
    } else {
      return;
    }
  }

  Widget buildMoTaCap5() {
    if (widget.maNganhCap5 != null && widget.maNganhCap5 != '') {
      return Column(children: [
        const SizedBox(
          height: 8,
        ),
        Row(children: [
          Expanded(
              child: RichText(
                  text: TextSpan(
                      text: 'Mã cấp 5: ',
                      style: TextStyle(color: blackText),
                      children: [
                TextSpan(
                    text: '${widget.maNganhCap5} - ${widget.moTaMaNganhCap5}',
                    style: styleSmallBold),
              ])))
        ])
      ]);
    }
    return const SizedBox();
  }

  TextStyle styleTable = styleMedium;

  Widget buildListItem() {
    return Column(
      children: [
        responseMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    responseMessage!,
                    style: TextStyle(color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  "Mã VCPA",
                  style: styleTable.copyWith(fontWeight: FontWeight.bold),
                )),
            Expanded(
              flex: 7,
              child: Text(
                "Tên ngành VCPA",
                style: styleTable.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: isLoading
              ? IndicatorView()
              : (dataResult.isEmpty ? notFoundView() : buildListView()),
        ),
      ],
    );
  }

  // ListView _buildItems() {
  //   return ListView.builder(
  //     itemCount: dataResult.length,
  //     itemBuilder: (context, index) {
  //       final item = dataResult[index];
  //       return InkWell(
  //         onTap: () {
  //           setState(() {
  //             if (selectedIndex == index) {
  //               selectedIndex = null;
  //             } else {
  //               selectedIndex = index;
  //             }
  //           });
  //           widget.onChangeListViewItem!(item, widget.productItem);
  //         },
  //         key: ValueKey(item.maSanPham),
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 8),
  //           decoration: BoxDecoration(
  //             border: Border(
  //               bottom: BorderSide(color: Colors.grey.shade300),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                   flex: 3,
  //                   child: Text(
  //                     "${item.maSanPham}",
  //                     style: styleTable,
  //                   )),
  //               Expanded(
  //                 flex: 7,
  //                 child: Text(
  //                   "${item.tenSanPham}",
  //                   style: styleTable,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  ListView buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: dataResult.length,
      itemBuilder: (BuildContext context, int index) {
        var item = dataResult.elementAt(index);
        String title = '${item.maSanPham!} - ${item.tenSanPham!}';
        String titleMaSp = '${item.maSanPham!} ';
        String titleTenSp = '${item.tenSanPham!}';
        String subTitle = 'Cấp 1: ${item.maLV}';
        int ind = index + 1;
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex == index) {
                    selectedIndex = null;
                  } else {
                    selectedIndex = index;
                  }
                });

                widget.onChangeListViewItem!(
                    item, widget.productItem, selectedIndex ?? -1);
              },
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                          titleMaSp,
                          style:
                              styleMedium.copyWith(fontWeight: FontWeight.w400),
                        )),
                    Expanded(
                      flex: 7,
                      child: Text(
                        titleTenSp,
                        style:
                            styleMedium.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black38),
                    ),
                    Text(
                      '$ind',
                      style: const TextStyle(
                          fontStyle: FontStyle.normal, color: Colors.black38),
                    )
                  ],
                ),
                selected: selectedIndex == index,
                selectedTileColor: primaryColor,
                selectedColor: Colors.white,
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget notFoundView() {
    Text msgText = const Text('Không tìm thấy sản phẩm.');
    Icon iconRes = const Icon(
      Icons.info,
      color: Colors.grey,
    );
    if (errorMessage != null && errorMessage != '') {
      msgText = Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red),
      );

      iconRes = const Icon(
        Icons.error,
        color: Colors.red,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        iconRes,
        msgText,
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    EasyDebounce.cancel('search_debounce');
    super.dispose();
  }
}

class IndicatorView extends StatelessWidget {
  const IndicatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        //  Divider(),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        )
      ],
    );
  }
}
