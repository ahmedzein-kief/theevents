import '../../../main.dart';
import '../../services/app_localizations.dart';

extension StringLocalizationExtension on String {
  String get tr {
    final context = navigatorKey.currentContext;
    return AppLocalizations.of(context!)?.translate(this) ?? this;
  }
}
