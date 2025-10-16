import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/archive_bloc.dart';
import '../blocs/archive_event.dart';
import '../blocs/archive_state.dart';
import '../constants/colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/archive_card.dart';
import 'add_edit_archive_screen.dart';

class ArchivesScreen extends StatefulWidget {
  const ArchivesScreen({super.key});

  @override
  State<ArchivesScreen> createState() => _ArchivesScreenState();
}

class _ArchivesScreenState extends State<ArchivesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    context.read<ArchiveBloc>().add(LoadArchives());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ArchiveBloc, ArchiveState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final totalArchives = state.archives.length;
              final upToDate = state.archives
                  .where((a) => a.status == "Up to Date")
                  .length;
              final needsUpdate = totalArchives - upToDate;

              // 🔹 Filter archives based on search text
              final filteredArchives = state.archives.where((a) {
                if (_searchText.isEmpty) return true;
                return a.name.toLowerCase().contains(_searchText);
              }).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.accentPurple,
                                    AppColors.accentBlue,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.storage_rounded,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Mahdy's Archives",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  "Photography Collection",
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: AppColors.textDark,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Stats Row (dynamic now)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCard(
                          title: "Total Archives",
                          value: "$totalArchives",
                          color: AppColors.purple,
                          icon: Icons.folder_rounded,
                        ),
                        StatCard(
                          title: "Up to Date",
                          value: "$upToDate",
                          color: AppColors.green,
                          icon: Icons.check_circle_rounded,
                        ),
                        StatCard(
                          title: "Needs Update",
                          value: "$needsUpdate",
                          color: AppColors.orange,
                          icon: Icons.error_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Search Bar (fully functional)
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black54,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search archives by name...",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Add New Button
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const AddEditArchiveScreen(isEdit: false),
                          ),
                        );
                        context.read<ArchiveBloc>().add(LoadArchives());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "+ Add New Archive",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Archive List
                    if (filteredArchives.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No archives found.\nTry a different search.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: filteredArchives.map((archive) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditArchiveScreen(
                                      isEdit: true,
                                      archive: archive,
                                    ),
                                  ),
                                );
                                context
                                    .read<ArchiveBloc>()
                                    .add(LoadArchives());
                              },
                              child: ArchiveCard(
                                name: archive.name,
                                lastUpdated: archive.lastUpdated,
                                capacity: archive.capacity,
                                notes: archive.notes ?? "",
                                status: archive.status,
                                statusColor: archive.status == 'Up to Date'
                                    ? AppColors.green
                                    : AppColors.orange,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
