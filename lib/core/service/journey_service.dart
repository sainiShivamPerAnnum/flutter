import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class JourneyService extends PropertyChangeNotifier<JourneyServiceProperties> {
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
}
