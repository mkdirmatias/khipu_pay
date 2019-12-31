import 'package:flutter/material.dart';

import 'package:khipu_pay/khipu_pay.dart';
import 'package:khipu_pay/khipu_payment_status.dart';
import 'package:khipu_pay/khipu_payment.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String paymentId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('KhipuPay Plugin'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.blueAccent,
                child: Text(
                  'Obtener id de pago',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  String idPayment = await KhipuPayment().getPaymentId(
                    id: "257939",
                    secret: "0ce6fdb700b7fe668cfde33d0311d87196f22f27",
                    subject: "Campeonato 1",
                    amount: "1000",
                    currency: "CLP",
                    email: "juanvergara34@gmail.com",
                  );

                  print('El id de pago es: $idPayment');

                  setState(() {
                    paymentId = idPayment;
                  });
                },
              ),
              MaterialButton(
                color: Colors.blueAccent,
                child: Text(
                  'Realizar pago para id: $paymentId',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  String statusProcess =
                      await KhipuPay.paymentProcess(paymentId: paymentId);

                  print("El estado del pago es $statusProcess");
                },
              ),
              MaterialButton(
                color: Colors.green,
                child: Text(
                  'Ver Estado del Pago: $paymentId',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  String statusPayment = await KhipuPaymentStatus().status(
                    transactionCode: paymentId,
                    id: "257939",
                    secret: "0ce6fdb700b7fe668cfde33d0311d87196f22f27",
                  );

                  print('El status del pago es: $statusPayment');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
