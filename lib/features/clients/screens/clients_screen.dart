import 'package:flutter/material.dart';
import 'package:part_catalog/features/clients/models/client.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';
import 'package:part_catalog/features/clients/services/client_service.dart';
import 'package:get_it/get_it.dart';

/// {@template clients_screen}
/// Экран для отображения и управления списком клиентов.
/// {@endtemplate}
class ClientsScreen extends StatefulWidget {
  /// {@macro clients_screen}
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientService _clientService = GetIt.instance<ClientService>();
  List<Client> _clients = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await _clientService.getClients();
    setState(() {
      _clients = clients;
    });
  }

  Future<void> _addClient() async {
    final newClient = await _showClientDialog(context);
    if (newClient != null) {
      _clientService.addClient(newClient);
      _loadClients();
    }
  }

  Future<void> _editClient(Client client) async {
    final updatedClient = await _showClientDialog(context, client: client);
    if (updatedClient != null) {
      _clientService.updateClient(updatedClient);
      _loadClients();
    }
  }

  Future<void> _deleteClient(String clientId) async {
    final confirmed = await _showConfirmationDialog(context, 'Delete Client?',
        'Are you sure you want to delete this client?');
    if (confirmed == true) {
      _clientService.deleteClient(clientId);
      _loadClients();
    }
  }

  Future<Client?> _showClientDialog(BuildContext context,
      {Client? client}) async {
    final formKey = GlobalKey<FormState>();
    String? id = client?.id;
    ClientType? type = client?.type;
    String? name = client?.name;
    String? contactInfo = client?.contactInfo;
    String? additionalInfo = client?.additionalInfo;

    return showDialog<Client>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Add StatefulBuilder
          builder: (BuildContext context, StateSetter setState) {
            // Add StateSetter
            return AlertDialog(
              title: Text(client == null ? 'Add Client' : 'Edit Client'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a name'
                            : null,
                        onChanged: (value) => name = value,
                      ),
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          hintText: 'Choose a client type',
                        ),
                        child: DropdownButton<ClientType>(
                          value: type,
                          isExpanded: true,
                          onChanged: (ClientType? newValue) {
                            setState(() {
                              // Use local setState
                              type = newValue;
                            });
                          },
                          items: ClientType.values
                              .map<DropdownMenuItem<ClientType>>(
                                  (ClientType value) {
                            return DropdownMenuItem<ClientType>(
                              value: value,
                              child: Text(value.displayName),
                            );
                          }).toList(),
                        ),
                      ),
                      TextFormField(
                        initialValue: contactInfo,
                        decoration: const InputDecoration(
                          labelText: 'Contact Info',
                        ),
                        onChanged: (value) => contactInfo = value,
                      ),
                      TextFormField(
                        initialValue: additionalInfo,
                        decoration: const InputDecoration(
                          labelText: 'Additional Info',
                        ),
                        onChanged: (value) => additionalInfo = value,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (type == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select a client type')),
                        );
                        return;
                      }
                      final newClient = Client(
                        id: id ?? UniqueKey().toString(),
                        type: type!,
                        name: name ?? '',
                        contactInfo: contactInfo ?? '',
                        additionalInfo: additionalInfo,
                      );
                      Navigator.pop(context, newClient);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
      ),
      body: ListView.builder(
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          final client = _clients[index];
          return Dismissible(
            key: Key(client.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteClient(client.id);
            },
            confirmDismiss: (direction) async {
              return _showConfirmationDialog(context, 'Delete Client?',
                  'Are you sure you want to delete this client?');
            },
            child: ListTile(
              title: Text(client.name),
              subtitle: Text(client.contactInfo),
              onTap: () {
                _editClient(client);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addClient();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
