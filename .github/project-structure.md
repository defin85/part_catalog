# Tree View:
```
./lib
├─core
│ ├─config
│ │ └─global_api_settings_service.dart
│ ├─database
│ │ ├─daos
│ │ │ ├─cars_dao.dart
│ │ │ ├─cars_dao.g.dart
│ │ │ ├─clients_dao.dart
│ │ │ ├─clients_dao.g.dart
│ │ │ ├─orders_dao.dart
│ │ │ ├─orders_dao.g.dart
│ │ │ ├─supplier_settings_dao.dart
│ │ │ └─supplier_settings_dao.g.dart
│ │ ├─database.dart
│ │ ├─database.g.dart
│ │ ├─database_logger.dart
│ │ ├─items
│ │ │ ├─app_info_items.dart
│ │ │ ├─cars_items.dart
│ │ │ ├─clients_items.dart
│ │ │ ├─order_parts_items.dart
│ │ │ ├─order_services_items.dart
│ │ │ ├─orders_items.dart
│ │ │ ├─reference_closure_items.dart
│ │ │ └─supplier_settings_items.dart
│ │ └─schema_synchronizer.dart
│ ├─i18n
│ │ ├─clients
│ │ │ ├─clients_en.i18n.json
│ │ │ └─clients_ru.i18n.json
│ │ ├─common
│ │ │ ├─common_en.i18n.json
│ │ │ └─common_ru.i18n.json
│ │ ├─core
│ │ │ ├─core_en.i18n.json
│ │ │ └─core_ru.i18n.json
│ │ ├─custom_app_locale.dart
│ │ ├─errors
│ │ │ ├─errors_en.i18n.json
│ │ │ └─errors_ru.i18n.json
│ │ ├─orders
│ │ │ ├─orders_en.i18n.json
│ │ │ └─orders_ru.i18n.json
│ │ ├─parts
│ │ │ ├─parts_en.i18n.json
│ │ │ └─parts_ru.i18n.json
│ │ ├─services
│ │ │ ├─services_en.i18n.json
│ │ │ └─services_ru.i18n.json
│ │ ├─settings
│ │ │ ├─settings_en.i18n.json
│ │ │ └─settings_ru.i18n.json
│ │ ├─strings.g.dart
│ │ ├─strings_en.g.dart
│ │ ├─strings_ru.g.dart
│ │ └─vehicles
│ │   ├─vehicles_en.i18n.json
│ │   └─vehicles_ru.i18n.json
│ ├─navigation
│ │ ├─app_router.dart
│ │ └─app_routes.dart
│ ├─providers
│ │ ├─core_providers.dart
│ │ └─core_providers.g.dart
│ ├─schemas
│ │ └─app_schema.json
│ ├─service_locator.dart
│ ├─utils
│ │ ├─json_converter.dart
│ │ ├─log_messages.dart
│ │ └─logger_config.dart
│ └─widgets
│   └─language_switcher.dart
├─features
│ ├─armtek
│ │ └─api
│ │   ├─MaterialRestConnection.md
│ │   ├─MaterialRestResponse.md
│ │   ├─MaterialRestRules.md
│ │   ├─MaterialWsGetOrder2.md
│ │   ├─ServiceInvoice.md
│ │   ├─ServiceOrder.md
│ │   ├─ServicePing.md
│ │   ├─ServiceReports.md
│ │   ├─ServiceSearch.md
│ │   └─ServiceUser.md
│ ├─core
│ │ ├─base_item_type.dart
│ │ ├─document_item_specific_data.dart
│ │ ├─document_item_specific_data.freezed.dart
│ │ ├─document_item_specific_data.g.dart
│ │ ├─document_specific_data.dart
│ │ ├─document_specific_data.freezed.dart
│ │ ├─document_specific_data.g.dart
│ │ ├─document_status.dart
│ │ ├─entity_core_data.dart
│ │ ├─entity_core_data.freezed.dart
│ │ ├─entity_core_data.g.dart
│ │ ├─i_document_entity.dart
│ │ ├─i_document_item_entity.dart
│ │ ├─i_entity.dart
│ │ ├─i_item_entity.dart
│ │ ├─i_reference_entity.dart
│ │ ├─i_reference_item_entity.dart
│ │ ├─item_core_data.dart
│ │ ├─item_core_data.freezed.dart
│ │ └─item_core_data.g.dart
│ ├─documents
│ │ ├─orders
│ │ │ ├─models
│ │ │ │ ├─order_model_composite.dart
│ │ │ │ ├─order_part_model_composite.dart
│ │ │ │ ├─order_service_model_composite.dart
│ │ │ │ ├─order_specific_data.dart
│ │ │ │ ├─order_specific_data.freezed.dart
│ │ │ │ ├─order_specific_data.g.dart
│ │ │ │ ├─order_status.dart
│ │ │ │ ├─part_specific_data.dart
│ │ │ │ ├─part_specific_data.freezed.dart
│ │ │ │ ├─part_specific_data.g.dart
│ │ │ │ ├─service_specific_data.dart
│ │ │ │ ├─service_specific_data.freezed.dart
│ │ │ │ └─service_specific_data.g.dart
│ │ │ ├─notifiers
│ │ │ │ ├─order_form_notifier.dart
│ │ │ │ ├─orders_notifier.dart
│ │ │ │ └─orders_notifier.g.dart
│ │ │ ├─providers
│ │ │ │ └─order_providers.dart
│ │ │ ├─screens
│ │ │ │ ├─order_details_screen.dart
│ │ │ │ ├─order_form_screen.dart
│ │ │ │ └─orders_screen.dart
│ │ │ ├─services
│ │ │ │ └─order_service.dart
│ │ │ ├─state
│ │ │ │ ├─order_form_state.dart
│ │ │ │ └─order_form_state.freezed.dart
│ │ │ └─widgets
│ │ │   └─order_list_item.dart
│ │ └─part_orders
│ ├─home
│ │ ├─models
│ │ │ └─navigation_item.dart
│ │ └─screens
│ │   └─home_screen.dart
│ ├─parts_catalog
│ │ ├─api
│ │ │ ├─PartsCatalogsRestAPI.md
│ │ │ ├─api_client_parts_catalogs.dart
│ │ │ └─api_client_parts_catalogs.g.dart
│ │ ├─models
│ │ │ ├─car2.dart
│ │ │ ├─car2.freezed.dart
│ │ │ ├─car2.g.dart
│ │ │ ├─car_info.dart
│ │ │ ├─car_info.freezed.dart
│ │ │ ├─car_info.g.dart
│ │ │ ├─car_parameter.dart
│ │ │ ├─car_parameter.freezed.dart
│ │ │ ├─car_parameter.g.dart
│ │ │ ├─car_parameter_idx.dart
│ │ │ ├─car_parameter_idx.freezed.dart
│ │ │ ├─car_parameter_idx.g.dart
│ │ │ ├─car_parameter_info.dart
│ │ │ ├─car_parameter_info.freezed.dart
│ │ │ ├─car_parameter_info.g.dart
│ │ │ ├─catalog.dart
│ │ │ ├─catalog.freezed.dart
│ │ │ ├─catalog.g.dart
│ │ │ ├─error.dart
│ │ │ ├─error.freezed.dart
│ │ │ ├─error.g.dart
│ │ │ ├─example_prices_response.dart
│ │ │ ├─example_prices_response.freezed.dart
│ │ │ ├─example_prices_response.g.dart
│ │ │ ├─group.dart
│ │ │ ├─group.freezed.dart
│ │ │ ├─group.g.dart
│ │ │ ├─groups_tree.dart
│ │ │ ├─groups_tree.freezed.dart
│ │ │ ├─groups_tree.g.dart
│ │ │ ├─groups_tree_response.dart
│ │ │ ├─groups_tree_response.freezed.dart
│ │ │ ├─groups_tree_response.g.dart
│ │ │ ├─ip.dart
│ │ │ ├─ip.freezed.dart
│ │ │ ├─ip.g.dart
│ │ │ ├─model.dart
│ │ │ ├─model.freezed.dart
│ │ │ ├─model.g.dart
│ │ │ ├─option_code.dart
│ │ │ ├─option_code.freezed.dart
│ │ │ ├─option_code.g.dart
│ │ │ ├─part.dart
│ │ │ ├─part.freezed.dart
│ │ │ ├─part.g.dart
│ │ │ ├─part_name.dart
│ │ │ ├─part_name.freezed.dart
│ │ │ ├─part_name.g.dart
│ │ │ ├─parts.dart
│ │ │ ├─parts.freezed.dart
│ │ │ ├─parts.g.dart
│ │ │ ├─parts_group.dart
│ │ │ ├─parts_group.freezed.dart
│ │ │ ├─parts_group.g.dart
│ │ │ ├─position.dart
│ │ │ ├─position.freezed.dart
│ │ │ ├─position.g.dart
│ │ │ ├─schema_model.dart
│ │ │ ├─schema_model.freezed.dart
│ │ │ ├─schema_model.g.dart
│ │ │ ├─schemas_response.dart
│ │ │ ├─schemas_response.freezed.dart
│ │ │ ├─schemas_response.g.dart
│ │ │ ├─suggest.dart
│ │ │ ├─suggest.freezed.dart
│ │ │ └─suggest.g.dart
│ │ ├─screens
│ │ └─widgets
│ │   ├─car_info_widget.dart
│ │   └─schema_list_widget.dart
│ ├─references
│ │ ├─clients
│ │ │ ├─models
│ │ │ │ ├─client_model_composite.dart
│ │ │ │ ├─client_specific_data.dart
│ │ │ │ ├─client_specific_data.freezed.dart
│ │ │ │ ├─client_specific_data.g.dart
│ │ │ │ └─client_type.dart
│ │ │ ├─providers
│ │ │ │ ├─client_providers.dart
│ │ │ │ └─client_providers.g.dart
│ │ │ ├─screens
│ │ │ │ └─clients_screen.dart
│ │ │ └─services
│ │ │   └─client_service.dart
│ │ ├─suppliers
│ │ │ ├─api
│ │ │ └─models
│ │ │   ├─price_offer.dart
│ │ │   ├─price_offer.g.dart
│ │ │   ├─supplier.dart
│ │ │   └─supplier.g.dart
│ │ └─vehicles
│ │   ├─models
│ │   │ ├─car_model_composite.dart
│ │   │ ├─car_specific_data.dart
│ │   │ ├─car_specific_data.freezed.dart
│ │   │ └─car_specific_data.g.dart
│ │   ├─providers
│ │   │ ├─car_providers.dart
│ │   │ └─car_providers.g.dart
│ │   ├─screens
│ │   │ └─cars_screen.dart
│ │   └─services
│ │     └─car_service.dart
│ ├─registers
│ │ ├─finances
│ │ └─parts_inventory
│ ├─settings
│ │ ├─api_control_center
│ │ │ ├─notifiers
│ │ │ │ └─api_control_center_notifier.dart
│ │ │ ├─screens
│ │ │ │ └─api_control_center_screen.dart
│ │ │ └─state
│ │ │   ├─api_control_center_state.dart
│ │ │   └─api_control_center_state.freezed.dart
│ │ └─armtek
│ │   ├─notifiers
│ │   │ └─armtek_settings_notifier.dart
│ │   ├─screens
│ │   │ └─armtek_settings_screen.dart
│ │   └─state
│ │     ├─armtek_settings_state.dart
│ │     └─armtek_settings_state.freezed.dart
│ └─suppliers
│   ├─api
│   │ ├─api_client_manager.dart
│   │ ├─api_connection_mode.dart
│   │ ├─base_supplier_api_client.dart
│   │ └─implementations
│   │   ├─armtek_api_client.dart
│   │   └─armtek_api_client.g.dart
│   ├─config
│   │ └─supported_suppliers.dart
│   ├─models
│   │ ├─armtek
│   │ │ ├─armtek_message.dart
│   │ │ ├─armtek_message.freezed.dart
│   │ │ ├─armtek_message.g.dart
│   │ │ ├─armtek_response_wrapper.dart
│   │ │ ├─armtek_response_wrapper.freezed.dart
│   │ │ ├─armtek_response_wrapper.g.dart
│   │ │ ├─brand_item.dart
│   │ │ ├─brand_item.freezed.dart
│   │ │ ├─brand_item.g.dart
│   │ │ ├─ping_response.dart
│   │ │ ├─ping_response.freezed.dart
│   │ │ ├─ping_response.g.dart
│   │ │ ├─store_item.dart
│   │ │ ├─store_item.freezed.dart
│   │ │ ├─store_item.g.dart
│   │ │ ├─user_contact.dart
│   │ │ ├─user_contact.freezed.dart
│   │ │ ├─user_contact.g.dart
│   │ │ ├─user_delivery_address.dart
│   │ │ ├─user_delivery_address.freezed.dart
│   │ │ ├─user_delivery_address.g.dart
│   │ │ ├─user_ftp_data.dart
│   │ │ ├─user_ftp_data.freezed.dart
│   │ │ ├─user_ftp_data.g.dart
│   │ │ ├─user_info_request.dart
│   │ │ ├─user_info_request.freezed.dart
│   │ │ ├─user_info_request.g.dart
│   │ │ ├─user_info_response.dart
│   │ │ ├─user_info_response.freezed.dart
│   │ │ ├─user_info_response.g.dart
│   │ │ ├─user_structure_item.dart
│   │ │ ├─user_structure_item.freezed.dart
│   │ │ ├─user_structure_item.g.dart
│   │ │ ├─user_vkorg.dart
│   │ │ ├─user_vkorg.freezed.dart
│   │ │ └─user_vkorg.g.dart
│   │ └─base
│   │   ├─part_price_response.dart
│   │   ├─part_price_response.freezed.dart
│   │   └─part_price_response.g.dart
│   └─services
│     └─suppliers_service.dart
├─main.dart
└─models