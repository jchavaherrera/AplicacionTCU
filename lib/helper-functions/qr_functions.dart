String getProduct (String qrData) {
  const start = 'Producto:"';
  const end = '"';
  final startIndex = qrData.indexOf(start);
  final endIndex = qrData.indexOf(end, startIndex + start.length);

  return qrData.substring(startIndex + start.length, endIndex);
}

int getPrice (String qrData) {
  const start = 'Precio:"';
  const end = '"';
  final startIndex = qrData.indexOf(start);
  final endIndex = qrData.indexOf(end, startIndex + start.length);

  return int.parse(qrData.substring(startIndex + start.length, endIndex));
}

String getCurrency (String qrData) {
  const start = 'Moneda:"';
  const end = '"';
  final startIndex = qrData.indexOf(start);
  final endIndex = qrData.indexOf(end, startIndex + start.length);

  return qrData.substring(startIndex + start.length, endIndex);
}