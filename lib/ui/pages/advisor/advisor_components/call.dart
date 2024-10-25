import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/advisor_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class Call extends StatelessWidget {
  final String callType; // Add a parameter for the type
  Call({required this.callType, Key? key}) : super(key: key);
  final AdvisorRepo _advisorRepo = locator<AdvisorRepo>();

  @override
  Widget build(BuildContext context) {
    // Determine the future method based on callType
    final futureCalls = callType == 'upcoming'
        ? getUpcomingAdvisorCalls()
        : getPastAdvisorCalls();

    return FutureBuilder<List<dynamic>>(
      future: futureCalls, // Call the selected future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading state
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error loading data")); // Error state
        }

        // If the data is available, use it
        final List<dynamic> data = snapshot.data ?? [];

        return Container(
          padding:
              const EdgeInsets.all(20), // Add padding to the parent container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                callType == 'upcoming' ? 'Upcoming Calls' : 'Past Calls',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16), // Add space between text and grid
              data.isEmpty
                  ? Center(
                      child: Text(
                        "No calls available",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : Column(
                      children: data
                          .map((call) => callContainer(call['title']))
                          .toList(),
                    )
            ],
          ),
        );
      },
    );
  }

  Future<List<dynamic>> getUpcomingAdvisorCalls() async {
    final payload = {"advisorId": 'advisor-123'};
    AppState.blockNavigation();
    final resp = await _advisorRepo.getUpcomingCalls(payload);
    AppState.unblockNavigation();
    print("resp upcoming clallls=====> ${resp} ");
    if (resp.isSuccess()) {
      return resp.model; // Assuming the data is in the 'data' field
    } else {
      BaseUtil.showNegativeAlert('Error', resp.errorMessage);
      return []; // Return an empty list in case of failure
    }
  }

  Future<List<dynamic>> getPastAdvisorCalls() async {
    final payload = {"advisorId": 'advisor-123'};
    AppState.blockNavigation();
    final resp = await _advisorRepo.getPastCalls(payload);
    AppState.unblockNavigation();
    print("resp past clallls=====> ${resp} ");
    if (resp.isSuccess()) {
      return resp.model; // Assuming the data is in the 'data' field
    } else {
      BaseUtil.showNegativeAlert('Error', resp.errorMessage);
      return []; // Return an empty list in case of failure
    }
  }
}

Widget callContainer(String title) {
  return Container(
    margin: EdgeInsets.only(top: 24),
    padding: EdgeInsets.only(top: 14, bottom: 14, left: 18, right: 18),
    decoration: BoxDecoration(
      color: Color(0xff2D3135),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Image.asset(
                Assets.user, // Path to your image asset
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Devanshu Verma',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Call Time',
                    style: TextStyle(
                      color: Color(0xFFA2A0A2),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // SizedBox(height: 8),
                  Text(
                    '14 Sep 2024, 07:00 PM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SizedBox(height: 12),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Duration',
                  style: TextStyle(
                    color: Color(0xFFA2A0A2),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // SizedBox(height: 8),
                Text(
                  '30:00 Mins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // SizedBox(height: 12),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Divider(
            color: Color(0xFF49494B),
            height: 0,
            // indent: 0,
            thickness: 1,
          ),
        ), // Right side image
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'View Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 28,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // primary: Colors.white,
                // onPrimary: Colors.black,
                // padding: const EdgeInsets.all(0),
                padding: EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Join Call',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Left side text content
          ],
        )
      ],
    ),
  );
}
