import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';
import 'package:academic_activities_mobile/main.dart';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:academic_activities_mobile/models/DatGiaiApi.dart';
import 'package:academic_activities_mobile/models/DiemRenLuyen.dart';
import 'package:academic_activities_mobile/models/Lop.dart';
import 'package:academic_activities_mobile/models/SinhVien.dart';
import 'package:academic_activities_mobile/models/NguoiDung.dart';
import 'package:academic_activities_mobile/screens/auth/login_screen.dart';
import 'package:academic_activities_mobile/services/api_service.dart';
import 'package:academic_activities_mobile/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../cores/widgets/colorful_loader.dart';
import 'personal_info.dart';
import 'package:dio/dio.dart';
import 'academic_activities.dart';
import 'training_points.dart';
import 'my_registrations.dart';
import 'support_registration.dart';
import 'certificates.dart';
import 'settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  final ProfileService _profileService = ProfileService();
  bool _isUploadingAvatar = false;
  bool _isLoading = true;
  final ApiService _api = ApiService();
  File? _image;
  String? _errorMessage;

  NguoiDung? _user;
  SinhVien? _profile;
  Lop? _lop;
  Map<String, dynamic>? _fullData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _loadProfile(); // AUTO RELOAD PROFILE
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho bấm ngoài để tắt
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon logout đẹp lung linh
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Tiêu đề
              const Text(
                "Đăng xuất tài khoản",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),

              // Nội dung
              Text(
                "Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Nút hành động
              Row(
                children: [
                  // Nút "Hủy"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: Colors.grey.shade700,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nút "Đăng xuất"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove("access_token");

                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (_) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Đăng xuất",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _profileService.getProfile();

      print("====================================");
      print(">>> RAW DATA TỪ API:");
      print(result);
      print("====================================");

      if (result["success"] == true) {
        final data = result["data"];

        setState(() {
          _user = data["user"];
          _profile = data["profile"];
          _lop = data["lop"];

          _fullData = data;

          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Không thể tải thông tin';
          _isLoading = false;
        });
      }
    } catch (e) {
      print(">>> ERROR:");
      print(e);
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _image = File(picked.path));
      uploadAvatar();
    }
  }

  Future<void> uploadAvatar() async {
    if (_image == null) {
      print("No image selected");
      return;
    }

    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(_image!.path),
    });

    try {
      setState(() {
        _isUploadingAvatar = true;
      });

      final res = await _api.dio.post(
        "/profile/avatar",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (res.data['success'] == true) {
        String newAvatarPath = res.data['avatar_url'];

        setState(() {
          _user = _user?.copyWith(anhdaidien: newAvatarPath);
          _isUploadingAvatar = false;
        });

        _loadProfile();

        SuccessToast.show(context, 'Cập nhật avatar thành công!');
      } else {
        setState(() {
          _isUploadingAvatar = false;
        });

        ErrorToast.show(context, 'Lỗi: ${res.data['message']}');
      }
    } catch (e) {
      setState(() {
        _isUploadingAvatar = false;
      });

      ErrorToast.show(context, 'Lỗi upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF1F5F9),
        body: ColorfulLoader(),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(),

          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(18, 28, 18, 32),
                child: Column(
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildMenuSection(context),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ HEADER -------------------

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/patterns/pattern2.jpg',
              fit: BoxFit.cover,
            ),
            Container(color: Colors.black.withOpacity(0.35)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E3A8A).withOpacity(0.85),
                    const Color(0xFF2563EB).withOpacity(0.75),
                    const Color(0xFF3B82F6).withOpacity(0.65),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Avatar
                  GestureDetector(
                    onTap: () => pickImage(),
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF60A5FA), Color(0xFFFBBF24)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              image: DecorationImage(
                                image: _user?.anhdaidien != null
                                    ? NetworkImage(
                                            "http://10.0.2.2:8000/storage/${_user!.anhdaidien!}",
                                          )
                                          as ImageProvider
                                    : const AssetImage(
                                        'assets/images/avatars/default_avt.jpg',
                                      ),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  // ✅ XỬ LÝ LỖI KHI LOAD ẢNH
                                  print('Error loading avatar: $exception');
                                },
                              ),
                            ),
                          ),
                        ),
                        if (_isUploadingAvatar)
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        else
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => pickImage(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    _user?.hoten ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _infoChip(
                        FontAwesomeIcons.idCard,
                        'MSSV: ${_profile?.masinhvien ?? 'N/A'}',
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        FontAwesomeIcons.userGraduate,
                        _lop?.tenlop ?? 'N/A',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  // ------------------ STATS -------------------

  Widget _buildStatsRow() {
    final activities = _fullData?['activities'] ?? [];
    final certificates = _fullData?['certificates'] ?? [];

    final diem = _fullData?['diemRenLuyen'];
    final diemRL = diem?.finalScore ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: FontAwesomeIcons.trophy,
            value: '${activities.length}',
            label: 'Hoạt động',
            color: const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: FontAwesomeIcons.award,
            value: '${certificates.length}',
            label: 'Đạt giải',
            color: const Color(0xFFEC4899),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: FontAwesomeIcons.star,
            value: '$diemRL',
            label: 'Điểm RL',
            color: const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // ------------------ MENU -------------------

  Widget _buildMenuSection(BuildContext context) {
    final menu = [
      _MenuItemData(
        FontAwesomeIcons.user,
        'Thông tin cá nhân',
        const Color(0xFF3B82F6),
      ),
      _MenuItemData(
        FontAwesomeIcons.trophy,
        'Hoạt động học thuật',
        const Color(0xFFF59E0B),
      ),
      _MenuItemData(
        FontAwesomeIcons.chartLine,
        'Điểm rèn luyện',
        const Color(0xFF10B981),
      ),
      _MenuItemData(
        FontAwesomeIcons.clipboardList,
        'Đăng ký dự thi',
        const Color(0xFF8B5CF6),
      ),
      _MenuItemData(
        FontAwesomeIcons.handsHelping,
        'Đăng ký hỗ trợ - cổ vũ',
        const Color(0xFFEC4899),
      ),
      _MenuItemData(
        FontAwesomeIcons.certificate,
        'Chứng nhận',
        const Color(0xFFEAB308),
      ),
      _MenuItemData(FontAwesomeIcons.gear, 'Cài đặt', const Color(0xFF6B7280)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < menu.length; i++) ...[
            _buildMenuItem(
              context: context,
              icon: menu[i].icon,
              title: menu[i].title,
              color: menu[i].color,
              isFirst: i == 0,
              isLast: i == menu.length - 1,
              onTap: () => _navigateToScreen(context, i),
            ),
            if (i < menu.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 68),
                child: Divider(height: 1, color: Colors.grey.shade100),
              ),
          ],
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) async {
    Widget? screen;

    switch (index) {
      case 0:
        screen = PersonalInfoScreen(
          user: _user!,
          profile: _profile!,
          lop: _lop,
        );
        break;

      case 1:
        screen = const AcademicActivitiesScreen();
        break;

      case 2:
        screen = TrainingPointsScreen(
          diemRenLuyen: _fullData?["diemRenLuyen"] as DiemRenLuyen?,
        );
        break;

      // ✅ CASE 3 - XỬ LÝ RIÊNG
      case 3:
        final raw = _fullData?['competitionRegistrations'] ?? [];
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyRegistrationsScreen(
              competition: raw,
              onRefresh: _loadProfile,
            ),
          ),
        );

        if (result == true) {
          _loadProfile(); // ✅ RELOAD KHI TRẢ VỀ
        }
        return; // ✅ RETURN ĐỂ KHÔNG CHẠY CODE BÊN DƯỚI

      case 4:
        final raw = _fullData?['registrations'] ?? [];

        final activities = <DangKyHoatDongFull>[];
        for (var item in raw) {
          if (item is DangKyHoatDongFull) {
            activities.add(item);
          } else {
            activities.add(DangKyHoatDongFull.fromJson(item));
          }
        }

        screen = SupportRegistrationScreen(activities: activities);
        break;

      case 5:
        final raw = _fullData?['certificates'] ?? [];

        final List<DatGiaiApi> certs = raw.map<DatGiaiApi>((e) {
          if (e is DatGiaiApi) return e;
          return DatGiaiApi.fromJson(e);
        }).toList();

        screen = CertificatesScreen(certificates: certs);
        break;

      case 6:
        screen = const SettingsScreen();
        break;

      default:
        return;
    }

    // ✅ CHỈ PUSH KHI screen != null
    if (screen != null) {
      final needRefresh = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen!),
      );

      if (needRefresh == true) {
        _loadProfile(); // chỉ reload khi screen con yêu cầu
      }
    }
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color? color,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(20) : Radius.zero,
            bottom: isLast ? const Radius.circular(20) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: FaIcon(icon, color: color, size: 18)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ------------------ LOGOUT -------------------

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        _showLogoutDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(
              FontAwesomeIcons.rightFromBracket,
              size: 16,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final Color? color;

  _MenuItemData(this.icon, this.title, this.color);
}

extension CopyWithNguoiDung on NguoiDung {
  NguoiDung copyWith({String? anhdaidien}) {
    return NguoiDung(
      manguoidung: manguoidung,
      tendangnhap: tendangnhap,
      matkhau: matkhau,
      hoten: hoten,
      email: email,
      sodienthoai: sodienthoai,
      vaitro: vaitro,
      trangthai: trangthai,
      ngaytao: ngaytao,
      ngaycapnhat: ngaycapnhat,
      anhdaidien: anhdaidien ?? this.anhdaidien,
    );
  }
}
