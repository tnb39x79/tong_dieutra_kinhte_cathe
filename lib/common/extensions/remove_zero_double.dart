extension RemoveZeroDouble on double{
 String get toStringV2{
  final intPart = truncate();
  if(this-intPart ==0){
   return '$intPart';
  }else{
   return '$this';
  }
 }
}