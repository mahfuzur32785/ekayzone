part of 'locale_cubit.dart';
abstract class LocaleSate {
  final Locale locale;
  LocaleSate(this.locale);
}

class SelectedLocale extends LocaleSate {
  SelectedLocale(Locale locale) : super(locale);
}