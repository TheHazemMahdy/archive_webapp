import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/archive_bloc.dart';
import '../blocs/archive_event.dart';
import '../constants/colors.dart';
import '../screens/add_edit_archive_screen.dart';

class ArchiveCard extends StatelessWidget {
  final String name;
  final String lastUpdated;
  final String capacity;
  final String notes;
  final String status;
  final Color statusColor;

  const ArchiveCard({
    super.key,
    required this.name,
    required this.lastUpdated,
    required this.capacity,
    required this.notes,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: statusColor.withOpacity(0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.storage_rounded, color: statusColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 16, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(
                "Last updated: $lastUpdated",
                style: const TextStyle(color: AppColors.textLight, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            "Capacity: $capacity",
            style: const TextStyle(color: AppColors.textLight, fontSize: 13),
          ),

          const SizedBox(height: 6),
          Text(
            notes,
            style: const TextStyle(
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),

          // const SizedBox(height: 12),
          // OutlinedButton(
          //   onPressed: () async {
          //     await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => AddEditArchiveScreen(isEdit: true),
          //       ),
          //     );
          //
          //     // 🔹 Refresh the list when returning
          //     if (context.mounted) {
          //       context.read<ArchiveBloc>().add(LoadArchives());
          //     }
          //   },
          //
          //   style: ButtonStyle(
          //     padding: WidgetStateProperty.all(
          //       const EdgeInsets.symmetric(vertical: 12),
          //     ),
          //     minimumSize: WidgetStateProperty.all(const Size.fromHeight(40)),
          //
          //     // 🔹 Dynamic border color based on hover state
          //     side: WidgetStateProperty.resolveWith<BorderSide>(
          //           (states) {
          //         if (states.contains(WidgetState.hovered)) {
          //           return const BorderSide(color: AppColors.accentPurple, width: 1.5);
          //         }
          //         return const BorderSide(color: Colors.grey, width: 1);
          //       },
          //     ),
          //
          //     shape: WidgetStateProperty.all(
          //       RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //
          //     // 🔹 Background changes on hover
          //     backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //           (states) {
          //         if (states.contains(WidgetState.hovered)) {
          //           return Colors.grey.shade200; // light gray on hover
          //         }
          //         return Colors.transparent; // default
          //       },
          //     ),
          //
          //     // 🔹 Ripple / press color
          //     overlayColor: WidgetStateProperty.all(
          //       AppColors.accentPurple.withOpacity(0.1),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: const [
          //       Icon(Icons.edit_outlined, color: AppColors.textDark),
          //       SizedBox(width: 8),
          //       Text(
          //         "Update Archive",
          //         style: TextStyle(color: AppColors.textDark),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
