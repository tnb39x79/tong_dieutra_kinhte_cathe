import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_linhvuc.dart';

//typedef LinhVucCallback = TableDmLinhvuc Function(TableDmLinhvuc);
class DropdownCategory extends StatefulWidget {
  const DropdownCategory(
      {super.key,
      required this.onLinhVucSelected,
      required this.danhSachLinhVuc,
      this.linhVucItemSelected});
  final Function(TableDmLinhvuc) onLinhVucSelected;
  // final LinhVucCallback onLinhVucSelected;
  final List<TableDmLinhvuc> danhSachLinhVuc;
  final TableDmLinhvuc? linhVucItemSelected;

  @override
  State<DropdownCategory> createState() => DropdownCategoryState();
}

class DropdownCategoryState extends State<DropdownCategory> {
  /// The prefecture to be selected by default.
  TableDmLinhvuc? activeLinhVuc = TableDmLinhvuc.defaultLinhVuc();

  /// List of all the extracted prefectures.
  List<TableDmLinhvuc> linhVucs = List<TableDmLinhvuc>.empty(growable: true);

  /// Future to fetch the prefectures only once and not trigger the FutureBuilder continuously.
  // late final Future? linhVucsFuture;

  @override
  void initState() {
    super.initState();
    activeLinhVuc =
        widget.linhVucItemSelected ?? TableDmLinhvuc.defaultLinhVuc();
    linhVucs = widget.danhSachLinhVuc;
  }

  /// Builds the dropdown widget of the prefecture objects.
  Widget categoryDropdown(BuildContext context) {
    return DropdownButton<TableDmLinhvuc>(
      value: activeLinhVuc,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      isExpanded: true,
      isDense: true,
      iconSize: 40,
      underline: Container(
        height: 2,
        color: primaryColor,
      ),
      style: styleSmall.copyWith(color: blackText),
      onChanged: (TableDmLinhvuc? newValue) {
        setState(() {
          debugPrint("selected linh vuc ${newValue?.tenLinhVuc}");
          activeLinhVuc = newValue!;
          widget.onLinhVucSelected(
              newValue); // Notify about the new selected prefecture.
        });
      },
      items: linhVucs
          .map<DropdownMenuItem<TableDmLinhvuc>>((TableDmLinhvuc value) {
        return DropdownMenuItem<TableDmLinhvuc>(
          value: value,
          child: value.maLV != '0'
              ? Text('${value.maLV!} - ${value.tenLinhVuc!}')
              : Text(value.tenLinhVuc!),
        );
      }).toList(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //       future: linhVucsFuture,
  //       builder: (context, snapshot) {
  //         return categoryDropdown(context);
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return categoryDropdown(context);
    });
  }
}
