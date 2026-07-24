// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swyft_rails/services/user_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color _purple = Color(0xff4001a8);

  String _firstName = '';
  String _initials = '?';
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name = await UserService.getUserName();
    final initials = await UserService.getInitials();
    final avatar = await UserService.getAvatarPath();
    if (mounted) {
      setState(() {
        _firstName = name ?? 'User';
        _initials = initials;
        _avatarPath = avatar;
      });
    }
  }

  void _changeAvatar() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _sheetOption(
                Icons.camera_alt_outlined,
                'Take a photo',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Camera will be wired to backend'),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
              const SizedBox(height: 12),
              _sheetOption(
                Icons.photo_library_outlined,
                'Choose from gallery',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Gallery will be wired to backend'),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
              if (_avatarPath != null) ...[
                const SizedBox(height: 12),
                _sheetOption(
                  Icons.delete_outline_rounded,
                  'Remove photo',
                  () async {
                    final nav = Navigator.of(context);
                    await UserService.removeAvatar();
                    if (mounted) {
                      nav.pop();
                      await _loadProfile();
                    }
                  },
                  isDestructive: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption(IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red.shade600 : Colors.black87;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? Colors.red.shade200 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDestructive
                    ? Colors.red.shade50
                    : _purple.withOpacity(0.08),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red.shade600 : _purple,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? Colors.red.shade600
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Purple header ──────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_purple, Color(0xff5a1ec8)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _changeAvatar,
                      child: Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 3),
                            ),
                            child: ClipOval(
                              child: _avatarPath != null
                                  ? Image.asset(_avatarPath!,
                                      fit: BoxFit.cover)
                                  : Container(
                                      color: Colors.white.withOpacity(0.15),
                                      child: Center(
                                        child: Text(
                                          _initials,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border:
                                    Border.all(color: _purple, width: 1.5),
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  size: 14, color: _purple),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _firstName.isNotEmpty ? _firstName : 'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _changeAvatar,
                      child: Text(
                        'Tap avatar to change photo',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Settings list ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Account'),
                    const SizedBox(height: 10),
                    _settingsTile(
                      icon: Icons.email_outlined,
                      title: 'Email settings',
                      subtitle: 'bharneyadedokun@gmail.com',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _settingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      subtitle: '••••••••••',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _settingsTile(
                      icon: Icons.verified_user_outlined,
                      title: '2-step verification',
                      subtitle: 'Manage your authentication methods',
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
                    _sectionLabel('Preferences'),
                    const SizedBox(height: 10),
                    _settingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Choose what we get in touch about',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _settingsTile(
                      icon: Icons.language_rounded,
                      title: 'Language Settings',
                      subtitle: 'English (UK)',
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
                    _sectionLabel('Danger zone'),
                    const SizedBox(height: 10),
                    _settingsTile(
                      icon: Icons.no_accounts_outlined,
                      title: 'Close your account',
                      subtitle: 'If you want to stop using SwiftRails',
                      onTap: () {},
                      isDestructive: true,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
