// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  static String m17(servingSize) =>
      "*Baseado em uma porção de ${servingSize} fl. oz.";

  static String m18(quantity, formattedNumber) =>
      "${Intl.plural(quantity, one: 'Uma porção.', other: '${formattedNumber} porções no seu sistema de uma vez.')}";

  static String m19(quantity, formattedNumber) =>
      "${Intl.plural(quantity, one: 'Uma porção por dia.', other: '${formattedNumber} porções por dia.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "onboradButton": MessageLookupByLibrary.simpleMessage("INICIAR"),
        "resultsPageFirstDisclaimer": m17,
        "resultsPageLethalDosageMessage": m18,
        "resultsPageSafeDosageMessage": m19,
        "resultsPageSafeDosageTitle":
            MessageLookupByLibrary.simpleMessage("Limite Seguro Diário"),
        "resultsPageSecondDisclaimer": MessageLookupByLibrary.simpleMessage(
            "*Se aplica a pessoas com 18 anos ou mais. Essa calculadora não substitui conselhos médicos profissionais."),
        "splashSlowConnection": MessageLookupByLibrary.simpleMessage(
            "A conexão está demorando mais do que o normal")
      };
}
