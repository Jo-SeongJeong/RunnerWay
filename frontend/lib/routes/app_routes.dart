import 'package:frontend/views/auth/splash_view.dart';
import 'package:frontend/views/course/course_detail_view.dart';
import 'package:frontend/views/runnerPick/runner_pick_view.dart';
import 'package:frontend/views/running/record_detail_view.dart';
import 'package:frontend/views/search/search_view.dart';
import 'package:frontend/views/mypage/modify_info_view.dart';
import 'package:frontend/views/record/record_view.dart';
import 'package:frontend/views/auth/signup_view2.dart';
import 'package:frontend/views/auth/signup_view.dart';
import 'package:get/get.dart';
import 'package:frontend/views/main/main_view.dart';
import 'package:frontend/views/runner/runner_view.dart';

import '../views/auth/login_view.dart';
import '../views/mypage/mypage_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
        name: '/splash',
        page: () => SplashView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/main',
        page: () => MainView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/course/:type/:id',
        page: () => CourseDetailView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/search',
        page: () => SearchView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/search',
        page: () => SearchView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/runner',
        page: () => RunnerView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/runner-pick',
        page: () => RunnerPickView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/record',
        page: () => RecordView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/record/detail/:id',
        page: () => RecordDetailView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/mypage',
        page: () => MypageView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/signup',
        page: () => SignUpView(
              email: '',
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/signup2',
        page: () => SignUpView2(),
        transition: Transition.noTransition),
    GetPage(
        name: '/modify',
        page: () => ModifyInfoView(),
        transition: Transition.noTransition),
    GetPage(
        name: '/login',
        page: () => LoginView(),
        transition: Transition.noTransition),
  ];
}
