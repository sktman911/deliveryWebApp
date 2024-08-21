import 'package:delivery/Entities/DonHang.dart';
import 'package:flutter/material.dart';
import 'package:vertical_stepper/vertical_stepper.dart';
import 'package:vertical_stepper/vertical_stepper.dart' as step;
import 'package:delivery/Entities/ApiHelper.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Detail extends StatefulWidget {
  static DonHang? donHang;
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

// Xác nhận lấy hàng
  Future<int> _xacNhanDaLayHang(id) async {
    final response = await http.post(
      Uri.parse('${ApiHelper.ip}/nvgh/xacnhanlayhang/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, int>{
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      dynamic result = jsonDecode(response.body);
      return result["Result"];
    } else {
      throw Exception('Server không phản hồi T_T');
    }
  }

  // Xác nhận đang giao hàng
  Future<int> _xacNhanDangGiaoHang(id) async {
    final response = await http.post(
      Uri.parse('${ApiHelper.ip}/nvgh/xacnhandanggiaohang/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, int>{
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      dynamic result = jsonDecode(response.body);
      return result["Result"];
    } else {
      throw Exception('Server không phản hồi T_T');
    }
  }

  // Xác nhận đã giao hàng
  Future<int> _xacNhanDaGiaoHang(id) async {
    final response = await http.post(
      Uri.parse('${ApiHelper.ip}/nvgh/xacnhandagiaohang/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, int>{
        'id': id,
      }),
    );
    if (response.statusCode == 200) {
      dynamic result = jsonDecode(response.body);
      return result["Result"];
    } else {
      throw Exception('Server không phản hồi T_T');
    }
  }

class _DetailState extends State<Detail> with TickerProviderStateMixin {
  List<step.Step> steps = [
    const step.Step(
        shimmer: false,
        title: "Nhận hàng về kho",
        iconStyle: Colors.green,
        content: Align(
          alignment: Alignment.centerLeft,
          child: Text("12:30:40 02/05/2023"),
        )),
    const step.Step(
        shimmer: false,
        title: "Phân phối cho nhân viên giao hàng",
        iconStyle: Colors.green,
        content: Align(
          alignment: Alignment.centerLeft,
          child: Text("12:30:40 02/05/2023"),
        )),
    const step.Step(
        shimmer: false,
        title: "Nhân viên đã lấy hàng",
        iconStyle: Colors.green,
        content: Align(
          alignment: Alignment.centerLeft,
          child: Text("12:30:40 02/05/2023"),
        )),
    const step.Step(
        shimmer: false,
        title: "Nhân viên đang giao",
        iconStyle: Colors.green,
        content: Align(
          alignment: Alignment.centerLeft,
          child: Text("12:30:40 02/05/2023"),
        )),
    const step.Step(
        shimmer: false,
        title: "Nhân viên đã giao",
        iconStyle: Colors.red,
        content: Align(
          alignment: Alignment.centerLeft,
          child: Text("12:30:40 02/05/2023"),
        )),
  ];

  // Hàm xử lý sự kiện khi nhấn nút Xác nhận lấy hàng
    void _handleXacNhanLayHang() async {
      final id = Detail.donHang?.maDonHang; // Lấy id của đơn hàng từ biến static
      if (id != null) {
        if (Detail.donHang!.maTrangThai == 4) {
          try {
            int result = await _xacNhanDaLayHang(id);
            if (result != -1) {
              Detail.donHang!.tenTrangThai = 'Đã lấy hàng';
              Detail.donHang!.maTrangThai = 5;
              setState(() {});
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Lỗi'),
                    content: Text('Lấy hàng không thành công.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content: Text('Đã xảy ra lỗi trong quá trình xác nhận lấy hàng.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Đóng'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }

    // Hàm xử lý sự kiện khi nhấn nút Xác nhận đang giao hàng
    void _handleXacNhanDangGiaoHang() async{
      final id = Detail.donHang?.maDonHang; // Lấy id của đơn hàng từ biến static
      if (id != null) {
        if (Detail.donHang!.maTrangThai == 5) {
          try {
            int result = await _xacNhanDangGiaoHang(id);
            if (result != -1) {
              Detail.donHang!.tenTrangThai = 'Đang giao hàng';
              Detail.donHang!.maTrangThai = 6;
              setState(() {});
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Lỗi'),
                    content: Text('Xác nhận Đang giao hàng không thành công.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content: Text('Đã xảy ra lỗi trong quá trình xác nhận Đang giao hàng.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Đóng'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }

    // Hàm xử lý sự kiện khi nhấn nút Xác nhận đã giao hàng
    void _handleXacNhanDaGiaoHang() async{
      final id = Detail.donHang?.maDonHang; // Lấy id của đơn hàng từ biến static
      if (id != null) {
      if (Detail.donHang!.maTrangThai == 6) {
          try {
            int result = await _xacNhanDaGiaoHang(id);
            if (result != -1) {
              Detail.donHang!.tenTrangThai = 'Đã giao hàng';
              Detail.donHang!.maTrangThai = 7;
              setState(() {});
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Lỗi'),
                    content: Text('Xác nhận Đã giao hàng không thành công.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content: Text('Đã xảy ra lỗi trong quá trình xác nhận Đã giao hàng.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Đóng'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    if (Detail.donHang != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn hàng: ${Detail.donHang!.maDonHang}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Trạng thái: ${Detail.donHang!.tenTrangThai}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Từ: ${Detail.donHang!.nguoiGui}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Địa chỉ: ${Detail.donHang!.tu}',
                    ),
                    Text(
                      'Số điện thoại: ${Detail.donHang!.sdtNguoiGui}',
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đến: ${Detail.donHang!.nguoiNhan}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Địa chỉ: ${Detail.donHang!.diaChiNguoiNhan}, ${Detail.donHang!.diaChiPhuong}, ${Detail.donHang!.diaChiQuan}, ${Detail.donHang!.diaChiThanhPho}',
                    ),
                    Text(
                      'Số điện thoại: ${Detail.donHang!.sdtNguoiNhan}',
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ghi Chú:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${Detail.donHang!.ghiChu}')
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _handleXacNhanLayHang,
                  child: Text('Đã lấy hàng', style: TextStyle(fontSize: 15)),
                  
                ),
                ElevatedButton(
                  onPressed: _handleXacNhanDangGiaoHang,
                  child: Text('Đang giao hàng', style: TextStyle(fontSize: 15)),
                ),
                ElevatedButton(
                  onPressed: _handleXacNhanDaGiaoHang,
                  child: Text('Đã giao hàng', style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                bottom: 4,
                top: 8,
              ),
              child: Text(
                "Trạng thái",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            VerticalStepper(
              steps: steps,
              dashLength: 2,
            )
          ],
        ),
      );
    } else {
      return const Center(
        child: Text("Rỗng"),
      );
    }
  }
}
