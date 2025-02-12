import 'package:chat_app/presentation/setting/widgets/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/theme_cubit.dart';
import '../../../core/utils/app_color.dart';
import '../../../data/services/service_locator.dart';
import '../../../logic/cubits/chat/chat_cubit.dart';
import '../../../logic/cubits/chat/chat_state.dart';
import '../../../router/app_router.dart';
import '../../chat/chat_screen.dart';
import 'color_picker_dialog.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  void _updateTheme(BuildContext context, Color color) {
    context.read<ThemeCubit>().changeTheme(color);
  }

  void _toggleDarkMode(BuildContext context, bool isDark) {
    context.read<ThemeCubit>().toggleDarkMode(isDark);
  }

  void _showColorPicker(BuildContext context, Color selectedColor) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: selectedColor,
        onColorSelected: (color) => _updateTheme(context, color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        bool isDarkMode = theme.brightness == Brightness.dark;
        Color primaryColor = theme.primaryColor;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Blocked Users",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              // 🔹 Blocked Users List
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.blockedUsers.isEmpty) {
                    return const Center(child: Text("No blocked users"));
                  }
                  return SizedBox(
                    height: 220, // 🔹 Adjust height to fit cards
                    child: Scrollbar(
                      // 🔹 Adds scrollbar for better UX
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // 🔹 Allows horizontal scrolling
                        child: Row(
                          children: state.blockedUsers.map((user) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              // 🔹 Adds shadow for a raised effect
                              child: Container(
                                width: 180, // 🔹 Set fixed width for each card
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      // 🔹 User Avatar
                                      radius: 30,
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2),
                                      child: Text(
                                        (user['fullName']?.isNotEmpty ?? false)
                                            ? user['fullName']![0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      user['fullName'] ?? 'Unknown',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.message,
                                          size: 18, color: Colors.white),
                                      label: const Text("Chat",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () =>
                                          getIt<AppRouter>().push(ChatScreen(
                                        receiverId: user['id'] ?? '',
                                        receiverName:
                                            user['fullName'] ?? 'Unknown',
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // 🔹 Theme Selector
              const Text("Themes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ThemeSelector(
                availableColors: availableColors,
                selectedColor: primaryColor,
                onColorSelected: (color) => _updateTheme(context, color),
                onCustomColorTap: () => _showColorPicker(context, primaryColor),
              ),
              const SizedBox(height: 20),

              // 🔹 Dark Mode Switch
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: isDarkMode,
                activeColor: primaryColor,
                activeTrackColor: primaryColor.withOpacity(0.25),
                onChanged: (isDark) => _toggleDarkMode(context, isDark),
              ),
            ],
          ),
        );
      },
    );
  }
}
