import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/widgets/buttons.dart';
import 'package:part_catalog/core/widgets/loading_indicator.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/settings/armtek/notifiers/armtek_settings_notifier.dart';
import 'package:part_catalog/features/settings/armtek/state/armtek_settings_state.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';

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
    // Загрузка начальных данных при инициализации
    // ref.read(armtekSettingsNotifierProvider.notifier).init(); // Уже вызывается в конструкторе Notifier

    // Синхронизация контроллеров с состоянием (если нужно при первой загрузке)
    final initialState = ref.read(armtekSettingsNotifierProvider);
    _loginController.text = initialState.loginInput;
    // _passwordController.text = initialState.passwordInput; // Пароль не предзаполняем
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

    // Обновляем контроллеры, если логин изменился в состоянии (например, после загрузки)
    // Делаем это аккуратно, чтобы не перезаписывать ввод пользователя
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
    // Для планшета можно использовать две колонки или более широкую форму
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
    // Для десктопа можно использовать более сложный макет
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
            validator: (value) {
              // Валидация пароля только если пытаемся сохранить
              return null;
            },
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
                child: Text(t.core
                    .resetButtonLabel), // Используйте t.core.clearButtonLabel если есть
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
                          // Предполагаем, что vkorg это Map или объект с полем 'NAME' и 'VKORG'
                          value: vkorg.vkorg,
                          child: Text(vkorg.programName),
                        ))
                    .toList(),
                onChanged: state.isLoadingArmtekData
                    ? null
                    : (value) => notifier.selectVkorg(value),
              ),
            const SizedBox(height: 16),
            if (state.selectedVkorg != null && state.userInfo != null)
              _buildUserInfo(context, state.userInfo!, t),
            // TODO: Отобразить storeList и brandList, если нужно
          ],
        ],
      ),
    );
  }

  Widget _buildUserInfo(
      BuildContext context, UserInfoResponse userInfo, Translations t) {
    // Используем типизированный объект UserInfoResponse
    final structure = userInfo.structure; // Доступ к полю structure напрямую

    if (structure == null) {
      return Text(t.settings.armtekSettings.userInfoUnavailable);
    }

    // Теперь structure это UserStructureRoot?, и мы можем обращаться к его полям
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.settings.armtekSettings.clientInfoTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
                '${t.settings.armtekSettings.clientStructureKUNAG}: ${structure.kunag ?? ''}'),
            Text(
                '${t.settings.armtekSettings.clientStructureVKORG}: ${structure.vkorg ?? ''}'),
            Text(
                '${t.settings.armtekSettings.clientStructureSNAME}: ${structure.sname ?? ''}'),
            Text(
                '${t.settings.armtekSettings.clientStructureADRESS}: ${structure.adress ?? ''}'),
            // Добавьте другие поля из UserStructureRoot по необходимости
            // Например, если нужно отобразить RG_TAB:
            if (structure.rgTab != null && structure.rgTab!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                  t.settings.armtekSettings
                      .rgTabInfoTitle, // Добавьте эту строку в локализацию
                  style: Theme.of(context).textTheme.titleSmall),
              ...structure.rgTab!.map((rgItem) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${t.settings.armtekSettings.rgTabKUNNR}: ${rgItem.kunnr ?? ''}'),
                      Text(
                          '${t.settings.armtekSettings.rgTabSNAME}: ${rgItem.sname ?? ''}'),
                      // Добавьте другие поля из UserStructureItem
                    ],
                  ),
                );
              }),
            ]
          ],
        ),
      ),
    );
  }
}

// Добавьте AppBarLoadingIndicator если его нет
class AppBarLoadingIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
