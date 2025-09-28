import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:part_catalog/core/ui/index.dart';

/// Экран создания/редактирования заказа
class OrderFormScreen extends ConsumerStatefulWidget {
  final String? orderUuid;

  const OrderFormScreen({
    super.key,
    this.orderUuid,
  });

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orderNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedClientId;
  String? _selectedVehicleId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.orderUuid != null) {
      _loadOrder();
    }
  }

  @override
  void dispose() {
    _orderNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadOrder() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Load order data
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки заказа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.orderUuid != null;

    return FormScreenScaffold(
      title: isEditing ? 'Редактирование заказа' : 'Новый заказ',
      isLoading: _isLoading,
      formKey: _formKey,
      cancelText: 'Отмена',
      onCancel: () => context.pop(),
      submitText: isEditing ? 'Сохранить' : 'Создать',
      onSubmit: _saveOrder,
      children: _isLoading
          ? [const Center(child: CircularProgressIndicator())]
          : [_buildForm()],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FormSection(
            title: 'Основная информация',
            children: [
              TextInput(
                controller: _orderNumberController,
                label: 'Номер заказа',
                hint: 'Введите номер заказа',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Номер заказа обязателен';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              DropdownInput<String>(
                label: 'Клиент',
                hint: 'Выберите клиента',
                value: _selectedClientId,
                items: const [], // TODO: Load clients
                onChanged: (value) => setState(() => _selectedClientId = value),
                validator: (value) {
                  if (value == null) {
                    return 'Выберите клиента';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              DropdownInput<String>(
                label: 'Автомобиль',
                hint: 'Выберите автомобиль',
                value: _selectedVehicleId,
                items: const [], // TODO: Load vehicles for selected client
                onChanged: (value) => setState(() => _selectedVehicleId = value),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          FormSection(
            title: 'Описание работ',
            children: [
              TextInput(
                controller: _descriptionController,
                label: 'Описание',
                hint: 'Опишите выполняемые работы...',
                maxLines: 5,
                minLines: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement order saving
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          widget.orderUuid != null
            ? 'Заказ обновлен'
            : 'Заказ создан'
        )),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}