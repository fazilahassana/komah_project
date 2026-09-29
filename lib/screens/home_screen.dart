import 'package:flutter/material.dart';

import '../data/item_repository.dart';
import '../models/item.dart';
import '../routes/app_routes.dart';
import '../widgets/state_views.dart';

enum ViewStatus {
  loading,
  success,
  error,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemRepository _repository = ItemRepository();

  ViewStatus _status = ViewStatus.loading;

  List<Item> _items = [];

  String _errorMessage = '';

  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_status != ViewStatus.loading) {
      setState(() {
        _status = ViewStatus.loading;
      });
    }

    try {
      final List<Item> items = await _repository.fetchItems(
        simulateError: _simulateError,
      );

      if (!mounted) return;

      setState(() {
        _items = items;
        _status = ViewStatus.success;
        _errorMessage = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
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
          // Temporary: tombol untuk menguji halaman 404.
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/tidak-ada',
              );
            },
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case ViewStatus.loading:
        return const LoadingView();

      case ViewStatus.error:
        return ErrorView(
          message: _errorMessage,
          onRetry: _loadItems,
        );

      case ViewStatus.success:
        return _buildList();
    }
  }

  Widget _buildList() {
    if (_items.isEmpty) {
      return const EmptyView(
        message: 'Belum ada data.',
      );
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final Item item = _items[index];

        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: item,
            );
          },
        );
      },
    );
  }
}