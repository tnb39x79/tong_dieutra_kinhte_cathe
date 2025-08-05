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
  static const intervieweeInformation = '/interviewee-information';
 
  static const question07 = '/question-07';
  static const question08 = '/question-08'; 

  //progress
  static const progress = '/progress';

  //send error data
  static const senderrordata = '/send-error';

  //check ky dieu tra
  static const checkkydieutra = '/check-kydieutra';
  static const downloadModelAI = '/download-model-ai';
}
