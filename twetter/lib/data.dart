import 'package:uuid/uuid.dart';

import './models/customer.dart';
import './models/order.dart';
import './models/piece.dart';

class Data {
  static List<Customer> customers = [
    Customer(
      id: Uuid().v4(),
      name: 'John Doe',
      contactNo: '1234567890',
    ),
    Customer(
      id: Uuid().v4(),
      contactNo: '1234567890',
      name: 'Jane Smith',
    ),
    Customer(
      id: Uuid().v4(),
      contactNo: '1234567890',
      name: 'Alice Johnson',
    ),
  ];

  static List<Order> orders = [
    Order(
      piece: 'P001',
      sizesQuantityMap: {
        '34': 2,
      },
      date: DateTime.now(),
      customerName: 'John Doe',
      totalPayment: 200.0,
      paymentDone: 150.0,
      paymentDue: 50.0,
      customerId: 'customer_id_1',
    ),
    Order(
      piece: 'P002',
      sizesQuantityMap: {
        '34': 1,
      },
      date: DateTime.now(),
      customerName: 'John Doe',
      totalPayment: 100.0,
      paymentDone: 100.0,
      paymentDue: 0.0,
      customerId: 'customer_id_1',
    ),
    Order(
      piece: 'P003',
      sizesQuantityMap: {
        '34': 3,
      },
      date: DateTime.now(),
      customerName: 'Jane Smith',
      totalPayment: 300.0,
      paymentDone: 250.0,
      paymentDue: 50.0,
      customerId: 'customer_id_2',
    ),
    Order(
      piece: 'P004',
      sizesQuantityMap: {
        '34': 4,
      },
      date: DateTime.now(),
      customerName: 'Alice Johnson',
      totalPayment: 400.0,
      paymentDone: 400.0,
      paymentDue: 0.0,
      customerId: 'customer_id_3',
    ),
  ];

  static List<Piece> pieces = [
    Piece(
      pieceNumber: 'P001',
      sizesQuantityMap: {
        '30': 15,
        '36': 20,
        '40': 25,
      },
    ),
    Piece(
      pieceNumber: 'P002',
      sizesQuantityMap: {
        '30': 10,
        '36': 25,
        '40': 30,
      },
    ),
    Piece(
      pieceNumber: 'P003',
      sizesQuantityMap: {
        '30': 20,
        '36': 15,
        '40': 35,
      },
    ),
    Piece(
      pieceNumber: 'P004',
      sizesQuantityMap: {
        '30': 25,
        '36': 30,
        '40': 40,
      },
    ),
    Piece(
      pieceNumber: 'P005',
      sizesQuantityMap: {
        '30': 30,
        '36': 35,
        '40': 45,
      },
    ),
    Piece(
      pieceNumber: 'P006',
      sizesQuantityMap: {
        '30': 35,
        '36': 40,
        '40': 50,
      },
    ),
    Piece(
      pieceNumber: 'P007',
      sizesQuantityMap: {
        '30': 40,
        '36': 45,
        '40': 55,
      },
    ),
    Piece(
      pieceNumber: 'P008',
      sizesQuantityMap: {
        '30': 45,
        '36': 50,
        '40': 60,
      },
    ),
    Piece(
      pieceNumber: 'P009',
      sizesQuantityMap: {
        '30': 50,
        '36': 55,
        '40': 65,
      },
    ),
    Piece(
      pieceNumber: 'P010',
      sizesQuantityMap: {
        '30': 55,
        '36': 60,
        '40': 70,
      },
    ),
  ];
}
