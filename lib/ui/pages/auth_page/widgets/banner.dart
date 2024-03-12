part of '../auth_page.dart';

class _BannerPage {
  final String title;
  final String assetPath;
  final Alignment alignment;
  final TextAlign textAlign;

  _BannerPage({
    required this.alignment,
    required this.assetPath,
    required this.title,
    required this.textAlign,
  });
}

class _Banner extends StatefulWidget {
  const _Banner();

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  static const pageShowDuration = Duration(seconds: 5);
  static const streamPeriodicDuration = Duration(milliseconds: 100);

  final controller = PageController(initialPage: 0);
  late final Stream<double> stream = Stream.periodic(
    streamPeriodicDuration,
    (tic) {
      final fullDuration = pageShowDuration.inMilliseconds;
      final streamDuration = streamPeriodicDuration.inMilliseconds;
      final curDuration = (streamDuration * tic) % fullDuration;
      return (curDuration / (fullDuration / 100)) / 100;
    },
  );
  late final StreamSubscription streamSub;

  double streamValue = 0;
  int indexPage = 0;

  List<_BannerPage> pages = [
    _BannerPage(
      textAlign: TextAlign.left,
      alignment: Alignment.bottomLeft,
      assetPath: 'assets/banner/screen2.png',
      title: 'Создать хотелки быстро и легко, просто вставте ссылку!',
    ),
    _BannerPage(
      textAlign: TextAlign.left,
      alignment: Alignment.bottomLeft,
      assetPath: 'assets/banner/screen3.png',
      title: 'Резервируйте хотелки друзей, чтобы именно Вы, исполнили хотелку!',
    ),
    _BannerPage(
      textAlign: TextAlign.left,
      alignment: Alignment.bottomLeft,
      assetPath: 'assets/banner/screen1.png',
      title: 'Незнаете что подарить другу? Найдите его хотелки у нас!',
    ),
  ];

  @override
  void initState() {
    streamSub = stream.listen((event) {
      streamValue = event;
      if (mounted) {
        if (event == 0) {
          int nextIndex = indexPage + 1;
          if (nextIndex >= pages.length || nextIndex < 0) {
            nextIndex = 0;
          }

          controller.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSub.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (value) {
                if (indexPage != value) {
                  indexPage = value;
                  setState(() {});
                }
              },
              controller: controller,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          child: SizedBox(
                            width: 300,
                            child: Image.asset(
                              page.assetPath,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: page.alignment,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Text(
                          page.title,
                          textAlign: page.textAlign,
                          style: TextStyleBook.title20.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Row(
              children: List.generate(
                pages.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _BannerPageIndicator(
                      isActive: index == indexPage,
                      progress: streamValue,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BannerPageIndicator extends StatelessWidget {
  static const height = 5.0;
  static const maxWidth = 30.0;
  const _BannerPageIndicator({
    required this.isActive,
    required this.progress,
  });
  final bool isActive;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: ColoredBox(
        color: Theme.of(context).disabledColor,
        child: SizedBox(
          height: height,
          width: isActive ? maxWidth : height,
          child: isActive
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).iconTheme.color ?? Colors.white,
                    ),
                    child: SizedBox(
                      height: double.infinity,
                      width: maxWidth * progress,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
