import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/user_by_types_items_screen.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/user_type_inner_page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_shortcode_provider/users_by_type_provider.dart';
import '../../../core/widgets/custom_home_views/custom_user_by_type_box.dart';

class UsersByTypeScreen extends StatefulWidget {
  final dynamic data;

  const UsersByTypeScreen({super.key, required this.data});

  @override
  State<UsersByTypeScreen> createState() => _UsersByTypeScreenState();
}

class _UsersByTypeScreenState extends State<UsersByTypeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCelebrityData(context);
    });
  }

  Future<void> fetchCelebrityData(BuildContext context) async {
    final provider = Provider.of<UsersByTypeProvider>(context, listen: false);
    await provider.fetchCelebrities(data: widget.data, context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<UsersByTypeProvider>(
            builder: (context, provider, _) {
              final attributes = widget.data?['attributes'];
              if (attributes == null) {
                return const Center(child: Text(''));
              }
              final typeId = int.tryParse(attributes['type_id'].toString()) ?? 2;
              final items = provider.getRecordsByTypeId(typeId);
              return CustomUserByTypeBox(
                fetchData: fetchCelebrityData,
                onTap: (item) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserTypeInnerPageScreen(
                                typeId: typeId,
                                title: attributes['title'],
                                id: item.id,
                              )));
                },
                isLoading: provider.isLoading,
                items: items,
                title: attributes['title'],
                seeAllText: AppStrings.viewAll,
                onSeeAllTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => UserByTypeItemsScreen(
                                title: attributes['title'],
                                typeId: typeId,
                              )));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
