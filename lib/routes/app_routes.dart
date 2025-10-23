part of 'app_pages.dart';

abstract class AppRoutes {
  // unknown page
  static const unknownPage = '/not-found';

  static const splash = '/';

  // auth
  static const login = '/login';

  // main_menu
  static const mainMenu = '/main-menu';

  //interview
  static const interviewLocationList = '/interviewLocationList';
  static const interviewList = '/interviewList';
  static const interviewListDetail = '/interviewListDetail';
  static const interviewObjectList = '/interview-object-list';

  //questions
  static const activeStatus = '/status';
  static const generalInformation = '/general-information';
  static const sync = '/sync';
   static const syncV2 = '/sync-v2';
  static const intervieweeInformation = '/interviewee-information';

  static const questionTB = '/question-tb';
  static const questionPhieuCN = '/question-phieu-cn';
  static const questionPhieuVT = '/question-phieu-vt';
  static const questionPhieuLT = '/question-phieu-lt';
  static const questionPhieuTM = '/question-phieu-tm';
  static const questionPhieuMau = '/question-phieu-mau';

  //progress
  static const progress = '/progress';

  //send error data
  static const senderrordata = '/send-error';

  //check ky dieu tra
  static const checkkydieutra = '/check-kydieutra';
  static const downloadModelAI = '/download-model-ai';
   static const downloadModelAI_V2 = '/download-model-ai-v2';
}
