import 'package:flutter/material.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_item.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';

class ArmtekInfoMasterDetail extends StatefulWidget {
  final UserStructureRoot structure;
  
  const ArmtekInfoMasterDetail({
    super.key,
    required this.structure,
  });

  @override
  State<ArmtekInfoMasterDetail> createState() => _ArmtekInfoMasterDetailState();
}

class _ArmtekInfoMasterDetailState extends State<ArmtekInfoMasterDetail> {
  // Выбранный элемент для отображения деталей
  Object? _selectedItem;
  String _selectedItemType = '';
  
  @override
  void initState() {
    super.initState();
    // По умолчанию показываем основную организацию
    _selectedItem = widget.structure;
    _selectedItemType = 'root';
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    // Более строгие условия для desktop layout - нужно минимум 850px
    final isLargeScreen = screenWidth >= 850;
    
    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Master panel - навигационное дерево с адаптивной шириной
          SizedBox(
            width: screenWidth * 0.3,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book, 
                          color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Навигация',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(child: _buildNavigationTree(t)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Detail panel - детальная информация
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    child: Row(
                      children: [
                        Icon(_getDetailIcon(), 
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getDetailTitle(),
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(child: _buildDetailView(t)),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // Для мобильных устройств - полноэкранное отображение
      return _buildMobileView(t);
    }
  }
  
  Widget _buildNavigationTree(Translations t) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        // Основная организация
        _buildTreeItem(
          icon: Icons.business,
          title: widget.structure.sname ?? 'Основная организация',
          subtitle: 'KUNAG: ${widget.structure.kunag}',
          isSelected: _selectedItemType == 'root',
          onTap: () {
            setState(() {
              _selectedItem = widget.structure;
              _selectedItemType = 'root';
            });
          },
        ),
        
        // Плательщики
        if (widget.structure.rgTab != null && widget.structure.rgTab!.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSectionHeader('Плательщики'),
          ...widget.structure.rgTab!.map((rgItem) => 
            _buildExpandableTreeItem(
              icon: Icons.account_balance,
              title: rgItem.sname ?? 'Без названия',
              subtitle: 'KUNNR: ${rgItem.kunnr}',
              isDefault: rgItem.defaultFlag ?? false,
              isSelected: _selectedItem == rgItem && _selectedItemType == 'payer',
              onTap: () {
                setState(() {
                  _selectedItem = rgItem;
                  _selectedItemType = 'payer';
                });
              },
              children: _buildPayerSubItems(rgItem, t),
            ),
          ),
        ],
        
        // Контакты организации
        if (widget.structure.contactTab != null && widget.structure.contactTab!.isNotEmpty)
          _buildTreeItem(
            icon: Icons.contacts,
            title: 'Контакты организации',
            subtitle: '${widget.structure.contactTab!.length} контактов',
            isSelected: _selectedItemType == 'root_contacts',
            onTap: () {
              setState(() {
                _selectedItem = widget.structure.contactTab;
                _selectedItemType = 'root_contacts';
              });
            },
          ),
          
        // Договоры организации
        if (widget.structure.dogovorTab != null && widget.structure.dogovorTab!.isNotEmpty)
          _buildTreeItem(
            icon: Icons.description,
            title: 'Договоры организации',
            subtitle: '${widget.structure.dogovorTab!.length} договоров',
            isSelected: _selectedItemType == 'root_contracts',
            onTap: () {
              setState(() {
                _selectedItem = widget.structure.dogovorTab;
                _selectedItemType = 'root_contracts';
              });
            },
          ),
      ],
    );
  }
  
