// import 'package:cleanercms/data/title_cards.dart';
// import 'package:cleanercms/util/responsive.dart';
// import 'package:cleanercms/widgets/custom_card_widget.dart';
// import 'package:flutter/material.dart';
//
// class ActivityDetailsCard extends StatelessWidget {
//   const ActivityDetailsCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userDetails = UserDetails();
//
//     return GridView.builder(
//       itemCount: userDetails.userData.length,
//       shrinkWrap: true,
//       physics: const ScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
//         crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
//         mainAxisSpacing: 12.0,
//       ),
//       itemBuilder: (context, index) => CustomCard(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 15, bottom: 4),
//               child: Text(
//                 userDetails.userData[index].value,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Text(
//               userDetails.userData[index].title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cleanercms/data/title_cards.dart';
import 'package:cleanercms/util/responsive.dart';
import 'package:cleanercms/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';

class ActivityDetailsCard extends StatefulWidget {
  const ActivityDetailsCard({super.key});

  @override
  _ActivityDetailsCardState createState() => _ActivityDetailsCardState();
}

class _ActivityDetailsCardState extends State<ActivityDetailsCard> {
  UserDetails userDetails = UserDetails();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await userDetails.fetchUserData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      itemCount: userDetails.userData.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
        crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) => CustomCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                userDetails.userData[index].value,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              userDetails.userData[index].title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
