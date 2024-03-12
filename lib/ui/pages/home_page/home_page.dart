import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/ui/pages/home_page/home_vm.dart';
import 'package:wishes_app/ui/widgets/menu/menu.dart';
import 'package:wishes_app/ui/widgets/responsive_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => HomeVM(mainBloc: mainBloc),
      child: Material(
        child: ResponsiveUi(
          builder: (context, mode) {
            if (mode == ResponsiveUiMode.mobile) {
              return const _HomeMobile();
            }
            return const _HomeDesctop();
          },
        ),
      ),
    );
  }
}

class _HomeMobile extends StatefulWidget {
  const _HomeMobile();

  @override
  State<_HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<_HomeMobile> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final vm = context.read<HomeVM>();
      final pageController = vm.pageController;
      pageController.jumpToPage(vm.pageIndex);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeVM>();
    final pageController = vm.pageController;
    final pages = vm.pages;
    final pageIndex = context.select((HomeVM vm) => vm.pageIndex);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            onPageChanged: (index) {
              if (index != pageIndex) {
                vm.pageIndex = index;
              }
            },
            controller: pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages.values.elementAt(index);
            },
          ),
        ),
        BottomMenu(
          curIndex: pageIndex,
          onTap: (index) {
            if ((pageIndex - index).abs() > 1) {
              pageController.jumpToPage(index);
            } else {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          },
          items: pages.keys.toList(),
        ),
      ],
    );
  }
}

class _HomeDesctop extends StatelessWidget {
  const _HomeDesctop();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeVM>();
    final pages = vm.pages;
    final pageIndex = context.select((HomeVM vm) => vm.pageIndex);

    return Row(
      children: [
        SideMenu(
          curIndex: pageIndex,
          onLogoTap: () {
            vm.pageIndex = 0;
          },
          onTap: (index) {
            vm.pageIndex = index;
          },
          items: pages.keys.toList(),
        ),
        Expanded(
          child: pages.values.elementAt(pageIndex),
        ),
      ],
    );
  }
}