  List<Widget> _buildPayerSubItems(UserStructureItem payer, Translations t) {
    final items = <Widget>[];
    
    // Грузополучатели
    if (payer.weTab != null && payer.weTab!.isNotEmpty) {
      items.add(_buildTreeSubItem(
        icon: Icons.local_shipping,
        title: 'Грузополучатели',
        count: payer.weTab!.length,
        onTap: () {
          setState(() {
            _selectedItem = payer.weTab;
            _selectedItemType = 'we_tab';
          });
        },
      ));
    }
    
    // Адреса доставки
    if (payer.zaTab != null && payer.zaTab!.isNotEmpty) {
      items.add(_buildTreeSubItem(
        icon: Icons.location_on,
        title: 'Адреса доставки',
        count: payer.zaTab!.length,
        onTap: () {
          setState(() {
            _selectedItem = payer.zaTab;
            _selectedItemType = 'za_tab';
          });
        },
      ));
    }
    
    // Условия поставки
    if (payer.exwTab != null && payer.exwTab!.isNotEmpty) {
      items.add(_buildTreeSubItem(
        icon: Icons.local_offer,
        title: 'Условия поставки',
        count: payer.exwTab!.length,
        onTap: () {
          setState(() {
            _selectedItem = payer.exwTab;
            _selectedItemType = 'exw_tab';
          });
        },
      ));
    }
    
    // Договоры плательщика
    if (payer.dogovorTab != null && payer.dogovorTab!.isNotEmpty) {
      items.add(_buildTreeSubItem(
        icon: Icons.article,
        title: 'Договоры',
        count: payer.dogovorTab!.length,
        onTap: () {
          setState(() {
            _selectedItem = payer.dogovorTab;
            _selectedItemType = 'payer_contracts';
          });
        },
      ));
    }
    
    // Контакты плательщика
    if (payer.contactTab != null && payer.contactTab!.isNotEmpty) {
      items.add(_buildTreeSubItem(
        icon: Icons.person,
        title: 'Контакты',
        count: payer.contactTab!.length,
        onTap: () {
          setState(() {
            _selectedItem = payer.contactTab;
            _selectedItemType = 'payer_contacts';
          });
        },
      ));
    }
    
    return items;
  }
  
