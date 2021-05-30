# tch_common_widgets

Flutter common widgets & theming package used by [Tomas Chyly](https://tomas-chyly.com/en/). Contains custom widgets that are used on multiple projects. As well as global theming capability.

This package is made to work with and some features require my package [tch_appliable_core](https://github.com/tomaschyly/tch_appliable_core). However you can use this package without it, you will just not be able to use some of the widgets.

## Contents

1. [Installation](#installation)
2. [Theme](#theme)
3. [Widgets](#widgets)
4. [Roadmap](#roadmap)

## Installation

In your project's `pubspec.yaml` add:
```yaml
dependencies:
  tch_common_widgets: ^0.0.5
```

## Theme

*Coming soon...*

## Widgets

### CommonSpaces

* requires **CommonTheme**

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

## Roadmap

Until version 1.0.0 there will not be predictable roadmap. Instead development is dependant on requirements of projects where this package is used.
