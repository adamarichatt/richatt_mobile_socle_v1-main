// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello `
  String get gretting {
    return Intl.message(
      'Hello ',
      name: 'gretting',
      desc: '',
      args: [],
    );
  }

  /// `Let’s Find the right doctor for you`
  String get gretting2 {
    return Intl.message(
      'Let’s Find the right doctor for you',
      name: 'gretting2',
      desc: '',
      args: [],
    );
  }

  /// `Search a doctor!`
  String get search {
    return Intl.message(
      'Search a doctor!',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Appointment`
  String get upcoming_app {
    return Intl.message(
      'Upcoming Appointment',
      name: 'upcoming_app',
      desc: '',
      args: [],
    );
  }

  /// `No Upcoming Appointment`
  String get no_upcoming_app {
    return Intl.message(
      'No Upcoming Appointment',
      name: 'no_upcoming_app',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get Favorite {
    return Intl.message(
      'Favorite',
      name: 'Favorite',
      desc: '',
      args: [],
    );
  }

  /// `Available now`
  String get available_now {
    return Intl.message(
      'Available now',
      name: 'available_now',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `RDVs`
  String get rdvs {
    return Intl.message(
      'RDVs',
      name: 'rdvs',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get Schedule {
    return Intl.message(
      'Schedule',
      name: 'Schedule',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get SeeAll {
    return Intl.message(
      'See All',
      name: 'SeeAll',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile information`
  String get editprofile {
    return Intl.message(
      'Edit profile information',
      name: 'editprofile',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notif {
    return Intl.message(
      'Notifications',
      name: 'notif',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get langue {
    return Intl.message(
      'Language',
      name: 'langue',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get Security {
    return Intl.message(
      'Security',
      name: 'Security',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get Theme {
    return Intl.message(
      'Theme',
      name: 'Theme',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get Help {
    return Intl.message(
      'Help & Support',
      name: 'Help',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contact {
    return Intl.message(
      'Contact us',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get Privacy {
    return Intl.message(
      'Privacy policy',
      name: 'Privacy',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get Logout {
    return Intl.message(
      'Logout',
      name: 'Logout',
      desc: '',
      args: [],
    );
  }

  /// `Your health is our priority.`
  String get onBoardingTitle1 {
    return Intl.message(
      'Your health is our priority.',
      name: 'onBoardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Building healthier communities.`
  String get onBoardingTitle2 {
    return Intl.message(
      'Building healthier communities.',
      name: 'onBoardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Advancing healthcare together.`
  String get onBoardingTitle3 {
    return Intl.message(
      'Advancing healthcare together.',
      name: 'onBoardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// ` Welcome to a world of compassionate care `
  String get onBoardingSubTitle1 {
    return Intl.message(
      ' Welcome to a world of compassionate care ',
      name: 'onBoardingSubTitle1',
      desc: '',
      args: [],
    );
  }

  /// `one appointment at a time. Together, we thrive.`
  String get onBoardingSubTitle2 {
    return Intl.message(
      'one appointment at a time. Together, we thrive.',
      name: 'onBoardingSubTitle2',
      desc: '',
      args: [],
    );
  }

  /// ` towards a healthier future.`
  String get onBoardingSubTitle3 {
    return Intl.message(
      ' towards a healthier future.',
      name: 'onBoardingSubTitle3',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get french {
    return Intl.message(
      'French',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming`
  String get upcoming {
    return Intl.message(
      'Upcoming',
      name: 'upcoming',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `reschedule`
  String get reschedule {
    return Intl.message(
      'reschedule',
      name: 'reschedule',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
