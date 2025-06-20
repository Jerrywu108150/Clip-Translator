# Clip Translator

Clip Translator is a lightweight demo that translates the current clipboard text and displays it in a widget.

The widget source lives inside the `Clip Translator Widget` folder. To add it to the Xcode project:

1. Open the project in Xcode.
2. Choose **File > New > Target...** and select **Widget Extension**.
3. Set the source directory to `Clip Translator Widget` and replace any generated files with the ones in this repository.

The app uses the open source [LibreTranslate](https://libretranslate.de) API to perform translations.
