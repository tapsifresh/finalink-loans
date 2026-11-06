import 'dart:html' as html;

void downloadCsvWeb(String csv, String filename) {
  final blob = html.Blob(<String>[csv], 'text/csv;charset=utf-8;');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
