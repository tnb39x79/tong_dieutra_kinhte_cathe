extension FormatComma on String{
  String get amountValue{
   return  replaceAll(',', '.');
  }
}