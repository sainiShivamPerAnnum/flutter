// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  static m2(servingSize) => "*Baseado em uma porção de ${servingSize} fl. oz.";

  static m3(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'Uma porção.', other: '${formattedNumber} porções no seu sistema de uma vez.')}";

  static m4(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'Uma porção por dia.', other: '${formattedNumber} porções por dia.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "onboardText1" : MessageLookupByLibrary.simpleMessage("Economize ou invista \$ 100 e ganhe 1 ingresso de jogo todas as segundas-feiras"),
    "onboardText2" : MessageLookupByLibrary.simpleMessage("Use os ingressos para participar de jogos semanais emocionantes"),
    "onboardText3" : MessageLookupByLibrary.simpleMessage("Seu dinheiro continua crescendo com grandes retornos enquanto você joga jogos divertidos e ganha prêmios!"),
    "onboardTitle" : MessageLookupByLibrary.simpleMessage("Poupança baseada em jogos \n e investimentos🎉"),
    "onboradButton" : MessageLookupByLibrary.simpleMessage("INICIAR"),
    "resultsPageFirstDisclaimer" : m2,
    "resultsPageLethalDosageMessage" : m3,
    "resultsPageSafeDosageMessage" : m4,
    "resultsPageSafeDosageTitle" : MessageLookupByLibrary.simpleMessage("Limite Seguro Diário"),
    "resultsPageSecondDisclaimer" : MessageLookupByLibrary.simpleMessage("*Se aplica a pessoas com 18 anos ou mais. Essa calculadora não substitui conselhos médicos profissionais."),
    "splashSlowConnection" : MessageLookupByLibrary.simpleMessage("A conexão está demorando mais do que o normal")
  };
}
