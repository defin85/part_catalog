import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';

class PdfService {
  Future<Uint8List> generateOrderPdf(OrderModelComposite order) async {
    final pdf = pw.Document();

    // Загружаем шрифты из локальных ассетов
    final fontData = await rootBundle.load('assets/fonts/DejaVuSans.ttf');
    final boldFontData =
        await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf');
    final font = pw.Font.ttf(fontData);
    final boldFont = pw.Font.ttf(boldFontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(order, font, boldFont),
            pw.SizedBox(height: 20),
            _buildClientInfo(order, font),
            pw.SizedBox(height: 20),
            _buildItemsTable(order, font, boldFont),
            pw.SizedBox(height: 20),
            _buildTotal(order, font, boldFont),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
      OrderModelComposite order, pw.Font font, pw.Font boldFont) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('Заказ-наряд № ${order.code}',
            style: pw.TextStyle(font: boldFont, fontSize: 24)),
        pw.Text('от ${order.documentDate.toLocal().toString().split(' ')[0]}',
            style: pw.TextStyle(font: font, fontSize: 16)),
      ],
    );
  }

  pw.Widget _buildClientInfo(OrderModelComposite order, pw.Font font) {
    // TODO: Get client and car info
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Клиент: ${order.clientId}', style: pw.TextStyle(font: font)),
        pw.Text('Автомобиль: ${order.carId}', style: pw.TextStyle(font: font)),
      ],
    );
  }

  pw.Widget _buildItemsTable(
      OrderModelComposite order, pw.Font font, pw.Font boldFont) {
    final headers = ['#', 'Наименование', 'Кол-во', 'Цена', 'Сумма'];

    final data = order.items.map((item) {
      return [
        order.items.indexOf(item) + 1,
        item.name,
        item.quantity,
        item.price,
        item.totalPrice,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(font: boldFont),
      cellStyle: pw.TextStyle(font: font),
      border: pw.TableBorder.all(),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {0: pw.Alignment.centerRight},
    );
  }

  pw.Widget _buildTotal(
      OrderModelComposite order, pw.Font font, pw.Font boldFont) {
    final total = order.items
        .fold<double>(0, (sum, item) => sum + (item.totalPrice ?? 0));
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('Итого: ', style: pw.TextStyle(font: boldFont, fontSize: 18)),
        pw.Text('${total.toStringAsFixed(2)} руб.',
            style: pw.TextStyle(font: boldFont, fontSize: 18)),
      ],
    );
  }
}
