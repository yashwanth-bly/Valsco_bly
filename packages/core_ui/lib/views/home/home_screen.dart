import 'dart:io';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_ui/views/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            authRepository: context.read<AuthRepository>(),
          )..readUser(),
        ),
        BlocProvider<AppCoreCubit>(
          create: (context) => AppCoreCubit(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        BlocProvider<ImageUploadCubit>(
          create: (context) => ImageUploadCubit(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppCoreCubit, AppCoreState>(
            listener: (context, state) {
              if (state is AppCoreLogout) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SplashScreen(),
                    ),
                    (route) => false);
              }
              if (state is AppCoreLogoutError) {
                UtilFunctions.showInSnackBar(
                    context, 'Something went wrong, Try again');
              }
            },
          ),
          BlocListener<ImageUploadCubit, ImageUploadState>(
            listener: (BuildContext context, ImageUploadState state) {
              if (state is ImageUploading) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
              if (state is ImageUploadError) {
                UtilFunctions.showInSnackBar(
                  context,
                  'Image Upload Error',
                );
              }
              if (state is ImageUploaded) {
                UtilFunctions.showInSnackBar(
                  context,
                  'Image Upload Successfully',
                );
              }
              context.read<HomeCubit>().readUser();
            },
          )
        ],
        child: const _HomeScreenView(),
      ),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          children: [
            const Icon(
              Icons.search,
              color: Colors.blue,
            ),
            const Text(
              'Search',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _onTapLogout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            final String imageUrl;
            if (state.user.photo!.isEmpty) {
              imageUrl =
                  'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250';
            } else {
              imageUrl = state.user.photo!;
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () => _onTapEditPhoto(context),
                            child: Container(
                              height: 30,
                              width: 200,
                              color: Colors.black,
                              child: const Center(
                                  child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    state.user.name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _onTapLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider<AppCoreCubit>.value(
        value: context.read<AppCoreCubit>(),
        child: AlertDialog(
          title: const Text("Logout Alert!"),
          content: const Text(
            "Are you sure want to logout?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AppCoreCubit>().logout();
                Navigator.of(ctx).pop();
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTapEditPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider<AppCoreCubit>.value(
        value: context.read<AppCoreCubit>(),
        child: AlertDialog(
          title: const Text("Choose Method"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _EditModeCard(
                icon: Icons.camera_alt_rounded,
                name: "Camera",
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              _EditModeCard(
                icon: Icons.image,
                name: 'Gallery',
                onTap: () {
                  Navigator.pop(context);

                  _pickFromGallery();
                },
              ),
            ],
          ),
          actions: const <Widget>[],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _uploadImage(File(image.path));
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      _uploadImage(File(photo.path));
    }
  }

  void _uploadImage(File file) {
    context.read<ImageUploadCubit>().uploadImage(file);
  }
}

enum EditMode { camera, gallery }

class _EditModeCard extends StatelessWidget {
  const _EditModeCard({
    required this.icon,
    required this.name,
    required this.onTap,
  });
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.orange[100],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon), Text(name)],
          ),
        ),
      ),
    );
  }
}
