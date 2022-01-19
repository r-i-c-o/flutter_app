/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:shimmer/shimmer.dart';
import 'package:tarot/helpers/firebase_logger.dart';
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/helpers/subscription_manager.dart';
import 'package:tarot/widgets/animated_appbar.dart';
import 'package:tarot/widgets/free_premium_popup.dart';
import 'package:tarot/widgets/gradient_blur.dart';
import 'package:tarot/widgets/grey_italic.dart';
import 'package:tarot/widgets/tarot_button.dart';

class ChooseAdviser extends StatefulWidget {
  static const String routeName = '/choose_adviser';

  @override
  _ChooseAdviserState createState() => _ChooseAdviserState();
}

class _ChooseAdviserState extends State<ChooseAdviser> {
  static const List<String> tarologists = [
    'assets/images/tarologist/tarot_preview1.png',
    'assets/images/tarologist/tarot_preview2.png',
    'assets/images/tarologist/tarot_preview3.png',
    'assets/images/tarologist/tarot_preview4.png',
  ];
  late final ScrollController _controller;
  rive.Artboard? _riveArtboard;
  late rive.RiveAnimationController _riveController;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    FirebaseLogger.logViewTarotExpert();
    rootBundle.load('assets/animations/search.riv').then((anim) async {
      final riveAnimation = rive.RiveFile.import(anim);
      final artboard = riveAnimation.mainArtboard;
      artboard.addController(_riveController = rive.SimpleAnimation('search'));
      setState(() {
        _riveArtboard = artboard;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _future() async {
    await Future.delayed(Duration(seconds: 5));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: FadingAppBar(
        controller: _controller,
        title: 'Choose an Astrologer',
        onLeadingPressed: () {
          NavigationHelper.instance.onBackPressed();
          FirebaseLogger.logClick('chat_back');
        },
      ),
      body: FutureBuilder(
        future: _future(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TarologistOops();
          } else {
            return CustomScrollView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GradientBlur(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GreyItalicText('Please Wait'),
                          ),
                          Text(
                            'CHAT WITH TAROT EXPERT',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "We‘re searching for available tarot expert for you",
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_riveArtboard == null)
                                SizedBox()
                              else
                                SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: rive.Rive(artboard: _riveArtboard!)),
                              SizedBox(width: 4.0),
                              Text(
                                'Searching',
                                style: const TextStyle(
                                  color: Color(0xFF959595),
                                ),
                              ),
                              Dots(),
                            ],
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.0),
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Image.asset(
                                'assets/images/tarologist/tarologist.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.731,
                    children: [
                      ShimmerTarologistTile(img: tarologists[0]),
                      ShimmerTarologistTile(img: tarologists[1]),
                      ShimmerTarologistTile(img: tarologists[2]),
                      ShimmerTarologistTile(img: tarologists[3]),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class ShimmerTarologistTile extends StatelessWidget {
  final String img;

  const ShimmerTarologistTile({Key? key, required this.img}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget pic = Image.asset(
      img,
      fit: BoxFit.cover,
    );
    return Stack(
      children: [
        pic,
        Shimmer.fromColors(
            highlightColor: Colors.white.withOpacity(0.5),
            baseColor: Colors.white.withOpacity(0.0),
            child: pic),
      ],
    );
  }
}

class Dots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PulseDot(delay: 0),
        PulseDot(delay: 300),
        PulseDot(delay: 600),
      ],
    );
  }
}

class PulseDot extends StatefulWidget {
  final int delay;

  const PulseDot({Key? key, required this.delay}) : super(key: key);
  @override
  _PulseDotState createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<TextStyle> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = TextStyleTween(
      begin: const TextStyle(color: Color(0xFF959595), fontSize: 18.0),
      end: const TextStyle(color: Color(0x00959595), fontSize: 18.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _waitAndPlay();
  }

  void _waitAndPlay() async {
    await Future.delayed(Duration(milliseconds: widget.delay));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyleTransition(
      style: _fadeAnimation,
      child: const Text('.'),
    );
  }
}

class TarologistOops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseLogger.logViewOops();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Image.asset(
          'assets/images/ooops.png',
          width: 166.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Sorry, at this moment all experts are busy, but we have the gift for You.',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white.withOpacity(0.03),
            ),
            child: GradientBlur(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '3-DAY\'s PREMIUM FOR FREE',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Unlimited access to all spreads without ads',
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/popup_premium.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        TarotButton(
          title: "CONTINUE",
          color: Colors.orange,
          onTap: () {
            Navigator.of(context).pop();
            SubscriptionManager.instance.grantFreePremium();
            FirebaseLogger.logClickFreePremium();
            showDialog(
              useSafeArea: false,
              context: context,
              builder: (context) => FreePremiumPopup(),
            );
          },
        ),
      ],
    );
  }
}
*/
