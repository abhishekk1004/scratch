import 'package:scratch/view/add_product_screen.dart';
import 'package:scratch/viewmodel/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().getAllProduct();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageProductScreen()),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add Products"),
      ),
      body: vm.loading
          ? CircularProgressIndicator()
          : vm.allProducts == null
          ? Text("No products")
          : ListView.builder(
        itemCount: vm.allProducts!.length,
        itemBuilder: (context, index) {
          final data = vm.allProducts![index];
          return Column(
            children: [
              Text(data.name!),
              Text(data.price!.toString()),
              Text(data.description!),
            ],
          );
        },
      ),
    );
  }
}