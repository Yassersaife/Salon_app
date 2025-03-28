import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/theme.dart';
import '../providers/user_provider.dart';

class CustomAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const CustomAppBar({Key? key, required this.searchController, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: searchController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'ابحث عن صالون أو خدمة...',
              prefixIcon: Icon(Icons.search, color: AppColors.textLight),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onSearch,
          ),
        ),
      ),
    );
  }
}
