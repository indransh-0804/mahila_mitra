import 'package:flutter/material.dart';
import 'package:mahila_mitra/onboard/onboard_content.dart';
import 'package:mahila_mitra/sign/sign_in/sign_in.dart';
import 'package:mahila_mitra/sign/sign_up/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late PageController _controller;
  int _currentPage = 0;


  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  Future<void> _markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  AnimatedContainer _buildDots({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(50),
      ),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // PAGE VIEW
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(contents[i].image),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 30 : 35,
                          ),
                        ),
                        SizedBox(height: (height >= 840) ? 60 : 30),
                        Text(
                          contents[i].desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: (width <= 550) ? 17 : 25,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // BUTTONS & DOTS
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _currentPage + 1 == contents.length
                    ? Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _markOnboardingSeen();
                          Navigator.pushReplacement(context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: (width <= 550)
                              ? const EdgeInsets.symmetric(horizontal: 100, vertical: 16)
                              : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
                        ),
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 16 : 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _markOnboardingSeen();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()
                              )
                          );
                        },style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: (width <= 550)
                              ? const EdgeInsets.symmetric(horizontal: 100, vertical: 16)
                              : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
                        ),
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 16 : 18,
                          ),
                        ),
                      ),
                    ],
                  )
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SKIP BUTTON
                    TextButton(
                      onPressed: () {
                        _controller.jumpToPage(contents.length - 1);
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: (width <= 550) ? 13 : 17,
                        ),
                      ),
                      child: Text(
                        "SKIP",
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),

                    // DOTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                            (index) => _buildDots(index: index),
                      ),
                    ),

                    // NEXT BUTTON
                    ElevatedButton(
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                        padding: (width <= 550)
                            ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                            : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                      ),
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: (width <= 550) ? 13 : 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
