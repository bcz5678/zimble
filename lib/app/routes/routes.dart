import 'package:flutter/widgets.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/home/home.dart';
//import 'package:zimble/onboarding/onboarding.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    AppStatus state,
    List<Page<dynamic>> pages,
    ) {
  switch (state) {
    /*
    Implement with Onboarding
    //case AppStatus.onboardingRequired:return [OnboardingPage.page()];
     */
    case AppStatus.unauthenticated:
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
