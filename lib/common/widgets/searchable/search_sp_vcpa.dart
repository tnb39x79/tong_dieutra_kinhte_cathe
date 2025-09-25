import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/button/i_button.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/categories/custom_slider.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/categories/custom_slider_thumb.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart'; 

class SearchSpVcpa extends StatefulWidget {
  const SearchSpVcpa(
      {super.key,
      // required this.onSearch,
      required this.onChangeListViewItem,
      this.onChangeText,
      required this.onPressSearch,
      //  this.validator,
      this.value,
      // this.dropDownValue
      required this.phieuMauSpItem,
      this.filteredList,
      this.searchType,
      this.startSearch,
      this.onChangeSlider,
      this.responseMessage});

  final Function(TableDmMotaSanpham, dynamic)? onChangeListViewItem;
  final Function(String?)? onChangeText;
  final VoidCallback onPressSearch;
  // final Function(String) onSearch;
  //final String? Function(String?)? validator;
  final String? value;
  // final String? dropDownValue;
  // final List<TableDmLinhvuc>? tblDmLinhVuc;
  final dynamic phieuMauSpItem;
  final Iterable<TableDmMotaSanpham?>? filteredList;
  final int? searchType;
  final bool? startSearch;
  final Function(int)? onChangeSlider;
  final String? responseMessage;

  @override
  SearchSpVcpaState createState() => SearchSpVcpaState();
}

class SearchSpVcpaState extends State<SearchSpVcpa> {
  StreamController<String> streamController = StreamController();
  TextEditingController searchInputController = TextEditingController();
  bool _showClearButton = false;
  String? dropDownValueLocal;
  bool doItJustOnce = false;

