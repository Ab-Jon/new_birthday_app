import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import '../model/surprise_message.dart';


Future<List<SurpriseMessage>> fetchSurpriseMessages() async {
  final response = await http.get(Uri.parse(
    'https://docs.google.com/spreadsheets/d/e/2PACX-1vR4Ni5uc6ImLA3WyB0T-npas1lcEqsufoakTfBJjsraU6Xq4O0blHhhXxMhzut8unIrfbbeQkh51yvY/pub?output=csv',
  ));

  if (response.statusCode == 200) {
    final csvData = const CsvToListConverter().convert(response.body);
    final messages = <SurpriseMessage>[];

    // Skip header row (index 0)
    for (var i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      messages.add(SurpriseMessage(
        sender: row[1].toString(), // adjust based on your form fields
        message: row[2].toString(),
      ));
    }

    return messages;
  } else {
    throw Exception('Failed to load messages');
  }
}
