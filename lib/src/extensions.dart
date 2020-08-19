import 'package:recase/recase.dart';
import 'package:inflection2/inflection2.dart';

extension StringExtensions on String {
  String get removeFirstUnderscore {
    if (substring(0, 1) == '_') {
      return substring(1, length);
    } else {
      return this;
    }
  }

  String get removeAllUnderscore {
    return replaceAll('_', '');
  }

  String get camelCase {
    return ReCase(this).camelCase.removeAllUnderscore;
  }

  String get pascalCase {
    return ReCase(this).pascalCase.removeAllUnderscore;
  }

  String get snakeCase {
    return ReCase(this).snakeCase;
  }

  String get pluralize {
    return convertToPlural(this);
  }
}