  bool canClear = false;
  bool isLoading = false;
  int? _selectedIndex;
  String? keyword;
  double _sliderDiscreteValue = 10;
  @override
  void initState() {
    super.initState();
    searchInputController.text = widget.value ?? '';
    canClear = searchInputController.text.isNotEmpty;

    streamController.stream.debounce(Duration(milliseconds: 400)).listen((s) {
      onBtnSearchPress();
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<DropdownMenuItem<String>> dropdownMenuItemsDefault =
    //     <DropdownMenuItem<String>>[];
    // dropdownMenuItemsDefault.add(const DropdownMenuItem(
    //   value: '',
    //   child: Text('Chọn lĩnh vực'),
    // ));
    //var mediaQuery = MediaQuery.of(context);
    // var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    // debugPrint('keyboardHeight $keyboardHeight');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Expanded(
            child: WidgetFieldInput(
              controller: searchInputController,
              hint: "Mã/tên sản phẩm/mô tả sản phẩm",
              suffix: buildClear(),
              onChanged: (v) {
                // setState(() {
                //   keyword = v;
                // });
                widget.onChangeText!(v);
                streamController.add(v);
              },
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
                onPressed: () => onBtnSearchPress(),
              ),
            ),
          )
        ],
      ),
      // Text('Mã hoặc tên sản phẩm hoặc mô tả sản phẩm',style: styleSmall.copyWith(color: greyColor)),
      //if (widget.searchType == 2)

      // SliderTheme(
      //   data: SliderThemeData(
      //     thumbColor: Colors.green,
      //     thumbShape: PolygonSliderThumb(
      //       thumbRadius: 12.0,
      //       sliderValue: _sliderDiscreteValue,
      //     ),
      //     showValueIndicator: ShowValueIndicator.never,
      //     valueIndicatorShape: SliderComponentShape.noOverlay,
      //   ),
      //   child: Slider(
      //     value: _sliderDiscreteValue,
      //     min: 0,
      //     max: 100,
      //     divisions: 10,
      //     label: _sliderDiscreteValue.round().toString(),
      //     activeColor: primaryColor,
      //     onChanged: (value) {
      //       setState(() {
      //         _sliderDiscreteValue = value;
      //       });

      //       widget.onChangeSlider!.call(value.toInt());
      //     },
      //   ),
      // ),
      // const SizedBox(
      //   height: 16,
      // ),
      buildResult(),
      const SizedBox(
        height: 16,
      ),
    ]);
  }

  Widget buildClear() {
    return SizedBox(
        width: 24,
        height: 24,
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: (widget.startSearch!)
                ? Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(color: primaryColor,
                        strokeWidth: 1,
                      ),
                    ),
                  )
                : canClear
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        highlightColor: primaryLightColor,
                        onPressed: () {
                          searchInputController.clear();
                          onTextChange();
                          onBtnSearchPress();
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        highlightColor: primaryLightColor,
                        onPressed: () {
                          searchInputController.clear();
                          onTextChange();
                          onBtnSearchPress();
                        },
                      )
            // IconButton(
            //   icon: const Icon(Icons.clear),
            //   highlightColor: primaryLightColor,
            //   onPressed: () {
            //     searchInputController.clear();
            //     onTextChange();
            //     onBtnSearchPress();
            //   },
            // )

            ));
  }

  buildResult() {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (widget.startSearch == true) {
      return const Center(child: IndicatorView());
    } else {
      if (widget.filteredList != null && widget.filteredList!.isNotEmpty) {
        return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height -
                (AppValues.padding * 1.5 + 270 + keyboardHeight),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                          "   Mã VCPA",
                          style:
                              styleMedium.copyWith(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 7,
                      child: Text(
                        "Tên ngành VCPA",
                        style:
                            styleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                    child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 0.0),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: widget.filteredList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String title =
                        '${widget.filteredList!.elementAt(index)?.maSanPham!} - ${widget.filteredList!.elementAt(index)?.tenSanPham!}';
                    String titleMaSp =
                        '${widget.filteredList!.elementAt(index)?.maSanPham!} ';
                    String titleTenSp =
                        '${widget.filteredList!.elementAt(index)?.tenSanPham!}';
                    String subTitle =
                        'Cấp 1: ${widget.filteredList!.elementAt(index)?.maLV}';
                    int ind = index + 1;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedIndex == index) {
                                _selectedIndex = null;
                              } else {
                                _selectedIndex = index;
                              }
                            });
                            widget.onChangeListViewItem!(
                                widget.filteredList!.elementAt(index)!,
                                widget.phieuMauSpItem);
                          },
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      titleMaSp,
                                      style: styleMedium.copyWith(
                                          fontWeight: FontWeight.w400),
                                    )),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    titleTenSp,
                                    style: styleMedium.copyWith(
                                        fontWeight: FontWeight.w400),
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
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black38),
                                ),
                                Text(
                                  '$ind',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black38),
                                )
                              ],
                            ),
                            selected: _selectedIndex == index,
                            selectedTileColor: primaryColor,
                            selectedColor: Colors.white,
                          ),

                          // ListTile(
                          //   title: Text(
                          //     title,
                          //     style: const TextStyle(
                          //         fontStyle: FontStyle.normal,
                          //         fontWeight: FontWeight.w500),
                          //   ),
                          //   subtitle: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         subTitle,
                          //         style: const TextStyle(
                          //             fontStyle: FontStyle.italic,
                          //             color: Colors.black38),
                          //       ),
                          //       Text(
                          //         '$ind',
                          //         style: const TextStyle(
                          //             fontStyle: FontStyle.normal,
                          //             color: Colors.black38),
                          //       )
                          //     ],
                          //   ),
                          //   selected: _selectedIndex == index,
                          //   selectedTileColor: primaryColor,
                          //   selectedColor: Colors.white,
                          // ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                )),
              ],
            ));
      } else {
        if (widget.startSearch == false) {
          return Center(child: notFoundView());
        }
      }
    }
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return const SizedBox();
    }

    return IconButton(
      onPressed: () => {searchInputController.text = ''},
      icon: Icon(Icons.clear),
    );
  }

  void onBtnSearchPress() {
    debugPrint('Press me');
    widget.onPressSearch();
  }

  void onTextChange() {
    debugPrint('Text change');
    widget.onChangeText!(searchInputController.text);
  }

  Widget notFoundView() {
    Text msgText = const Text('Không tìm thấy sản phẩm.');
    Icon iconRes = const Icon(
      Icons.info,
      color: Colors.grey,
    );
    if (widget.responseMessage != null && widget.responseMessage != '') {
      msgText = Text(
        widget.responseMessage!,
        style: const TextStyle(color: Colors.red),
      );

      iconRes = const Icon(
        Icons.error,
        color: Colors.red,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        iconRes,
        msgText,
      ],
    );
  }
}

// class NotFoundView extends StatelessWidget {
//   const NotFoundView({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.info,
//           color: Colors.grey,
//         ),
//         Text('Không tìm thấy sản phẩm.'),
//       ],
//     );
//   }
// }

class IndicatorView extends StatelessWidget {
  const IndicatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Divider(),
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

