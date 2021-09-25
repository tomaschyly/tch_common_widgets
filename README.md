# tch_common_widgets

Flutter common widgets & theming package used by [Tomas Chyly](https://tomas-chyly.com/en/). Contains custom widgets that are used on multiple projects. As well as global theming capability.

This package is made to work with and some features require my package [tch_appliable_core](https://github.com/tomaschyly/tch_appliable_core). However you can use this package without it, you will just not be able to use some of the widgets.

**Platforms notice:** I have worked on projects that use Flutter on all platforms, but my focus is on **Mobile** and **Desktop**. Therefore some widgets and features may not work on **Web**, but should work on other platforms. Personally I do not consider Flutter ready for web dev.

## Contents

1. [Installation](#installation)
2. [Theme](#theme)
3. [Widgets](#widgets)
4. [Dialogs](#dialogs)   
5. [Roadmap](#roadmap)

## Installation

In your project's `pubspec.yaml` add:
```yaml
dependencies:
  tch_common_widgets: ^0.7.2
```

If your IDE does not autoImport, add manually:

```dart
import 'package:tch_common_widgets/tch_common_widgets.dart';
```

## Theme

### CommonTheme setup and usage

Create `lib/core/AppTheme.dart` and in this file create constants for your colors, TextStyles, dimensions. Then use them to create CommonTheme compatible Styles.
See the example code snippet:

```dart
const kColorPrimary = const Color(0xFF1a1a1a);
const kColorPrimaryLight = const Color(0xFF404040);
const kColorPrimaryDark = const Color(0xFF000000);
const kColorSecondary = kColorGold;
const kColorSecondaryLight = kColorGoldLight;
const kColorSecondaryDark = kColorGoldDarker;

const kColorTextPrimary = kColorSilver;

const kFontFamily = 'Custom Font Family Name';

const kText = const TextStyle(color: kColorTextPrimary, fontSize: 16);
const kTextHeadline = const TextStyle(color: kColorTextPrimary, fontSize: 20);

/// Builder method that you provide to CoreApp or MaterialApp, it will wrap all pages inside CommonTheme
/// Customize CommonTheme for the app
Widget appThemeBuilder(BuildContext context, Widget child) {
  /// Change the BorderRadius depending on OS
  BorderRadius platformBorderRadius = const BorderRadius.all(const Radius.circular(8));
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    platformBorderRadius = BorderRadius.circular(0);
  }

  /// Style all IconButtonWidgets by default to be more desktop friendly
  final kIconButtonStyle = IconButtonStyle(
    width: kMinInteractiveSizeNotTouch + kCommonHorizontalMarginHalf,
    height: kMinInteractiveSizeNotTouch + kCommonVerticalMarginHalf,
    iconWidth: kIconSizeNotTouch,
    iconHeight: kIconSizeNotTouch,
    color: kColorTextPrimary,
    borderRadius: platformBorderRadius,
  );

  /// IconButtonWidgets inside AppBar have different style to default
  const kAppBarIconButtonStyle = const IconButtonStyle(
    variant: IconButtonVariant.IconOnly,
    color: kColorTextPrimary,
    borderRadius: platformBorderRadius,
  );

  final OutlineInputBorder platformInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
    ),
    borderRadius: platformBorderRadius,
  );

  /// Default Style for all TextFormFieldWidgets
  final kTextFormFieldStyle = TextFormFieldStyle(
    iOSUseNativeTextField: true, // Use embedded UITextField or UITextView for autocorrect to work on iOS
    inputDecoration: TextFormFieldStyle().inputDecoration.copyWith(
          enabledBorder: platformInputBorder,
          disabledBorder: platformInputBorder,
          focusedBorder: platformInputBorder,
          errorBorder: platformInputBorder,
          focusedErrorBorder: platformInputBorder,
        ),
    borderColor: kColorGold,
    fillColorDisabled: kColorSilver,
    disabledBorderColor: kColorSilverDarker,
    errorColor: kColorRed,
  );

  /// Modify the default Style to get style for email fields
  final TextFormFieldStyle kEmailTextFormFieldStyle = kTextFormFieldStyle.copyWith(
    textCapitalization: TextCapitalization.none,
    keyboardType: TextInputType.emailAddress,
    validations: [
      FormFieldValidation(
        validator: validateEmail,
        errorText: 'Please provide a valid email address', // Or tt('form.email.error'), if you use CoreApp Translator
      ),
    ],
  );

  return AppTheme(
    child: child,
    fontFamily: prefsInt(PREFS_FANCY_FONT) == 1 ? kFontFamily : null,
    buttonsStyle: ButtonsStyle(
      iconButtonStyle: kIconButtonStyle,
    ),
    appBarIconButtonStyle: kAppBarIconButtonStyle,
    formStyle: FormStyle(
      textFormFieldStyle: kTextFormFieldStyle,
    ),
    emailTextFormFieldStyle: kEmailTextFormFieldStyle,
  );
}

/// Custom AppTheme extensing CommonTheme to allow custom style
class AppTheme extends CommonTheme {
  final IconButtonStyle appBarIconButtonStyle;
  final TextFormFieldStyle emailTextFormFieldStyle;

  /// AppTheme initialization
  AppTheme({
    required Widget child,
    String? fontFamily,
    required ButtonsStyle buttonsStyle,
    required this.appBarIconButtonStyle,
    required DialogsStyle dialogsStyle,
    required FormStyle formStyle,
    required this.emailTextFormFieldStyle,
  }) : super(
          /// Child needs to be CommonTheme otherwise common widgets will break
          child: CommonTheme(
            child: child,
            fontFamily: fontFamily,
            buttonsStyle: buttonsStyle,
            dialogsStyle: dialogsStyle,
            formStyle: formStyle,
          ),
          fontFamily: fontFamily,
          buttonsStyle: buttonsStyle,
          dialogsStyle: dialogsStyle,
          formStyle: formStyle,
        );
}
```

To use non-default Styles that you have defined, simply provide them to widgets.

```dart
...
final appTheme = CommonTheme.of<AppTheme>(context)!;
...
/// Use kAppBarIconButtonStyle style for IconButtonWidgets in AppBar
IconButtonWidget(
  style: appTheme.appBarIconButtonStyle,
  svgAssetPath: 'images/back.svg',
  onTap: () {
    Navigator.pop(context);
  },
);
...
```

```dart
...
final appTheme = CommonTheme.of<AppTheme>(context)!;
...
/// kEmailTextFormFieldStyle make sure that this field looks and behaves as email field
TextFormFieldWidget(
  style: appTheme.emailTextFormFieldStyle,
  controller: _emailController,
  focusNode: _emailFocus,
  nextFocus: _subjectFocus,
  label: 'Email',
  textInputAction: TextInputAction.next,
),
...
```

If you want to access CommonTheme anywhere and maybe customize some style in place for some widget.

```dart
final commonTheme = CommonTheme.of(context)!;
...
/// Multiline text field that changes default Style in place to capitalize sentences
TextFormFieldWidget(
  style: commonTheme.formStyle.textFormFieldStyle.copyWith(
    textCapitalization: TextCapitalization.sentences,
  ),
  controller: _messageController,
  focusNode: _messageFocus,
  label: tt('feedback.screen.message'),
  lines: 3,
  validations: [
    FormFieldValidation(
      validator: validateRequired,
      errorText: tt('feedback.screen.message.error'),
    ),
  ],
),
...
```

### Apply your CommonTheme on whole app

```dart
...
@override
Widget build(BuildContext context) {
  return CoreApp( // Or MaterialApp if you do not use my Core package
    ...
    builder: appThemeBuilder,
    theme: ThemeData( /// You can combine CommonTheme with Material Theme
      backgroundColor: kColorPrimaryLight,
      primaryColor: kColorPrimary,
      primaryColorLight: kColorPrimaryLight,
      primaryColorDark: kColorPrimaryDark,
      accentColor: kColorSecondary,
      splashColor: kColorSecondary,
      shadowColor: kColorShadow,
    ),
    ...
  );
}
...
```

## Widgets

### CommonSpaces

* works with **CommonTheme** and **standalone**

This is a set of widgets that can be used for easy and standard spaces between other widgets.

### PreferencesSwitchWidget

* works with **CommonTheme** and **standalone**
* requires [tch_appliable_core](https://github.com/tomaschyly/tch_appliable_core) for preferences

Simple settings toggle/switch which gets and toggles int in preferences, uses it as a bool.

### TextFormFieldWidget

* works with **CommonTheme** and **standalone**
* **Custom solution to fix Flutter iOS issue with autocorrect not working!**

Wrapped TextFormField for extra styling, features mainly with CommonTheme. Has 2 variants Material, Cupertino style.

Most importantly if you set in your CommonTheme or send styling direct to widget with:

```dart
TextFormFieldStyle(
  ...
  iOSUseNativeTextField: true,
  ...
)
```

Then this widget will use custom hybrid solution to solve issue of default autcorrect not working with Flutter on iOS.
There are some limitations, mainly if you want to use custom font family, you need to integrate it with iOS as you do on iOS apps.

**Tip:** if your custom font does not work, remember that iOS does not use filenames, but actual font family name.

### SelectionFormFieldWidget

* works with **CommonTheme** and **standalone**

Custom replacement for DropdownButton, looks like normal TextFormFieldWidget and supports Focus navigation and Form validation.

### IconButtonWidget

* works with **CommonTheme** and **standalone**

InkWell based button widget for icons, 3 variants.

### ButtonWidget

* works with **CommonTheme** and **standalone**

InkWell based button widget, 2 variants, content supports text or text and preffixIcon. Loading animatin built in.

## Dialogs

### ConfirmDialog

* works with **CommonTheme** and **standalone**

Simple dialog to get user confirmations (bool) with optional text description.

### ListDialog

* works with **CommonTheme** and **standalone**

Dialog which displays list of options and allows user to select one.

## Roadmap

Until version 1.0.0 there will not be predictable roadmap. Instead development is dependant on requirements of projects where this package is used.
