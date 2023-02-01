import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/widgets/form_text_field.dart';

class IconImageSelectionDialog extends StatelessWidget {
  const IconImageSelectionDialog({
    super.key,
    this.icon,
    this.imageURL,
    required this.showImage,
    required this.onSelectIconButtonPressed,
    required this.onImageURLSubmitted,
    required this.onCheckmarkButtonPressed,
    required this.onUploadImageButtonPressed,
  });
  final bool showImage;
  final IconData? icon;
  final String? imageURL;
  final Function()? onUploadImageButtonPressed;
  final Function(bool)? onCheckmarkButtonPressed;
  final Function()? onSelectIconButtonPressed;
  final Function(String?)? onImageURLSubmitted;
  static final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        Strings.selectIconOrAddImage,
        textAlign: TextAlign.center,
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          card(
            title: Strings.icon,
            selected: !showImage,
            onCheckmarkButtonPressed: onCheckmarkButtonPressed,
            context: context,
            image: Icon(
              icon!,
              size: 42,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(width: 1, color: Colors.white30),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSelectIconButtonPressed!();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Text(
                      Strings.selectIcon,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Text(
            Strings.or,
            style: TextStyle(fontSize: 20, color: Colors.white54),
          ),
          card(
            title: Strings.image,
            selected: showImage,
            onCheckmarkButtonPressed: onCheckmarkButtonPressed,
            context: context,
            image: imageURL!.isEmpty
                ? Container(
                    width: 42,
                    height: 42,
                    color: Colors.white12,
                    child: const Icon(
                      Icons.upload_sharp,
                      color: Colors.white30,
                    ),
                  )
                : Image.network(
                    imageURL!,
                    width: 42,
                    height: 42,
                  ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilder(
                  key: formKey,
                  child: FormTextField(
                    initialValue: imageURL ?? "",
                    label: Strings.imageURL,
                    name: Strings.imageURL,
                    padding: const EdgeInsets.all(0),
                    onSubmitted: onImageURLSubmitted,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: const [
                      Expanded(
                          child: Divider(
                        indent: 5,
                        endIndent: 5,
                        thickness: 0.6,
                        color: Colors.white60,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          Strings.or,
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.6,
                        indent: 5,
                        endIndent: 5,
                        color: Colors.white60,
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(width: 1, color: Colors.white38),
                    ),
                    onPressed: onUploadImageButtonPressed,
                    child: const Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Text(
                        Strings.uploadImage,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget card({
    required String title,
    required bool selected,
    required Function(bool)? onCheckmarkButtonPressed,
    required Widget image,
    required Widget content,
    required BuildContext context,
  }) {
    return Stack(
      alignment: Alignment.topRight,
      fit: StackFit.passthrough,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: 300,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    Center(child: image),
                    Expanded(child: content),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(
              Icons.check_circle,
            ),
            iconSize: 38,
            onPressed: () {
              Navigator.of(context).pop();
              onCheckmarkButtonPressed!(title == Strings.image);
            },
            color: selected ? Colors.green.withOpacity(0.75) : Colors.black12,
            hoverColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
