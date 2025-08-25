import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../styles/base_styles.dart';
import 'stars_animation.dart';
import 'how_work_modal.dart';
import 'terms_agreement.dart';
import '../../styles/pages/plan_page_styles.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? subtitle;
  final VoidCallback? onInfo;
  final VoidCallback? onBack;
  final EdgeInsets? padding;
  final Widget? logo;
  final bool showTerms;

  const AuthScaffold({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.onInfo,
    this.onBack,
    this.padding,
    this.logo,
    this.showTerms = true,
  });

  void _openInfoModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x4D000000),
        pageBuilder: (_, __, ___) => const HowWorkModal(),
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              const StarsAnimation(),
              SafeArea(
                child: Column(
                  children: [
                    // HEADER
                    const SizedBox(height: 0),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: BaseStyles.white,
                              size: 30,
                            ),
                            onPressed:
                                onBack ?? () => Navigator.of(context).maybePop(),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child:
                                logo ??
                                SvgPicture.asset(
                                  'assets/icons/logo.svg',
                                  width: 60,
                                  height: 40,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: BaseStyles.white,
                              size: 30,
                            ),
                            onPressed: onInfo ?? () => _openInfoModal(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        title,
                        style: PlanPageStyles.pageTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Center(child: subtitle!),
                    ],
                    const SizedBox(height: 20),
                    // MAIN CONTENT, always take remaining space and scroll if needed
                    Expanded(
                      child: (padding != null)
                          ? Padding(
                              padding: padding!,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: child,
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: child,
                            ),
                    ),
                  ],
                ),
              ),
              // BOTTOM FIXED TERMS
              if (showTerms)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 40,
                  child: Center(
                    child: const TermsAgreement(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
