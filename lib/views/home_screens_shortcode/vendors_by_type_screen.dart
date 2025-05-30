// import 'package:event_app/views/home_screens_shortcode/shortcode_vendor_by_types/vendor_by_types_items_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../provider/home_shortcode_provider/vendor_by_types_provider.dart';
// import '../../resources/widgets/custom_home_views/custom_user_by_type_box.dart';
//
// class VendorsByTypeScreens extends StatefulWidget {
//   final dynamic data;
//
//   const VendorsByTypeScreens({super.key, required this.data});
//
//   @override
//   State<VendorsByTypeScreens> createState() => _EventOrganizerViewState();
// }
//
// class _EventOrganizerViewState extends State<VendorsByTypeScreens> {
//   Future<void> fetchEventOrganiserData(BuildContext context) async {
//     await Provider.of<VendorByTypesProvider>(context, listen: false)
//         .fetchEventOrganiser(data: widget.data);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await fetchEventOrganiserData(context);
//       await Provider.of<VendorByTypesProvider>(context, listen: false)
//           .fetchEventOrganiser(
//               data: int.parse(widget.data['attributes']['type_id']));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Consumer<VendorByTypesProvider>(
//             builder: (context, provider, _) {
//               return CustomUserByTypeBox(
//                 onTap: (item){},
//                 fetchData: fetchEventOrganiserData,
//                 isLoading: provider.isLoading,
//                 items: provider.eventOrganiser?.data?.records ?? [],
//                 title: widget.data['attributes']['title'],
//                 seeAllText: 'See all',
//                 onSeeAllTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => VendorByTypesItems(
//                               typeId: int.parse(
//                                   widget.data['attributes']['type_id']),
//                             data: widget.data['attributes']['title'],
//                           )));
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
