import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/widgets/buttons.dart';
import 'package:part_catalog/core/widgets/loading_indicator.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/settings/armtek/notifiers/armtek_settings_notifier.dart';
import 'package:part_catalog/features/settings/armtek/state/armtek_settings_state.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/settings/armtek/widgets/armtek_info_master_detail.dart';

class ArmtekSettingsScreen extends ConsumerStatefulWidget {
  const ArmtekSettingsScreen({super.key});

  @override
  ConsumerState<ArmtekSettingsScreen> createState() =>
      _ArmtekSettingsScreenState();
}

class _ArmtekSettingsScreenState extends ConsumerState<ArmtekSettingsScreen>
    with SingleTickerProviderStateMixin {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Устанавливаем начальные значения после первого фрейма
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final initialState = ref.read(armtekSettingsNotifierProvider);
        _loginController.text = initialState.loginInput;
        _passwordController.text = initialState.passwordInput;
      }
    });
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

    // Синхронизируем контроллеры с состоянием
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (_loginController.text != state.loginInput) {
          _loginController.text = state.loginInput;
        }
        if (_passwordController.text != state.passwordInput) {
          _passwordController.text = state.passwordInput;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.armtekSettings.screenTitle),
        actions: [
          if (state.isLoading) const AppBarLoadingIndicator(),
        ],
        bottom: state.isConnected
            ? TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.login),
                    text: t.settings.armtekSettings.credentialsSectionTitle,
                  ),
                  Tab(
                    icon: const Icon(Icons.business),
                    text: t.settings.armtekSettings.supplierInfoSectionTitle,
                  ),
                ],
              )
            : null,
      ),
      body: state.isConnected
          ? TabBarView(
              controller: _tabController,
              children: [
                ResponsiveLayoutBuilder(
                  small: (_, __) => _buildMobileAuthForm(context, state, notifier, t),
                  medium: (_, __) => _buildTabletAuthForm(context, state, notifier, t),
                  large: (_, __) => _buildDesktopAuthForm(context, state, notifier, t),
                ),
                ResponsiveLayoutBuilder(
                  small: (_, __) => _buildMobileSupplierInfo(context, state, notifier, t),
                  medium: (_, __) => _buildTabletSupplierInfo(context, state, notifier, t),
                  large: (_, __) => _buildDesktopSupplierInfo(context, state, notifier, t),
                ),
              ],
            )
          : ResponsiveLayoutBuilder(
              small: (_, __) => _buildMobileAuthForm(context, state, notifier, t),
              medium: (_, __) => _buildTabletAuthForm(context, state, notifier, t),
              large: (_, __) => _buildDesktopAuthForm(context, state, notifier, t),
            ),
    );
  }

  Widget _buildMobileAuthForm(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildAuthFormContent(context, state, notifier, t),
    );
  }

  Widget _buildTabletAuthForm(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildAuthFormContent(context, state, notifier, t),
        ),
      ),
    );
  }

  Widget _buildDesktopAuthForm(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildAuthFormContent(context, state, notifier, t),
        ),
      ),
    );
  }

  Widget _buildMobileSupplierInfo(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return _buildSupplierInfoContent(context, state, notifier, t);
  }

  Widget _buildTabletSupplierInfo(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return _buildSupplierInfoContent(context, state, notifier, t);
  }

  Widget _buildDesktopSupplierInfo(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return _buildSupplierInfoContent(context, state, notifier, t);
  }

  Widget _buildAuthFormContent(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
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
                        t.settings.armtekSettings.credentialsSectionTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const Key('login_field'),
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: t.settings.armtekSettings.loginLabel,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    onChanged: notifier.updateLogin,
                    validator: (value) {
                      // Проверяем актуальное значение из состояния, а не только из поля
                      final actualValue = value ?? '';
                      final stateValue = state.loginInput;
                      if (actualValue.isEmpty && stateValue.isEmpty) {
                        return t.settings.armtekSettings.loginRequiredError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('password_field'),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: t.settings.armtekSettings.passwordLabel,
                      hintText: _passwordController.text.isEmpty ? '' : '••••••••',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    obscuringCharacter: '•',
                    onChanged: notifier.updatePassword,
                    validator: (value) {
                      // Проверяем актуальное значение из состояния
                      final actualValue = value ?? '';
                      final stateValue = state.passwordInput;
                      if (actualValue.isEmpty && stateValue.isEmpty && !state.isConnected) {
                        return t.settings.armtekSettings.passwordRequiredError;
                      }
                      return null;
                    },
                  ),
                  if (state.connectionStatusMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: state.isConnected
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.isConnected ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            state.isConnected ? Icons.check_circle : Icons.error,
                            color: state.isConnected ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.connectionStatusMessage!,
                              style: TextStyle(
                                color: state.isConnected ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
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
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierInfoContent(BuildContext context, ArmtekSettingsState state,
      ArmtekSettingsNotifier notifier, Translations t) {
    if (state.isLoadingArmtekData) {
      return const Center(child: LoadingIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.userVkorgList != null && state.userVkorgList!.isNotEmpty)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          t.settings.armtekSettings.vkorgLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: state.selectedVkorg,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
          const SizedBox(height: 16),
          if (state.selectedVkorg != null && state.userInfo != null)
            _buildUserInfo(context, state.userInfo!, state, t),
        ],
      ),
    );
  }


  Widget _buildUserInfo(
      BuildContext context, UserInfoResponse userInfo, ArmtekSettingsState state, Translations t) {
    final structure = userInfo.structure;

    if (structure == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(t.settings.armtekSettings.userInfoUnavailable),
        ),
      );
    }

    // Возвращаем виджет с ограничением по высоте
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: ArmtekInfoMasterDetail(
        structure: structure,
        brandList: state.brandList,
        storeList: state.storeList,
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
