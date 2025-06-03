// import 'package:flutter/material.dart';
//
// class FreelanceBuyerPage extends StatelessWidget {
//   final List<Map<String, dynamic>> gigs = [
//     {
//       'title': 'Logo Design',
//       'price': 2500,
//       'seller': 'Ali Designs',
//       'verified': true,
//       'description': 'Custom logo with 3 concepts.',
//     },
//     {
//       'title': 'Website Development',
//       'price': 12000,
//       'seller': 'SaraTech',
//       'verified': false,
//       'description': 'Modern responsive website.',
//     },
//     {
//       'title': 'Social Media Marketing',
//       'price': 5000,
//       'seller': 'MarketingPro',
//       'verified': true,
//       'description': 'Grow your brand online.',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Browse Freelancers')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           itemCount: gigs.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.75,
//           ),
//           itemBuilder: (context, index) {
//             final gig = gigs[index];
//             return GestureDetector(
//               onTap: () {
//
//               },
//               child: Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//
//                       Text(
//                         gig['title'],
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       SizedBox(height: 5),
//
//                       Text("PKR ${gig['price']}", style: TextStyle(color: Colors.green)),
//
//                       SizedBox(height: 10),
//
//                       Text(
//                         gig['description'],
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontSize: 13),
//                       ),
//
//                       Spacer(),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             gig['seller'],
//                             style: TextStyle(fontSize: 12, color: Colors.grey[700]),
//                           ),
//                           if (gig['verified'])
//                             Icon(Icons.verified, color: Colors.blue, size: 16),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
