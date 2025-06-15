import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/widgets/buttons.dart';
import 'package:part_catalog/core/widgets/loading_indicator.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/settings/armtek/notifiers/armtek_settings_notifier.dart';
import 'package:part_catalog/features/settings/armtek/state/armtek_settings_state.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/exw_item.dart'; // Corrected import
import 'package:part_catalog/features/suppliers/models/armtek/dogovor_item.dart'; // Corrected import
import 'package:part_catalog/features/suppliers/models/armtek/contact_tab_item.dart'; // Corrected import

class ArmtekSettingsScreen extends ConsumerStatefulWidget {
  const ArmtekSettingsScreen({super.key});

  @override
  ConsumerState<ArmtekSettingsScreen> createState() =>
      _ArmtekSettingsScreenState();
}

class _ArmtekSettingsScreenState extends ConsumerState<ArmtekSettingsScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(armtekSettingsNotifierProvider);
    _loginController.text = initialState.loginInput;
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(armtekSettingsNotifierProvider);
    final notifier = ref.read(armtekSettingsNotifierProvider.notifier);
    final t = Translations.of(context);

    if (_loginController.text != state.loginInput &&
        !(_formKey.currentState?.validate() ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loginController.text = state.loginInput;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.armtekSettings.screenTitle),
        actions: [
          if (state.isLoading) const AppBarLoadingIndicator(),
        ],
      ),
      body: ResponsiveLayoutBuilder(
        small: (_, __) => _buildMobileLayout(context, state, notifier, t),
        medium: (_, __) => _buildTabletLayout(context, state, notifier, t),
        large: (_, __) => _buildDesktopLayout(context, state, notifier, t),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildFormContent(context, state, notifier, t),
    );
  }

  Widget _buildTabletLayout(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _buildFormContent(context, state, notifier, t),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: _buildFormContent(context, state, notifier, t),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(t.settings.armtekSettings.credentialsSectionTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextFormField(
            controller: _loginController,
            decoration: InputDecoration(
              labelText: t.settings.armtekSettings.loginLabel,
              border: const OutlineInputBorder(),
            ),
            onChanged: notifier.updateLogin,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.settings.armtekSettings.loginRequiredError;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: t.settings.armtekSettings.passwordLabel,
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: notifier.updatePassword,
          ),
          const SizedBox(height: 24),
          if (state.connectionStatusMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                state.connectionStatusMessage!,
                style: TextStyle(
                    color: state.isConnected ? Colors.green : Colors.red),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                onPressed: state.isLoading ? null : notifier.clearSettings,
                child: Text(t.core.resetButtonLabel),
              ),
              const SizedBox(width: 16),
              PrimaryButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (state.passwordInput.isEmpty &&
                              !state.isConnected) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(t.settings.armtekSettings
                                      .passwordRequiredError)),
                            );
                            return;
                          }
                          notifier.checkAndSaveConnection();
                        }
                      },
                child: Text(t.settings.armtekSettings.checkAndSaveButton),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(state.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            ),
          if (state.isConnected) ...[
            const Divider(height: 40),
            Text(t.settings.armtekSettings.supplierInfoSectionTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (state.isLoadingArmtekData) const LoadingIndicator(),
            if (state.userVkorgList != null && state.userVkorgList!.isNotEmpty)
              DropdownButtonFormField<String>(
                value: state.selectedVkorg,
                decoration: InputDecoration(
                  labelText: t.settings.armtekSettings.vkorgLabel,
                  border: const OutlineInputBorder(),
                ),
                items: state.userVkorgList!
                    .map((vkorg) => DropdownMenuItem<String>(
                          value: vkorg.vkorg,
                          child: Text('${vkorg.programName} (${vkorg.vkorg})'),
                        ))
                    .toList(),
                onChanged: state.isLoadingArmtekData
                    ? null
                    : (value) => notifier.selectVkorg(value),
              ),
            const SizedBox(height: 16),
            if (state.selectedVkorg != null && state.userInfo != null)
              _buildUserInfo(context, state.userInfo!, t),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, Translations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value ?? t.core.notSpecified)),
        ],
      ),
    );
  }

  Widget _buildUserInfo(
      BuildContext context, UserInfoResponse userInfo, Translations t) {
    final structure = userInfo.structure;

    if (structure == null) {
      return Text(t.settings.armtekSettings.userInfoUnavailable);
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.settings.armtekSettings.clientInfoTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildDetailRow(t.settings.armtekSettings.clientStructureKUNAG,
                structure.kunag, t),
            _buildDetailRow(t.settings.armtekSettings.clientStructureVKORG,
                structure.vkorg, t),
            _buildDetailRow(t.settings.armtekSettings.clientStructureSNAME,
                structure.sname, t),
            _buildDetailRow(t.settings.armtekSettings.clientStructureFNAME,
                structure.fname, t),
            _buildDetailRow(t.settings.armtekSettings.clientStructureADRESS,
                structure.adress, t),
            _buildDetailRow(t.settings.armtekSettings.clientStructurePHONE,
                structure.phone, t),
            if (structure.rgTab != null && structure.rgTab!.isNotEmpty) ...[
              const Divider(height: 30),
              Text(t.settings.armtekSettings.rgTabInfoTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...structure.rgTab!.map((rgItem) {
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(rgItem.sname ?? t.core.unnamedEntry),
                    subtitle: Text(
                        '${t.settings.armtekSettings.rgTabKUNNR}: ${rgItem.kunnr ?? '-'}'),
                    childrenPadding: const EdgeInsets.all(16.0),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(t.settings.armtekSettings.rgTabSNAME,
                          rgItem.sname, t),
                      _buildDetailRow(t.settings.armtekSettings.rgTabFNAME,
                          rgItem.fname, t),
                      _buildDetailRow(t.settings.armtekSettings.rgTabADRESS,
                          rgItem.adress, t),
                      _buildDetailRow(t.settings.armtekSettings.rgTabPHONE,
                          rgItem.phone, t),
                      _buildDetailRow(
                          t.settings.armtekSettings.rgTabDEFAULT,
                          (rgItem.defaultFlag ?? false)
                              ? t.core.yes
                              : t.core.no,
                          t),
                      if (rgItem.exwTab != null && rgItem.exwTab!.isNotEmpty)
                        _buildExwTabWidget(context, rgItem.exwTab!, t),
                      if (rgItem.dogovorTab != null &&
                          rgItem.dogovorTab!.isNotEmpty)
                        _buildDogovorTabWidget(context, rgItem.dogovorTab!, t),
                      if (rgItem.contactTab != null &&
                          rgItem.contactTab!.isNotEmpty)
                        _buildContactTabWidget(context, rgItem.contactTab!, t),
                    ],
                  ),
                );
              }),
            ],
            // Removed direct access to structure.exwTab as it's not a direct property of UserStructureRoot
            // If there's a top-level exwTab, it should be handled differently based on API response structure.
            // For now, assuming exwTab is only within rgTab items.
          ],
        ),
      ),
    );
  }

  Widget _buildExwTabWidget(
      BuildContext context, List<ExwItem> exwTab, Translations t,
      {bool isTopLevel = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              isTopLevel
                  ? t.settings.armtekSettings.exwTabTopLevelInfoTitle
                  : t.settings.armtekSettings.exwTabInfoTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: exwTab.map((exw) {
              return Tooltip(
                message: '${t.settings.armtekSettings.exwTabId}: ${exw.id}',
                child: Chip(
                  label: Text(exw.name ?? exw.id ?? t.core.unnamedEntry),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDogovorTabWidget(
      BuildContext context, List<DogovorItem> dogovorTab, Translations t) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.settings.armtekSettings.dogovorTabInfoTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...dogovorTab.map((dogovor) {
            return Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        dogovor.bstkd ??
                            t.settings.armtekSettings.dogovorDefaultTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    _buildDetailRow(t.settings.armtekSettings.dogovorNumber,
                        dogovor.vbeln, t),
                    _buildDetailRow(
                        t.settings.armtekSettings.dogovorCreditLimit,
                        '${dogovor.klimk ?? "0.00"} ${dogovor.waers ?? ""}',
                        t),
                    _buildDetailRow(t.settings.armtekSettings.dogovorDateEnd,
                        dogovor.datbi, t),
                    _buildDetailRow(
                        t.settings.armtekSettings.dogovorDefault,
                        (dogovor.defaultFlag ?? false) ? t.core.yes : t.core.no,
                        t),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContactTabWidget(
      BuildContext context, List<ContactTabItem> contactTab, Translations t) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.settings.armtekSettings.contactTabInfoTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...contactTab.map((contact) {
            final fullName =
                '${contact.lname ?? ""} ${contact.fname ?? ""} ${contact.mname ?? ""}'
                    .trim();
            return Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName.isNotEmpty ? fullName : t.core.unnamedEntry,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    _buildDetailRow(t.settings.armtekSettings.contactPhone,
                        contact.phone, t),
                    _buildDetailRow(t.settings.armtekSettings.contactEmail,
                        contact.email, t),
                    _buildDetailRow(
                        t.settings.armtekSettings.contactDefault,
                        (contact.defaultFlag ?? false) ? t.core.yes : t.core.no,
                        t),
                    _buildDetailRow(t.settings.armtekSettings.contactInternalId,
                        contact.parnr, t),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class AppBarLoadingIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child:
              CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
