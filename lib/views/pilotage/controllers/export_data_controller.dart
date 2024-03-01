import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

import '../../../api/supabse_db.dart';
import 'entite_pilotage_controler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportDataController {
  final DataBaseController dataBaseController = DataBaseController();
  final EntitePilotageController entitePilotageController = Get.find();

  Future<Map<String, dynamic>?> loadDataExport(String entite, int annee) async {
    final result = await dataBaseController.getExportEntite(entite, annee);
    return result;
  }

  Future downloadExcel(Map<String, dynamic> mapData) async {
    final entite = mapData["entite"];
    final annee = mapData["annee"];
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];

    final List<String> headers = [
      'numero',
      'Reference',
      'Indicateurs',
      'Unite',
      'Realise_$annee'
    ];
    for (int col = 1; col <= headers.length; col++) {
      sheet.getRangeByIndex(1, col).setText(headers[col - 1]);
    }
    sheet.getRangeByIndex(1, 1).columnWidth = 10;
    sheet.getRangeByIndex(1, 2).columnWidth = 15;
    sheet.getRangeByIndex(1, 3).columnWidth = 100;
    sheet.getRangeByIndex(1, 4).columnWidth = 15;
    sheet.getRangeByIndex(1, 5).columnWidth = 15;

    final List<dynamic> listData = mapData["data"];
    for (var row = 0; row < listData.length; row++) {
      final item = listData[row];
      if (item["numero"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 1).setText(item["numero"].toString());
      }
      if (item["reference"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 2).setText(item["reference"].toString());
      }
      if (item["intitule"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 3).setText(item["intitule"].toString());
      }
      if (item["unite"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 4).setText(item["unite"].toString());
      }
      if (item["realise"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 5).setText(item["realise"].toString());
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    final Uint8List excelBytes = Uint8List.fromList(bytes);
    final String fileName = '${entite}_$annee.xlsx';

    if (kIsWeb) {
      final html.Blob blob = html.Blob([excelBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    }
  }

  Future downloadPDF(Map<String, dynamic> mapData) async {
    // Générer le PDF
    final Uint8List pdfBytes = await generatePDF(mapData);

    // Convertir les bytes du PDF en un objet blob
    final blob = html.Blob([pdfBytes]);

    final entite = mapData["entite"] ?? "";
    final annne = mapData["annee"] ?? "";

    final version = Random().nextInt(100);

    // Créer un objet URL pour le blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Créer un élément <a> pour télécharger le fichier PDF
    html.AnchorElement(href: url)
      ..setAttribute("download",
          "indicateurs_performance_${entite}_${annne}_$version.pdf")
      ..click(); // Simuler le clic sur le lien pour démarrer le téléchargement

    // Libérer l'URL de l'objet blob après le téléchargement
    html.Url.revokeObjectUrl(url);
  }

  List<List<String>> getRows(List<dynamic> datas, dynamic annee) {
    List<String> initialRow = [
      '#',
      "Référence",
      'Indicateurs',
      'Unité',
      'Réalisé $annee'
    ];
    final List<List<String>> result = [initialRow];

    for (var data in datas) {
      var a = "${data["intitule"]}".replaceAll('’', "'");
      var intutle = a.replaceAll("…", "...");
      result.add([
        "${data["numero"]}",
        "${data["reference"]}",
        intutle,
        "${data["unite"]}",
        "${data["realise"] ?? "---"}",
      ]);
    }

    return result;
  }

  PdfColor getColor(String kColor) {
    final Map<String, PdfColor> mapColor = {
      "bleu-ciel": PdfColors.blue,
      "gris": PdfColors.amber,
      "vert": PdfColors.green,
      "rouge": PdfColors.red,
    };
    final color = mapColor[kColor] ?? PdfColors.amber;
    return color;
  }

  Future<Uint8List> generatePDF(Map<String, dynamic> mapData) async {
    final logoSFICA = await rootBundle.load('assets/logos/logo_sifca_bon.png');
    final Uint8List bytesLogoSFICA = logoSFICA.buffer.asUint8List();
    final Uint8List? bytesLogoFiliale = entitePilotageController.bytesLogo;

    final List<dynamic> allData = mapData["data"];

    // Create a PDF document
    final pdf = pw.Document();

    // Add the table to the PDF
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.only(
            left: 10, right: 10, top: 20, bottom: 20), // Ajuster les marges ici
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Container(
                  height: 50,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(
                          pw.MemoryImage(
                            bytesLogoSFICA,
                          ),
                          width: 80, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        pw.Text('Indicateurs de Performance RSE',
                            style: pw.TextStyle(
                                color: getColor(mapData["color"]),
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold)),
                        bytesLogoFiliale != null
                            ? pw.Image(
                                pw.MemoryImage(
                                  bytesLogoFiliale,
                                ),
                                width: 80, // Adjust width as needed
                                height: 40, // Adjust height as needed
                              )
                            : pw.Container(),
                      ])),
            ),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Entreprise : "),
              pw.Text("${mapData["entreprise"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Filiale : "),
              pw.Text("${mapData["filiale"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Entité : "),
              pw.Text("${mapData["entite"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Année : "),
              pw.Text("${mapData["annee"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FixedColumnWidth(100),
                3: const pw.FixedColumnWidth(85),
                4: const pw.FixedColumnWidth(140),
              },
              context: context,
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              oddRowDecoration:
                  const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE5E5E5)),
              headerDecoration:
                  pw.BoxDecoration(color: getColor(mapData["color"])),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey, width: .5)),
              ),
              data: getRows(allData, mapData["annee"]),
            ),
          ];
        },
      ),
    );

    // Save the PDF as a Uint8List
    return await pdf.save();
  }
}
