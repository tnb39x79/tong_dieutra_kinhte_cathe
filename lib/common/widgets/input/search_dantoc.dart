import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_nhomnganh_vcpa.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';

class SearchDanToc extends StatefulWidget {
  const SearchDanToc({
    super.key,
    required this.onSearch,
    required this.onChange,
    this.validator,
    this.value,
    this.isError = false,
  });

  final Function(TableDmDanToc)? onChange;
  final Function(String) onSearch;
  final String? Function(String?)? validator;
  final String? value;
  final bool isError;

  @override
  State<SearchDanToc> createState() => _SearchDanTocState();
}

class _SearchDanTocState extends State<SearchDanToc> {
  late Iterable<TableDmDanToc> fitlerResult = <TableDmDanToc>[];
  String? _searchingWithQuery;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<TableDmDanToc>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        _searchingWithQuery = textEditingValue.text;
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        }
        final Iterable<TableDmDanToc> optionResult =
            await widget.onSearch(textEditingValue.text);
        if (_searchingWithQuery != textEditingValue.text) {
          return fitlerResult;
        }
        fitlerResult = optionResult;
        return optionResult;
        // if (textEditingValue.text.isEmpty) {
        //   return const Iterable.empty();
        // }
        // return  onSearch(textEditingValue.text);
      },
      displayStringForOption: (TableDmDanToc option) => option.tenDanToc!,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<TableDmDanToc> onSelected,
          Iterable<TableDmDanToc> options) {
        return Align(
          alignment: Alignment.topLeft,
          heightFactor: 100.0,
          child: Material(
            child: Container(
              width:
                  MediaQuery.of(context).size.width - AppValues.padding * 3.5,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(AppValues.borderLv1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(4.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final TableDmDanToc option = options.elementAt(index);
                  String title = option.tenDanToc!;
                  String subTitle =
                      'Tên gọi khác: ${option.tenGoiKhac}';
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          onSelected(option);
                          widget.onChange!(option);
                        },
                        child: ListTile(
                          title: Text(
                            title,
                            style: const TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500),
                          ),
                           subtitle: Text(
                            subTitle,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black38),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        fieldTextEditingController.text = widget.value ?? '';
        return Form(
          autovalidateMode: AutovalidateMode.always,
          child: TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: styleSmall,
            validator: widget.validator,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(top: 4, left: 16, right: 16),
                hintStyle: styleSmall.copyWith(color: greyColor),
                hintText: 'Nhập vào đây',
                fillColor: backgroundWhiteColor,
                filled: true,
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
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                )),
          ),
        );
      },
    );
  }
}
