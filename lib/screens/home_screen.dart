import 'package:flutter/material.dart';
import '../data/item_repository.dart';
import '../models/item.dart';
import '../routes/app_routes.dart';
import '../widgets/state_views.dart';

enum ViewStatus { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = ItemRepository();
  ViewStatus _status = ViewStatus.loading;
  List<Item> _items = [];
  String _errorMessage = '';
  final bool _simulateError = false;// ubah ke true untuk menguji error state

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_status != ViewStatus.loading) {
      setState(() => _status = ViewStatus.loading);
    }
    try {
      final items = await _repository.fetchItems(simulateError: _simulateError);
      if (!mounted) return;
      setState(() {
        _items = items;
        _status = ViewStatus.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _status = ViewStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
  appBar: AppBar(
    title: const Text('Home'),
    actions: [
      IconButton(
        tooltip: 'Alamat Favorit',
        icon: const Icon(Icons.location_on_outlined),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.alamat);
        },
      ),
    ],
  ),

      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return switch (_status) {
      ViewStatus.loading => const LoadingView(),
      ViewStatus.error => ErrorView(message: _errorMessage, onRetry: _loadItems),
      ViewStatus.success => _buildList(),
    };
  }

  Widget _buildList() {
    if (_items.isEmpty) {
      return const EmptyView(message: 'Belum ada data.');
    }
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.detail,
            arguments: item,
          ),
        );
      },
    );
  }
}