  Widget _buildTreeItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
        selected: isSelected,
      ),
    );
  }
  
  Widget _buildExpandableTreeItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
    required bool isSelected,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(
          isDefault ? '$title (по умолч.)' : title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle, overflow: TextOverflow.ellipsis),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        onExpansionChanged: (_) => onTap(),
        children: children.length > 5 
          ? children.take(5).toList() + [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('...и еще', style: TextStyle(fontStyle: FontStyle.italic)),
              )
            ]
          : children,
      ),
    );
  }
  
  Widget _buildTreeSubItem({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        leading: Icon(icon, size: 20),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
        ),
        trailing: Chip(
          label: Text('$count'),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
  
  Widget _buildDetailView(Translations t) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200), // Ограничиваем максимальную ширину
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildDetailContent(t),
      ),
    );
  }
  
  Widget _buildDetailContent(Translations t) {
    switch (_selectedItemType) {
      case 'root':
        return _buildRootDetail(t);
      case 'payer':
        return _buildPayerDetail(_selectedItem as UserStructureItem, t);
      case 'root_contacts':
      case 'payer_contacts':
        return _buildContactsTable(_selectedItem as List, t);
      case 'root_contracts':
      case 'payer_contracts':
        return _buildContractsTable(_selectedItem as List, t);
      case 'we_tab':
        return _buildWeTable(_selectedItem as List, t);
      case 'za_tab':
        return _buildAddressesTable(_selectedItem as List, t);
      case 'exw_tab':
        return _buildDeliveryTermsTable(_selectedItem as List, t);
      default:
        return const Center(child: Text('Выберите элемент для просмотра'));
    }
  }
  
  Widget _buildRootDetail(Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Основная информация
        Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, 
                      color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Основные данные',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _buildInfoRow('Код клиента (KUNAG)', widget.structure.kunag ?? '-'),
                    _buildInfoRow('Сбытовая организация (VKORG)', widget.structure.vkorg ?? '-'),
                    _buildInfoRow('Краткое наименование', widget.structure.sname ?? '-'),
                    _buildInfoRow('Полное наименование', widget.structure.fname ?? '-'),
                    _buildInfoRow('Адрес', widget.structure.adress ?? '-'),
                    _buildInfoRow('Телефон', widget.structure.phone ?? '-'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Заголовок для статистики
        Text(
          'Сводная информация',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Сводная информация в виде сетки
        Row(
          children: [
            Expanded(
              child: _buildCompactInfoCard(
                icon: Icons.account_balance,
                title: 'Плательщики',
                count: widget.structure.rgTab?.length ?? 0,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCompactInfoCard(
                icon: Icons.contacts,
                title: 'Контакты',
                count: widget.structure.contactTab?.length ?? 0,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCompactInfoCard(
                icon: Icons.description,
                title: 'Договоры',
                count: widget.structure.dogovorTab?.length ?? 0,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPayerDetail(UserStructureItem payer, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.account_balance, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payer.sname ?? 'Плательщик',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (payer.defaultFlag ?? false)
                    const Chip(
                      label: Text('Плательщик по умолчанию'),
                      backgroundColor: Colors.green,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                _buildInfoRow('Код плательщика (KUNNR)', payer.kunnr ?? '-'),
                _buildInfoRow('Краткое наименование', payer.sname ?? '-'),
                _buildInfoRow('Полное наименование', payer.fname ?? '-'),
                _buildInfoRow('Адрес', payer.adress ?? '-'),
                _buildInfoRow('Телефон', payer.phone ?? '-'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Сводная информация о плательщике в виде сетки
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _buildCompactInfoCard(
                icon: Icons.local_shipping,
                title: 'Грузополучатели',
                count: payer.weTab?.length ?? 0,
                color: Colors.purple,
              ),
              _buildCompactInfoCard(
                icon: Icons.location_on,
                title: 'Адреса доставки',
                count: payer.zaTab?.length ?? 0,
                color: Colors.red,
              ),
              _buildCompactInfoCard(
                icon: Icons.local_offer,
                title: 'Условия поставки',
                count: payer.exwTab?.length ?? 0,
                color: Colors.teal,
              ),
              _buildCompactInfoCard(
                icon: Icons.article,
                title: 'Договоры',
                count: payer.dogovorTab?.length ?? 0,
                color: Colors.orange,
              ),
              _buildCompactInfoCard(
                icon: Icons.person,
                title: 'Контакты',
                count: payer.contactTab?.length ?? 0,
                color: Colors.green,
              ),
            ];
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // Максимальная ширина карточки
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5, // Оптимальное соотношение для текста
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) => cards[index],
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildContactsTable(List contacts, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.contacts, size: 32),
            const SizedBox(width: 12),
            Text(
              'Контакты',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ФИО')),
                DataColumn(label: Text('Телефон')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('По умолчанию')),
                DataColumn(label: Text('ID')),
              ],
              rows: contacts.map((contact) {
                final fullName = '${contact.lname ?? ""} ${contact.fname ?? ""} ${contact.mname ?? ""}'.trim();
                return DataRow(cells: [
                  DataCell(Text(fullName.isNotEmpty ? fullName : '-')),
                  DataCell(Text(contact.phone ?? '-')),
                  DataCell(Text(contact.email ?? '-')),
                  DataCell(
                    (contact.defaultFlag ?? false)
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.grey),
                  ),
                  DataCell(Text(contact.parnr ?? '-')),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildContractsTable(List contracts, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description, size: 32),
            const SizedBox(width: 12),
            Text(
              'Договоры',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Номер')),
                DataColumn(label: Text('Название')),
                DataColumn(label: Text('Кредитный лимит')),
                DataColumn(label: Text('Валюта')),
                DataColumn(label: Text('Дата окончания')),
                DataColumn(label: Text('По умолчанию')),
              ],
              rows: contracts.map((contract) {
                return DataRow(cells: [
                  DataCell(Text(contract.vbeln ?? '-')),
                  DataCell(Text(contract.bstkd ?? '-')),
                  DataCell(Text(contract.klimk ?? '0.00')),
                  DataCell(Text(contract.waers ?? '-')),
                  DataCell(Text(contract.datbi ?? '-')),
                  DataCell(
                    (contract.defaultFlag ?? false)
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.grey),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  
  
  Widget _buildAddressesTable(List addresses, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, size: 32),
            const SizedBox(width: 12),
            Text(
              'Адреса доставки',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Код')),
                DataColumn(label: Text('Наименование')),
                DataColumn(label: Text('Адрес')),
                DataColumn(label: Text('Телефон')),
                DataColumn(label: Text('По умолчанию')),
              ],
              rows: addresses.map((address) {
                return DataRow(cells: [
                  DataCell(Text(address.kunnr ?? '-')),
                  DataCell(Text(address.sname ?? '-')),
                  DataCell(Text(address.adress ?? '-')),
                  DataCell(Text(address.phone ?? '-')),
                  DataCell(
                    (address.defaultFlag ?? false)
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.grey),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDeliveryTermsTable(List terms, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer, size: 32),
            const SizedBox(width: 12),
            Text(
              'Условия поставки',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Код')),
              DataColumn(label: Text('Условие')),
            ],
            rows: terms.map((term) {
              return DataRow(cells: [
                DataCell(Text(term.id ?? '-')),
                DataCell(Text(term.name ?? '-')),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildWeTable(List weItems, Translations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_shipping, size: 32),
            const SizedBox(width: 12),
            Text(
              'Грузополучатели',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Код')),
                DataColumn(label: Text('Склад')),
                DataColumn(label: Text('Наименование')),
                DataColumn(label: Text('Адрес')),
                DataColumn(label: Text('Телефон')),
                DataColumn(label: Text('По умолчанию')),
              ],
              rows: weItems.map((weItem) {
                return DataRow(cells: [
                  DataCell(Text(weItem.kunnr ?? '-')),
                  DataCell(Text(weItem.werks ?? '-')),
                  DataCell(Text(weItem.sname ?? '-')),
                  DataCell(Text(weItem.adress ?? '-')),
                  DataCell(Text(weItem.phone ?? '-')),
                  DataCell(
                    (weItem.defaultFlag ?? false)
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.grey),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  
  
  TableRow _buildInfoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
  
  Widget _buildMobileView(Translations t) {
    // Для мобильных устройств - упрощенная навигация
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildRootDetail(t),
          // Можно добавить навигацию через ExpansionTiles
        ],
      ),
    );
  }
  
  Widget _buildCompactInfoCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {}, // Можно добавить функциональность клика в будущем
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Очень агрессивные отступы для узких экранов  
            final horizontalPadding = constraints.maxWidth < 50 ? 2.0 : (constraints.maxWidth < 100 ? 4.0 : 12.0);
            final verticalPadding = constraints.maxWidth < 50 ? 2.0 : (constraints.maxWidth < 100 ? 3.0 : 8.0);
            
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, 
                vertical: verticalPadding
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                  children: [
                    // Гибкая иконка - может исчезнуть на очень узких экранах
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Показываем иконку только если достаточно места (минимум 80px)
                        if (constraints.maxWidth > 80) {
                          final iconPadding = constraints.maxWidth < 120 ? 3.0 : 6.0;
                          final iconSize = constraints.maxWidth < 120 ? 12.0 : 16.0;
                          return Container(
                            padding: EdgeInsets.all(iconPadding),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: color, size: iconSize),
                          );
                        } else {
                          return const SizedBox.shrink(); // Скрываем иконку на узких экранах
                        }
                      },
                    ),
                    // Адаптивный отступ
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 80) {
                          return SizedBox(width: constraints.maxWidth < 120 ? 4 : 8);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Text(
                            '$count',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith( // Еще меньше для компактности
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            );
          },
        ),
      ),
    );
  }
  
  IconData _getDetailIcon() {
    switch (_selectedItemType) {
      case 'root':
        return Icons.business;
      case 'payer':
        return Icons.account_balance;
      case 'root_contacts':
      case 'payer_contacts':
        return Icons.contacts;
      case 'root_contracts':
      case 'payer_contracts':
        return Icons.description;
      case 'we_tab':
        return Icons.local_shipping;
      case 'za_tab':
        return Icons.location_on;
      case 'exw_tab':
        return Icons.local_offer;
      default:
        return Icons.info;
    }
  }
  
  String _getDetailTitle() {
    switch (_selectedItemType) {
      case 'root':
        return 'Основная организация';
      case 'payer':
        return 'Информация о плательщике';
      case 'root_contacts':
      case 'payer_contacts':
        return 'Контакты';
      case 'root_contracts':
      case 'payer_contracts':
        return 'Договоры';
      case 'we_tab':
        return 'Грузополучатели';
      case 'za_tab':
        return 'Адреса доставки';
      case 'exw_tab':
        return 'Условия поставки';
      default:
        return 'Детальная информация';
    }
  }
}