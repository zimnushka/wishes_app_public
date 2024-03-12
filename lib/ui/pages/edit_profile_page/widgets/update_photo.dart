import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/ui/pages/edit_profile_page/edit_profile_vm.dart';

class UpdateProfilePhoto extends StatelessWidget {
  const UpdateProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditProfileVM>();
    final user = context.select((MainBloc vm) => vm.state.authState.user);
    final image = context.select((EditProfileVM vm) => vm.image);
    final needDeleteImage = context.select((EditProfileVM vm) => vm.needDeleteImage);
    ImageProvider? imageProvider;

    if (user.photoUrl != null) {
      imageProvider = NetworkImage(user.photoUrl!);
    }
    if (image != null) {
      imageProvider = MemoryImage(image.bytes);
    }

    if (needDeleteImage) {
      imageProvider = null;
    }

    return PopupMenuButton(
      tooltip: '',
      offset: const Offset(0, 80),
      itemBuilder: (context) {
        if (user.photoUrl == null) {
          vm.updatePhoto(context);
          return [];
        }
        return [
          PopupMenuItem(
            onTap: () => vm.updatePhoto(context),
            child: const Row(
              children: [
                Icon(
                  Icons.edit,
                ),
                SizedBox(width: 10),
                Text('Изменить фото'),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () => vm.deletePhoto(context),
            child: const Row(
              children: [
                Icon(
                  Icons.delete,
                ),
                SizedBox(width: 10),
                Text('Удалить фото'),
              ],
            ),
          ),
        ];
      },
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).disabledColor,
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? Icon(
                Icons.add_a_photo_outlined,
                color: Theme.of(context).primaryColor,
              )
            : null,
      ),
    );
  }
}
