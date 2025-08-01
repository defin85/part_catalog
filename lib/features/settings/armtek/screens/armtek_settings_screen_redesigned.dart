import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/widgets/buttons.dart';
import 'package:part_catalog/core/widgets/loading_indicator.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/settings/armtek/notifiers/armtek_settings_notifier.dart';
import 'package:part_catalog/features/settings/armtek/state/armtek_settings_state.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';

class ArmtekSettingsScreenRedesigned extends ConsumerStatefulWidget {
  const ArmtekSettingsScreenRedesigned({super.key});

  @override
  ConsumerState<ArmtekSettingsScreenRedesigned> createState() =>
      _ArmtekSettingsScreenRedesignedState();
}

class _ArmtekSettingsScreenRedesignedState extends ConsumerState<ArmtekSettingsScreenRedesigned>
    with SingleTickerProviderStateMixin {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize with saved credentials
    final initialState = ref.read(armtekSettingsNotifierProvider);
    _loginController.text = initialState.loginInput;
    
    // Auto-switch to data tab if connected
    if (initialState.isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.animateTo(1);
      });
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(armtekSettingsNotifierProvider);
    final notifier = ref.read(armtekSettingsNotifierProvider.notifier);
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.armtekSettings.screenTitle),
        actions: [
          // Connection status indicator
          _buildConnectionStatus(state),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.vpn_key),
              text: 'Подключение',
            ),
            Tab(
              icon: const Icon(Icons.business),
              text: 'Данные организации',
              iconMargin: state.isConnected 
                ? null 
                : const EdgeInsets.only(bottom: 8),
            ),
            Tab(
              icon: const Icon(Icons.info_outline),
              text: 'О поставщике',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Connection Settings
          _buildConnectionTab(context, state, notifier, t),
          
          // Tab 2: Organization Data
          _buildOrganizationDataTab(context, state, notifier, t),
          
          // Tab 3: Supplier Info
          _buildSupplierInfoTab(context, t),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(ArmtekSettingsState state) {
    if (state.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: state.isConnected 
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: state.isConnected ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            state.isConnected ? Icons.check_circle : Icons.cancel,
            color: state.isConnected ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            state.isConnected ? 'Подключено' : 'Не подключено',
            style: TextStyle(
              color: state.isConnected ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionTab(
    BuildContext context,
    ArmtekSettingsState state,
    ArmtekSettingsNotifier notifier,
    Translations t,
  ) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => _buildConnectionForm(context, state, notifier, t, EdgeInsets.all(16)),
      medium: (_, __) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: _buildConnectionForm(context, state, notifier, t, EdgeInsets.zero),
        ),
      ),
      large: (_, __) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(32),
          child: _buildConnectionForm(context, state, notifier, t, EdgeInsets.zero),
        ),
      ),
    );
  }

  Widget _buildConnectionForm(
    BuildContext context,
    ArmtekSettingsState state,
    ArmtekSettingsNotifier notifier,
    Translations t,
    EdgeInsets padding,
  ) {
    return SingleChildScrollView(
      padding: padding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.vpn_key,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Учетные данные',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Login field
                    TextFormField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        labelText: t.settings.armtekSettings.loginLabel,
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        filled: true,
                      ),
                      onChanged: notifier.updateLogin,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.settings.armtekSettings.loginRequiredError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: t.settings.armtekSettings.passwordLabel,
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        filled: true,
                        helperText: state.isConnected 
                          ? 'Оставьте пустым для сохранения текущего пароля' 
                          : null,
                      ),
                      obscureText: true,
                      onChanged: notifier.updatePassword,
                    ),
                    
                    // Error message
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Success message
                    if (state.connectionStatusMessage != null && state.isConnected) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.connectionStatusMessage!,
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SecondaryButton(
                          onPressed: state.isLoading ? null : notifier.clearSettings,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.clear, size: 18),
                              const SizedBox(width: 8),
                              Text(t.core.resetButtonLabel),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        PrimaryButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (state.passwordInput.isEmpty && !state.isConnected) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(t.settings.armtekSettings.passwordRequiredError),
                                        ),
                                      );
                                      return;
                                    }
                                    notifier.checkAndSaveConnection();
                                  }
                                },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (state.isLoading)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                const Icon(Icons.save, size: 18),
                              const SizedBox(width: 8),
                              Text(t.settings.armtekSettings.checkAndSaveButton),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Connection info
            if (state.isConnected) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Соединение установлено',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Перейдите на вкладку "Данные организации" для просмотра информации',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => _tabController.animateTo(1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationDataTab(
    BuildContext context,
    ArmtekSettingsState state,
    ArmtekSettingsNotifier notifier,
    Translations t,
  ) {
    if (!state.isConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Не подключено к Armtek',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Настройте подключение на вкладке "Подключение"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Настроить подключение'),
              onPressed: () => _tabController.animateTo(0),
            ),
          ],
        ),
      );
    }

    if (state.isLoadingArmtekData) {
      return const Center(child: LoadingIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VKORG Selection
          if (state.userVkorgList != null && state.userVkorgList!.isNotEmpty) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business_center,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Выбор организации',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: state.selectedVkorg,
                      decoration: InputDecoration(
                        labelText: t.settings.armtekSettings.vkorgLabel,
                        border: const OutlineInputBorder(),
                        filled: true,
                      ),
                      items: state.userVkorgList!
                          .map((vkorg) => DropdownMenuItem<String>(
                                value: vkorg.vkorg,
                                child: Text('${vkorg.programName} (${vkorg.vkorg})'),
                              ))
                          .toList(),
                      onChanged: (value) => notifier.selectVkorg(value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Organization Data
          if (state.selectedVkorg != null && state.userInfo != null)
            _buildImprovedUserInfo(context, state.userInfo!, t),
        ],
      ),
    );
  }

  Widget _buildImprovedUserInfo(
    BuildContext context,
    UserInfoResponse userInfo,
    Translations t,
  ) {
    final structure = userInfo.structure;
    
    if (structure == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(t.settings.armtekSettings.userInfoUnavailable),
          ),
        ),
      );
    }

    // Full-screen data explorer without embedded master-detail
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Organization overview card
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            structure.sname ?? 'Организация',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'KUNAG: ${structure.kunag ?? '-'} | VKORG: ${structure.vkorg ?? '-'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (structure.adress != null || structure.phone != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  if (structure.adress != null)
                    _buildInfoItem(Icons.location_on, 'Адрес', structure.adress!),
                  if (structure.phone != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoItem(Icons.phone, 'Телефон', structure.phone!),
                  ],
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Statistics grid
        _buildStatisticsGrid(context, structure),
        const SizedBox(height: 24),

        // Data sections as expandable cards
        _buildDataSections(context, structure),
      ],
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, UserStructureRoot structure) {
    final stats = [
      _StatItem(
        icon: Icons.account_balance,
        label: 'Плательщики',
        count: structure.rgTab?.length ?? 0,
        color: Colors.blue,
      ),
      _StatItem(
        icon: Icons.contacts,
        label: 'Контакты',
        count: structure.contactTab?.length ?? 0,
        color: Colors.green,
      ),
      _StatItem(
        icon: Icons.description,
        label: 'Договоры',
        count: structure.dogovorTab?.length ?? 0,
        color: Colors.orange,
      ),
      _StatItem(
        icon: Icons.local_shipping,
        label: 'Всего адресов',
        count: _calculateTotalAddresses(structure),
        color: Colors.purple,
      ),
    ];

    return ResponsiveLayoutBuilder(
      small: (_, __) => _buildGridView(stats, 2),
      medium: (_, __) => _buildGridView(stats, 2),
      large: (_, __) => _buildGridView(stats, 4),
    );
  }

  Widget _buildGridView(List<_StatItem> stats, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 1,
          child: InkWell(
            onTap: () {}, // Can add navigation later
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: stat.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(stat.icon, color: stat.color, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${stat.count}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: stat.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.label,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataSections(BuildContext context, UserStructureRoot structure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Детальная информация',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        // Payers section
        if (structure.rgTab != null && structure.rgTab!.isNotEmpty)
          _buildExpandableSection(
            title: 'Плательщики',
            icon: Icons.account_balance,
            itemCount: structure.rgTab!.length,
            color: Colors.blue,
            children: structure.rgTab!.map((payer) => 
              _buildPayerCard(context, payer)
            ).toList(),
          ),
        
        // Contacts section
        if (structure.contactTab != null && structure.contactTab!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildExpandableSection(
            title: 'Контакты организации',
            icon: Icons.contacts,
            itemCount: structure.contactTab!.length,
            color: Colors.green,
            children: [_buildContactsList(structure.contactTab!)],
          ),
        ],
        
        // Contracts section
        if (structure.dogovorTab != null && structure.dogovorTab!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildExpandableSection(
            title: 'Договоры организации',
            icon: Icons.description,
            itemCount: structure.dogovorTab!.length,
            color: Colors.orange,
            children: [_buildContractsList(structure.dogovorTab!)],
          ),
        ],
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required int itemCount,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(title),
          trailing: Chip(
            label: Text('$itemCount'),
            backgroundColor: color.withValues(alpha: 0.1),
            labelStyle: TextStyle(color: color),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildPayerCard(BuildContext context, dynamic payer) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payer.sname ?? 'Без названия',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'KUNNR: ${payer.kunnr ?? '-'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (payer.defaultFlag ?? false)
                  const Chip(
                    label: Text('По умолчанию'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (payer.weTab?.isNotEmpty ?? false)
                  _buildCountChip(Icons.local_shipping, 'Грузополучатели', payer.weTab!.length),
                if (payer.zaTab?.isNotEmpty ?? false)
                  _buildCountChip(Icons.location_on, 'Адреса', payer.zaTab!.length),
                if (payer.contactTab?.isNotEmpty ?? false)
                  _buildCountChip(Icons.person, 'Контакты', payer.contactTab!.length),
                if (payer.dogovorTab?.isNotEmpty ?? false)
                  _buildCountChip(Icons.article, 'Договоры', payer.dogovorTab!.length),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountChip(IconData icon, String label, int count) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text('$label: $count'),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildContactsList(List contacts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final fullName = '${contact.lname ?? ""} ${contact.fname ?? ""} ${contact.mname ?? ""}'.trim();
        
        return ListTile(
          leading: CircleAvatar(
            child: Text(fullName.isNotEmpty ? fullName[0].toUpperCase() : '?'),
          ),
          title: Text(fullName.isNotEmpty ? fullName : 'Контакт ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contact.phone != null) Text('Тел: ${contact.phone}'),
              if (contact.email != null) Text('Email: ${contact.email}'),
            ],
          ),
          trailing: (contact.defaultFlag ?? false)
              ? const Icon(Icons.star, color: Colors.amber)
              : null,
        );
      },
    );
  }

  Widget _buildContractsList(List contracts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];
        
        return ListTile(
          leading: const Icon(Icons.description),
          title: Text(contract.bstkd ?? 'Договор ${contract.vbeln ?? index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Номер: ${contract.vbeln ?? '-'}'),
              if (contract.klimk != null) 
                Text('Лимит: ${contract.klimk} ${contract.waers ?? ''}'),
              if (contract.datbi != null) 
                Text('До: ${contract.datbi}'),
            ],
          ),
          trailing: (contract.defaultFlag ?? false)
              ? const Icon(Icons.star, color: Colors.amber)
              : null,
        );
      },
    );
  }

  Widget _buildSupplierInfoTab(BuildContext context, Translations t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Logo placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'ARMTEK',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Armtek',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Поставщик автозапчастей',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _buildInfoItem(Icons.language, 'Веб-сайт', 'www.armtek.ru'),
                  const SizedBox(height: 16),
                  _buildInfoItem(Icons.phone, 'Телефон поддержки', '8-800-775-8725'),
                  const SizedBox(height: 16),
                  _buildInfoItem(Icons.email, 'Email', 'support@armtek.ru'),
                  const SizedBox(height: 16),
                  _buildInfoItem(Icons.access_time, 'Режим работы', 'Пн-Пт: 9:00-18:00'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _calculateTotalAddresses(UserStructureRoot structure) {
    int total = 0;
    if (structure.rgTab != null) {
      for (var payer in structure.rgTab!) {
        total += (payer.zaTab?.length ?? 0);
      }
    }
    return total;
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  _StatItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });
}