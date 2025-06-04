import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class CustomEditableTextField extends StatefulWidget {
  CustomEditableTextField(
      {super.key,
      required this.placeholder,
      required this.quillController,
      this.borderRadius,
      this.showToolBar = true,
      this.fieldHeight = 500});
  final QuillController quillController;
  final String placeholder;
  final double? borderRadius;
  bool? showToolBar;
  double? fieldHeight;

  @override
  State<CustomEditableTextField> createState() =>
      _CustomEditableTextFieldState();
}

class _CustomEditableTextFieldState extends State<CustomEditableTextField> {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.fieldHeight,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10)),
          child: Column(
            children: [
              if (widget.showToolBar == true)
                Column(
                  children: [
                    QuillSimpleToolbar(
                      controller: widget.quillController,
                      config: const QuillSimpleToolbarConfig(
                        toolbarSize: 0,
                        sectionDividerSpace: 0,
                        toolbarIconAlignment: WrapAlignment.start,
                        toolbarIconCrossAlignment: WrapCrossAlignment.start,
                        toolbarSectionSpacing: 0,
                        multiRowsDisplay: true,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border(top: BorderSide(color: Colors.black))),
                        showClipboardCopy: false,
                        showClipboardPaste: false,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ],
                ),
              Expanded(
                child: QuillEditor.basic(
                  controller: widget.quillController,
                  config: QuillEditorConfig(
                    padding: const EdgeInsets.all(10),
                    showCursor: true,
                    placeholder: widget.placeholder,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

/// This function will convert the delta to html
String convertDeltaToHtml({required QuillController quilController}) {
  final ops = quilController.document.toDelta().toJson();
  final converter = QuillDeltaToHtmlConverter(
    ops,
    ConverterOptions.forEmail(),
  );

  final html = converter.convert();
  return html;
}

/// Convert html to delta object
Delta convertHtmlToDelta({required String htmlContent}) {
  final delta = HtmlToDelta().convert(htmlContent);
  return delta;
}

String removeHtmlTags({required String htmlString}) {
  final RegExp regExp =
      RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlString.replaceAll(regExp, '').trim();
}
