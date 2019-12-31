# KhipuPay

A Flutter plugin that uses Khipu libraries to process payments in applications developed with
Flutter

This plugin also has support to create payment identifiers and validate payment status.

## AndroidManifest changes

To use the plugin on Android, you must modify the android: name of application, since you need to
have an instance of KhenshinInterface

```xml
<application
    android:name="io.flutter.app.FlutterApplication"
```

to

```xml
<application
    android:name="com.duckytie.khipupay.KhipuApplication"
```

This change will not change the normal functionality of your application, since the KhipuApplication
class also extends from FlutterApplication

In iOS you should not make any special settings.

## How to use the plugin

1. To generate a payment identifier, you must submit the fields required by Khipu,
the email field is not mandatory.

```dart
import 'package:khipu_pay/khipu_payment.dart';

String idPayment = await KhipuPayment().getPaymentId(
    id: "id_cobrador", //Information delivered by khipu
    secret: "secret", //Information delivered by khipu
    subject: "asunto del pago",
    amount: "1000", //This value must be greater than 0
    currency: "CLP",
    email: "correo@correo.cl",
);
```

2. Once the payment identifier is generated, you can process the payment by Khipu, it will
return a "SUCCESS" if the transaction was correct or a "FAILURE" if the transaction fails
or is canceled.

```dart
import 'package:khipu_pay/khipu_pay.dart';

String statusProcess = await KhipuPay.paymentProcess(paymentId: idPayment);
```

3. Before or after making the payment, you can check the status of the generator identifier.

```dart
import 'package:khipu_pay/khipu_payment_status.dart';

String statusPayment = await KhipuPaymentStatus().status(
    transactionCode: idPayment,
    id: "id_cobrador", //Information delivered by khipu
    secret: "secret", //Information delivered by khipu
);
```

Remember that Khipu provides id and secret for development and production environment, you must
change these fields, depending on the environment in which your application is located, so that
you can process your payments correctly.