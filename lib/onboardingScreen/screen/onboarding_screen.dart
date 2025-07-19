import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saveyourmoney/screens/home/home_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to SmartBudget!",
      "description": "Your AI-powered financial buddy made just for students in Nepal. Track spending, plan goals, and build smart habits.",
      "image": "assets/onboarding_1.jpg",
    },
    {
      "title": "Scan. Track. Save.",
      "description": "Use OCR to scan receipts or add expenses manually. Stay in control, even offline.",
      "image": "assets/onboarding_2.jpg",
    },
    {
      "title": "Smart AI Tips Daily",
      "description": "Get personalized saving advice in English or Nepali — powered by AI or your financial advisor.",
      "image": "assets/onboarding_3.jpg",
    },
    {
      "title": "Gamify Your Budget!",
      "description": "Set savings goals, earn rewards, unlock badges. Make money management fun and motivating!",
      "image": "assets/onboarding_4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            //make this gradient more subtle
            colors: [Color.fromARGB(255, 231, 129, 101), Color.fromARGB(255, 237, 185, 51), Color.fromARGB(255, 236, 199, 148)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
                    return _buildOnboardingPage(
                      title: data["title"]!,
                      description: data["description"]!,
                      image: data["image"]!,
                      isLastPage: index == _onboardingData.length - 1,
                    );
                  },
                ),
              ),
              _buildBottomControls(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({required String title, required String description, required String image, required bool isLastPage}) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: const Color.fromARGB(151, 255, 255, 255),
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(image, height: 200.h, width: double.infinity, fit: BoxFit.cover),
              ),
              SizedBox(height: 32.h),
              Text(
                title,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2D2D2D)),
                textAlign: TextAlign.center,
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF4B4B4B)),
                ),
              ],
              if (isLastPage)
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_currentPage < _onboardingData.length - 1)
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              child: Text(
                "Skip",
                style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentPage == index ? 24.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFFFFC107) : Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                  border: _currentPage == index ? Border.all(color: const Color(0xFFFFC107), width: 2) : null,
                ),
              ),
            ),
          ),
          if (_currentPage < _onboardingData.length - 1)
            GestureDetector(
              onTap: () {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Icon(Icons.arrow_forward_ios, color: const Color.fromARGB(255, 231, 183, 40), size: 18.sp),
              ),
            ),
        ],
      ),
    );
  }
}
