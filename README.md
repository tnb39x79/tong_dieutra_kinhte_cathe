## gov.statistics.investigation.economic
## TỔNG ĐIỀU TRA KINH TẾ 2026 - CƠ SỞ SẢN XUẤT KINH DOANH CÁ THỂ

### Phiếu 7.7/CT-LT-MAU: PHIẾU THU THẬP THÔNG TIN ĐỐI VỚI TOÀN BỘ CƠ SỞ SẢN XUẤT KINH DOANH CÁ THỂ
### Phiếu số 7.1/CT-CN: PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG CÔNG NGHIỆP CỦA CƠ SỞ SXKD CÁ THỂ
### Phiếu số 7.2/CT-VT: PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG VẬN TẢI CỦA CƠ SỞ SXKD CÁ THỂ
### Phiếu số 7.3/CT-LT: PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG LƯU TRÚ CỦA CƠ SỞ SẢN XUẤT KINH DOANH CÁ THỂ
### Phiếu số 7.4/CT-TM: PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG BÁN BUÔN; BÁN LẺ; SỬA CHỮA Ô TÔ, MÔ TÔ, XE MÁY VÀ XE CÓ ĐỘNG CƠ KHÁC; ### CÁC HOẠT ĐỘNG KHÁC CỦA CƠ SỞ SXKD CÁ THỂ
### Phiếu số 7.5/CT-MAU: PHIẾU THU THẬP THÔNG TIN ĐỐI VỚI CƠ SỞ SẢN XUẤT KINH DOANH CÁ THỂ ĐƯỢC CHỌN MẪU
### Phiếu 7.6/CT-VT-MAU: PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG VẬN TẢI CỦA CƠ SỞ SXKD CÁ THỂ ĐƯỢC CHỌN MẪU
### Phiếu 7.7/CT-LT-MAU: PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG LƯU TRÚ CỦA CƠ SỞ SXKD CÁ THỂ ĐƯỢC CHỌN MẪU	

## **Usage**

1. Open the project in vscode or android studio editor or...
2. Open terminal
3. Run 
```
 
## Config and build

### Before release app

##### Change the bundle id in:

- ios/Runner/Info.plist
- android/app/build.gradle
- lib/config/constants/app_values.dart

```dart
// build apk dev 
    flutter build apk --flavor dev --dart-define "BASE_API=https://v1_capi_giasanxuat.gso.gov.vn/"
 

```
```
// build apk prod
flutter build apk --flavor prod --dart-define "BASE_API=http://v1_capi_giasanxuat.gso.gov.vn/"
```
```
// build app bundle
flutter build appbundle --flavor prod
```
v1.1.7: Chỉ phiếu các thể