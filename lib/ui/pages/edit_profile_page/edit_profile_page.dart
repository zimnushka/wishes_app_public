import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/bloc/main_state.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/ui/pages/edit_profile_page/edit_profile_vm.dart';
import 'package:wishes_app/ui/pages/edit_profile_page/widgets/update_photo.dart';
import 'package:wishes_app/ui/styles/colors_book.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/app_switch.dart';
import 'package:wishes_app/ui/widgets/back_button.dart';
import 'package:wishes_app/ui/widgets/date_picker/date_picker.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => EditProfileVM(mainBloc: mainBloc),
      child: const _EditProfilePageView(),
    );
  }
}

class _EditProfilePageView extends StatelessWidget {
  const _EditProfilePageView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditProfileVM>();
    return BlocListener<MainBloc, MainState>(
      listenWhen: (prevState, state) {
        return prevState.authState.user != state.authState.user;
      },
      listener: (context, state) {
        vm.onUserUpdate(state.authState.user);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  children: [
                    BackButtonL(
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Редактирование профиля',
                          style: TextStyleBook.title20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: const _EditProfileForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm();

  Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    DateTime? initDate,
  }) async {
    DateTime? date = initDate;
    await showDialog(
      context: context,
      builder: (context) {
        return AppDatePicker(
          onCancel: () {
            Navigator.pop(context);
          },
          onSelectDate: (val) {
            Navigator.pop(context);
            date = val;
          },
          initDate: initDate,
          startDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
      },
    );
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditProfileVM>();
    final nameController = vm.nameContreller;
    final gender = context.select((EditProfileVM vm) => vm.gender);
    final birthDate = context.select((EditProfileVM vm) => vm.birthDate);
    final nameError = context.select((EditProfileVM vm) => vm.nameError);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text('фото профиля', style: TextStyleBook.text12),
          ),
          const UpdateProfilePhoto(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text('имя', style: TextStyleBook.text12),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextField(
              controller: nameController,
              style: TextStyleBook.title17,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          if (nameError != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10),
              child: Text(
                nameError,
                style: TextStyleBook.text12.copyWith(color: ColorsBook.error),
              ),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text('дата рождения', style: TextStyleBook.text12),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
            onTap: () async {
              final res = await showDatePickerDialog(context, initDate: birthDate);
              if (res != null) {
                vm.birthDate = res;
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).cardColor,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        birthDate != null ? DateFormat('dd.MM.yyyy').format(birthDate) : 'Не указано',
                        style: TextStyleBook.title17.copyWith(
                          color: birthDate == null ? Theme.of(context).disabledColor : null,
                        ),
                      ),
                      if (birthDate != null)
                        InkWell(
                          onTap: () {
                            vm.birthDate = null;
                          },
                          child: const Icon(Icons.cancel),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text('пол', style: TextStyleBook.text12),
          ),
          AppSwitch(
            firstLabel: 'M',
            secondLabel: 'Ж',
            indicatorColor: Theme.of(context).scaffoldBackgroundColor,
            bkgColor: Theme.of(context).cardColor,
            isFirstSelected: gender == Gender.male,
            onChange: (val) {
              if (val) {
                vm.gender = Gender.male;
              } else {
                vm.gender = Gender.female;
              }
            },
          ),
          const SizedBox(height: 50),
          const _SaveButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  static const double height = 60;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditProfileVM>();
    final isButtonActive = context.select((EditProfileVM vm) => vm.isButtonActive);
    final isLoading = context.select((EditProfileVM vm) => vm.isLoading);
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: isLoading
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, height),
                ),
                onPressed: isButtonActive ? vm.save : null,
                child: const Text('Сохранить изменения'),
              ),
      ),
    );
  }
}
