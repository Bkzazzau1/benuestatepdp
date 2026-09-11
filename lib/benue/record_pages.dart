import 'package:flutter/material.dart';

import 'clean_record_pages.dart';

/// Compatibility wrappers keep existing navigation and tests stable while the
/// campaign-facing pages use the polished operational presentation.
class RecordsOverviewPage extends StatelessWidget {
  const RecordsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) => const CleanCampaignOperationsPage();
}

class RecordsCampaignOperationsPage extends CleanCampaignOperationsPage {
  const RecordsCampaignOperationsPage({super.key});
}

class RecordsSituationRoomPage extends CleanSituationRoomPage {
  const RecordsSituationRoomPage({super.key});
}

class RecordsFieldNetworkPage extends CleanFieldNetworkPage {
  const RecordsFieldNetworkPage({super.key});
}

class RecordsLogisticsTasksPage extends CleanLogisticsTasksPage {
  const RecordsLogisticsTasksPage({super.key});
}

class RecordsElectionDayPage extends CleanElectionDayPage {
  const RecordsElectionDayPage({super.key});
}
