abstract class PaymentMethod {
  Map<String, dynamic> tojson();
}

class BankTranfer extends PaymentMethod {
  @override
  Map<String, dynamic> tojson() {
    // TODO: implement tojson
    throw UnimplementedError();
  }
}
