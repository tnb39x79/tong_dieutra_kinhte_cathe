import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/categories/custom_slider.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/categories/custom_slider_thumb.dart';
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
  // late List<TableDmMotaSanpham> filteredList = <TableDmMotaSanpham>[];
  TextEditingController searchInputController = TextEditingController();
  bool _showClearButton = false;
  String? dropDownValueLocal;
  bool doItJustOnce = false;

  int? _selectedIndex;
  double _sliderDiscreteValue = 10;
  //late ScrollController _scrollController;
  @override
  void initState() {
    searchInputController.text = widget.value ?? '';

    super.initState();
    // _scrollController = ScrollController();
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              textAlign: TextAlign.start,
              maxLength: 255,
              controller: searchInputController,
              style: styleSmall,
              enabled: true,
              //  validator: widget.validator,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Mã/tên sản phẩm hoặc mô tả sản phẩm',
                errorMaxLines: 2,
                fillColor: backgroundWhiteColor,
                filled: true,
                contentPadding:
                    const EdgeInsets.only(top: 4, left: 16, right: 0),
                hintStyle: styleSmall.copyWith(color: greyColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: primaryLightColor,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: primaryColor,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: greyBorder,
                    width: 1.0,
                  ),
                ),
                //  prefixIcon: const Icon(Icons.search),
                suffixIcon: Container(
                  margin: const EdgeInsets.fromLTRB(2, 2, 0, 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 0,
                        iconColor: primaryColor),
                    onPressed: onBtnSearchPress,
                    child: const Icon(size:32.0,
                      Icons.search,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              onChanged: widget.onChangeText,
            ),
          ),
          if (widget.searchType == 2)
            // Slider(
            //   value: _sliderDiscreteValue,
            //   min: 0,
            //   max: 100,
            //   divisions: 5,
            //   label: _sliderDiscreteValue.round().toString(),
            //   activeColor: primaryColor,
            //   onChanged: (value) {
            //     setState(() {
            //       _sliderDiscreteValue = value;
            //     });
            //   },
            // ),
            SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.green,
                thumbShape: PolygonSliderThumb(
                  thumbRadius: 12.0,
                  sliderValue: _sliderDiscreteValue,
                ),
                showValueIndicator: ShowValueIndicator.never,
                valueIndicatorShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _sliderDiscreteValue,
                min: 0,
                max: 100,
                divisions: 10,
                label: _sliderDiscreteValue.round().toString(),
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    _sliderDiscreteValue = value;
                  });

                  widget.onChangeSlider!.call(value.toInt());
                },
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          buildResult(),
          const SizedBox(
            height: 16,
          ),
        ]);
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
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: widget.filteredList!.length,
              itemBuilder: (BuildContext context, int index) {
                String title =
                    '${widget.filteredList!.elementAt(index)?.maSanPham!} - ${widget.filteredList!.elementAt(index)?.tenSanPham!}';
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
                        title: Text(
                          title,
                          style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500),
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
                    ),
                    const Divider(),
                  ],
                );
              },
            ));
      } else {
        return Center(child: notFoundView());
      }
    }
  }
  // Widget _getClearButton() {
  //   if (!_showClearButton) {
  //     return const SizedBox();
  //   }

  //   return IconButton(
  //     onPressed: () => {searchInputController.text = ''},
  //     icon: Icon(Icons.clear),
  //   );
  // }

  void onBtnSearchPress() {
    debugPrint('Press me');
    widget.onPressSearch();
  }

  Widget notFoundView() {
    Text msgText = const Text( 'Không tìm thấy sản phẩm.');
    Icon iconRes = const Icon(
      Icons.info,
      color: Colors.grey,
    );
    if (widget.responseMessage != null && widget.responseMessage != '') {
      msgText = Text( widget.responseMessage! ,style:const TextStyle(color: Colors.red),);

      iconRes = const Icon(
        Icons.error,
        color: Colors.red,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
