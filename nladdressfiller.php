<?php
/**
 * Copyright (C) 2017-2018 thirty bees
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.md
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@thirtybees.com so we can send you a copy immediately.
 *
 * @author    thirty bees <contact@thirtybees.com>
 * @copyright 2017-2018 thirty bees
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 */

if (!defined('_TB_VERSION_')) {
    return;
}

/**
 * Class nladdressfiller
 */
class nladdressfiller extends Module
{
    const FRONTOFFICE = 'PCNL_FRONTOFFICE';
    const BACKOFFICE = 'PCNL_BACKOFFICE';
    const FRONTOFFICE_DISABLE_MANUAL_FILL = 'PCNL_FRONTOFFICE_DISABLE_MAN';
    const BACKOFFICE_DISABLE_MANUAL_FILL = 'PCNL_BACKOFFICE_DISABLE_MAN';
    const ZELARG_POSTCODE = 'PCNL_ZELARG_POSTCODE';
    const ZELARG_HOUSENR = 'PCNL_ZELARG_HOUSENR';
    const DEV_MODE = 'PCNL_DEV_MODE';
    const DEV_MODE_IPS = 'PCNL_DEV_MODE_IPS';

    /**
     * nladdressfiller constructor.
     *
     * @throws Exception
     * @throws PrestaShopException
     */
    public function __construct()
    {
        $this->name = 'nladdressfiller';
        $this->tab = 'front_office_features';
        $this->version = '2.0.0';
        $this->author = 'thirty bees';
        $this->bootstrap = true;
        $this->need_instance = 1;

        $this->controllers = ['postcodeajax'];

        parent::__construct();

        $this->displayName = $this->l('Address auto lookup with postcode + number');
        $this->description = $this->l('Enables address autofill with the help of postcode + house number');
    }

    /**
     * Hooks that should be registered during installation
     *
     * @var array Array with hooks names
     */
    protected $hooks = [
        'header',
        'displayMobileHeader',
        'customerAccountForm',
        'backOfficeHeader',
    ];

    /**
     * Install the module
     *
     * @return bool Whether the installation succeeded
     * @throws PrestaShopException
     */
    public function install()
    {
        if (parent::install()) {
            foreach ($this->hooks as $hook) {
                if (!$this->registerHook($hook)) {
                    return false;
                }
            }

            return true;
        }

        return false;
    }

    /**
     * Uninstall the module
     *
     * @return bool Whether uninstallation succeeded
     * @throws PrestaShopDatabaseException
     * @throws PrestaShopException
     */
    public function uninstall()
    {
        if (parent::uninstall()) {
            foreach ($this->hooks as $hook) {
                if (!$this->unregisterHook($hook)) {
                    return false;
                }
            }
            Configuration::deleteByName(static::FRONTOFFICE);
            Configuration::deleteByName(static::BACKOFFICE);
            Configuration::deleteByName(static::FRONTOFFICE_DISABLE_MANUAL_FILL);
            Configuration::deleteByName(static::BACKOFFICE_DISABLE_MANUAL_FILL);
            Configuration::deleteByName(static::ZELARG_POSTCODE);
            Configuration::deleteByName(static::ZELARG_HOUSENR);

            return true;
        }

        return false;
    }

    /**
     * Display module configuration page
     *
     * @return string Configuration page HTML
     * @throws Exception
     * @throws SmartyException
     */
    public function getContent()
    {
        if (Tools::isSubmit('submit'.$this->name)) {
            Configuration::updateValue(static::FRONTOFFICE, Tools::getValue(static::FRONTOFFICE));
            Configuration::updateValue(static::FRONTOFFICE_DISABLE_MANUAL_FILL, Tools::getValue(static::FRONTOFFICE_DISABLE_MANUAL_FILL));
            Configuration::updateValue(static::BACKOFFICE, Tools::getValue(static::BACKOFFICE));
            Configuration::updateValue(static::BACKOFFICE_DISABLE_MANUAL_FILL, Tools::getValue(static::BACKOFFICE_DISABLE_MANUAL_FILL));
            Configuration::updateValue(static::DEV_MODE, Tools::getValue(static::DEV_MODE));
            Configuration::updateValue(static::DEV_MODE_IPS, Tools::getValue(static::DEV_MODE_IPS));
            $zelargPostcode = [];
            $zelargHouseNumber = [];
            foreach (Language::getLanguages() as $language) {
                $idLang = (int) $language['id_lang'];
                $zelargPostcode[$idLang] = Tools::getValue(static::ZELARG_POSTCODE.'_'.$idLang);
                $zelargHouseNumber[$idLang] = Tools::getValue(static::ZELARG_HOUSENR.'_'.$idLang);
            }
            Configuration::updateValue(static::ZELARG_POSTCODE, $zelargPostcode);
            Configuration::updateValue(static::ZELARG_HOUSENR, $zelargHouseNumber);
            $this->context->controller->confirmations[] = $this->l('Settings updated');
        }

        return $this->display(__FILE__, 'views/templates/admin/configure.tpl').$this->displayConfigForm();
    }

    /**
     * Display the module's main form
     *
     * @return string Config form HTML
     * @throws Exception
     * @throws PrestaShopDatabaseException
     * @throws PrestaShopException
     * @throws SmartyException
     */
    public function displayConfigForm()
    {
        $helper = new HelperForm();

        $helper->show_toolbar = false;
        $helper->table = $this->table;
        $helper->module = $this;
        $helper->default_form_language = $this->context->language->id;
        $helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG', 0);

        $helper->identifier = $this->identifier;
        $helper->submit_action = 'submit'.$this->name;
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false).'&configure='.$this->name.'&tab_module='.$this->tab.'&module_name='.$this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');

        $helper->tpl_vars = [
            'fields_value' => $this->getConfigFormValues(),
            'languages'    => $this->context->controller->getLanguages(),
            'id_language'  => $this->context->language->id,
        ];

        $forms = [$this->getConfigForm()];
        $forms[] = $this->getDevModeForm();
        if (Module::isEnabled('onepagecheckout')) {
            $forms[] = $this->getZelargForm();
        }

        return $helper->generateForm($forms);
    }

    /**
     * Create the structure of your form.
     */
    protected function getConfigForm()
    {
        return [
            'form' => [
                'legend' => [
                    'title' => $this->l('Settings'),
                    'icon'  => 'icon-cogs',
                ],
                'input'  => [
                    [
                        'type'    => 'switch',
                        'label'   => $this->l('Show on Front Office'),
                        'name'    => static::FRONTOFFICE,
                        'is_bool' => true,
                        'values'  => [
                            [
                                'id'    => 'active_on',
                                'value' => true,
                                'label' => Translate::getAdminTranslation('Enabled', 'AdminCarriers'),
                            ],
                            [
                                'id'    => 'active_off',
                                'value' => false,
                                'label' => Translate::getAdminTranslation('Disabled', 'AdminCarriers'),
                            ],
                        ],
                    ],
                    [
                        'type'    => 'switch',
                        'label'   => $this->l('Disable manual fill on Front Office'),
                        'hint'    => $this->l('Note: both auto and manual fill will still be available when editing an existing address'),
                        'name'    => static::FRONTOFFICE_DISABLE_MANUAL_FILL,
                        'is_bool' => true,
                        'values'  => [
                            [
                                'id'    => 'active_on',
                                'value' => true,
                                'label' => Translate::getAdminTranslation('Enabled', 'AdminCarriers'),
                            ],
                            [
                                'id'    => 'active_off',
                                'value' => false,
                                'label' => Translate::getAdminTranslation('Disabled', 'AdminCarriers'),
                            ],
                        ],
                    ],
                    [
                        'type'    => 'switch',
                        'label'   => $this->l('Show on Back Office'),
                        'name'    => static::BACKOFFICE,
                        'is_bool' => true,
                        'values'  => [
                            [
                                'id'    => 'active_on',
                                'value' => true,
                                'label' => Translate::getAdminTranslation('Enabled', 'AdminCarriers'),
                            ],
                            [
                                'id'    => 'active_off',
                                'value' => false,
                                'label' => Translate::getAdminTranslation('Disabled', 'AdminCarriers'),
                            ],
                        ],
                    ],
                    [
                        'type'    => 'switch',
                        'label'   => $this->l('Disable manual fill on Back Office'),
                        'name'    => static::BACKOFFICE_DISABLE_MANUAL_FILL,
                        'is_bool' => true,
                        'values'  => [
                            [
                                'id'    => 'active_on',
                                'value' => true,
                                'label' => Translate::getAdminTranslation('Enabled', 'AdminCarriers'),
                            ],
                            [
                                'id'    => 'active_off',
                                'value' => false,
                                'label' => Translate::getAdminTranslation('Disabled', 'AdminCarriers'),
                            ],
                        ],
                    ],
                ],
                'submit' => [
                    'title' => $this->l('Save'),
                ],
            ],
        ];
    }

    /**
     * Get simulator form elements
     *
     * @return array Array with simulator form elements
     */
    public function getDevModeForm()
    {
        return [
            'form' => [
                'legend'      => [
                    'title' => $this->l('Developer mode'),
                    'icon'  => 'icon-cogs',
                ],
                'description' => $this->l('In order to test the module you can limit the visibility to your own IP address(es) by enabling dev mode.'),
                'input'       => [
                    [
                        'type'    => 'switch',
                        'label'   => $this->l('Developer mode'),
                        'name'    => static::DEV_MODE,
                        'is_bool' => true,
                        'values'  => [
                            [
                                'id'    => 'active_on',
                                'value' => true,
                                'label' => Translate::getAdminTranslation('Enabled', 'AdminCarriers'),
                            ],
                            [
                                'id'    => 'active_off',
                                'value' => false,
                                'label' => Translate::getAdminTranslation('Disabled', 'AdminCarriers'),
                            ],
                        ],
                    ],
                    [
                        'label' => $this->l('Allowed IP addresses'),
                        'hint'  => $this->l('IP addresses for which the module will be enabled'),
                        'type'  => 'maintenance_ip',
                        'name'  => static::DEV_MODE_IPS,
                    ],
                ],
                'submit'      => [
                    'title' => $this->l('Save'),
                ],
            ],
        ];
    }

    /**
     * Create the structure of your form.
     */
    protected function getZelargForm()
    {
        return [
            'form' => [
                'legend'      => [
                    'title' => $this->l('Zelarg OPC'),
                    'icon'  => 'icon-cogs',
                ],
                'description' => $this->l('The module has detected that Zelarg One Page Checkout has been enabled.'),
                'input'       => [
                    [
                        'type'     => 'text',
                        'label'    => $this->l('Postcode'),
                        'name'     => static::ZELARG_POSTCODE,
                        'size'     => 64,
                        'desc'     => $this->l('Placeholder for postcode'),
                        'required' => true,
                        'lang'     => true,
                    ],
                    [
                        'type'     => 'text',
                        'label'    => $this->l('House number + addition'),
                        'name'     => static::ZELARG_HOUSENR,
                        'desc'     => $this->l('Placeholder for house number + addition'),
                        'size'     => 64,
                        'required' => true,
                        'lang'     => true,
                    ],
                ],
                'submit'      => [
                    'title' => $this->l('Save'),
                ],
            ],
        ];
    }

    /**
     * Set values for the inputs
     *
     * @return array
     * @throws PrestaShopException
     */
    protected function getConfigFormValues()
    {
        $values = [
            static::FRONTOFFICE                     => Configuration::get(static::FRONTOFFICE),
            static::FRONTOFFICE_DISABLE_MANUAL_FILL => Configuration::get(static::FRONTOFFICE_DISABLE_MANUAL_FILL),
            static::BACKOFFICE                      => Configuration::get(static::BACKOFFICE),
            static::BACKOFFICE_DISABLE_MANUAL_FILL  => Configuration::get(static::BACKOFFICE_DISABLE_MANUAL_FILL),
            static::DEV_MODE                        => Configuration::get(static::DEV_MODE),
            static::DEV_MODE_IPS                    => Configuration::get(static::DEV_MODE_IPS),
        ];

        $zelargPostcode = [];
        $zelargHouseNumber = [];
        foreach (Language::getLanguages(true) as $language) {
            $idLang = (int) $language['id_lang'];
            $zelargPostcode[$idLang] = Configuration::get(static::ZELARG_POSTCODE, $idLang);
            $zelargHouseNumber[$idLang] = Configuration::get(static::ZELARG_HOUSENR, $idLang);
        }
        $values[static::ZELARG_POSTCODE] = $zelargPostcode;
        $values[static::ZELARG_HOUSENR] = $zelargHouseNumber;

        return $values;
    }

    /**
     * Front Office header hook
     *
     * @return string Hook HTML
     * @throws Exception
     * @throws PrestaShopDatabaseException
     * @throws PrestaShopException
     * @throws SmartyException
     */
    public function hookHeader()
    {
        if (Configuration::get(static::DEV_MODE) &&
            !in_array(Tools::getRemoteAddr(), explode(',', Configuration::get(static::DEV_MODE_IPS)))) {
            return '';
        }
        if (Configuration::get(static::FRONTOFFICE)) {
            $this->context->smarty->assign('nladdressfiller_enable_man', !Configuration::get(static::FRONTOFFICE_DISABLE_MANUAL_FILL));
            if (is_a($this->context->controller->php_self, 'OrderOpcController') &&
                Module::isEnabled('onepagecheckout')) {
                // Zelarg One Page Checkout module
                $this->context->controller->addJquery();
                $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
                $this->context->smarty->assign([
                    'nladdressfiller_nl_iso'          => (int) Country::getByIso('NL'),
                    'nladdressfiller_module_link'     => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], Tools::usingSecureMode()),
                    'nladdressfiller_zelarg_postcode' => Configuration::get(static::ZELARG_POSTCODE, (int) $this->context->language->id),
                    'nladdressfiller_zelarg_housenr'  => Configuration::get(static::ZELARG_HOUSENR, (int) $this->context->language->id),
                ]);

                return $this->display(__FILE__, '/views/templates/front/insertaddonsopcscript.tpl');
            } elseif (is_a($this->context->controller, 'OrderOpcController') &&
                Module::isEnabled('onepagecheckoutps') &&
                version_compare($this->getModuleVersion('onepagecheckoutps'), '2.0.0', '>=')) {
                // One Page Checkout module by PresTeamShop
                $this->context->controller->addJquery();
                $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
                $this->context->smarty->assign([
                    'nladdressfiller_nl_iso'                  => (int) Country::getByIso('NL'),
                    'nladdressfiller_module_link'             => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], Tools::usingSecureMode()),
                    'nladdressfiller_delivery_address_field'  => '#delivery_address1',
                    'nladdressfiller_delivery_postcode_field' => '#delivery_postcode',
                    'nladdressfiller_delivery_city_field'     => '#delivery_city',
                    'nladdressfiller_invoice_address_field'   => '#invoice_address1',
                    'nladdressfiller_invoice_postcode_field'  => '#invoice_postcode',
                    'nladdressfiller_invoice_city_field'      => '#invoice_city',
                    'nladdressfiller_opc_bootstrap'           => true,
                    'nladdressfiller_parent'                  => true,
                ]);

                return $this->display(__FILE__, '/views/templates/front/insertopcpsscript.tpl');
            } elseif (is_a($this->context->controller, 'OrderOpcController')) {
                // thirty bees OPC
                $this->context->controller->addJquery();
                $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
                $this->context->smarty->assign([
                    'nladdressfiller_nl_iso'      => (int) Country::getByIso('NL'),
                    'nladdressfiller_module_link' => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], Tools::usingSecureMode()),
                ]);

                return $this->display(__FILE__, '/views/templates/front/insertstandardopcscript.tpl');
            } elseif (is_a($this->context->controller, 'AddressController')) {
                // thirty bees address page
                $this->context->controller->addJquery();
                $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
                $this->context->smarty->assign([
                    'nladdressfiller_nl_iso'      => (int) Country::getByIso('NL'),
                    'nladdressfiller_module_link' => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], Tools::usingSecureMode()),
                ]);

                return $this->display(__FILE__, '/views/templates/front/insertscript.tpl');
            } elseif (is_a($this->context->controller, 'AuthController')) {
                // thirty bees guest checkout on 5 step order page
                $this->context->controller->addJquery();
                $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
                $this->context->smarty->assign([
                    'nladdressfiller_nl_iso'      => (int) Country::getByIso('NL'),
                    'nladdressfiller_module_link' => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], Tools::usingSecureMode()),
                ]);

                return $this->display(__FILE__, '/views/templates/front/insertscript.tpl');
            } elseif (isset($this->context->controller->name_module) &&
                $this->context->controller->name_module == 'onepagecheckoutps') {
                // One page checkout by PresTeamShop
                $this->context->controller->addJquery();
                $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
                $this->context->smarty->assign(
                    [
                        'nladdressfiller_nl_iso'                  => (int) Country::getByIso('NL'),
                        'nladdressfiller_module_link'             => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], Tools::usingSecureMode()),
                        'nladdressfiller_delivery_address_field'  => '#tr_delivery_address1',
                        'nladdressfiller_delivery_postcode_field' => '#tr_delivery_postcode',
                        'nladdressfiller_delivery_city_field'     => '#tr_delivery_city',
                        'nladdressfiller_invoice_address_field'   => '#tr_invoice_address1',
                        'nladdressfiller_invoice_postcode_field'  => '#tr_invoice_postcode',
                        'nladdressfiller_invoice_city_field'      => '#tr_invoice_city',
                        'nladdressfiller_opc_bootstrap'           => false,
                        'nladdressfiller_mpparent'                => false,
                    ]
                );

                return $this->display(__FILE__, '/views/templates/front/insertopcpsscript.tpl');
            }
        }

        return '';
    }

    /**
     * Display customer account form hook
     *
     * @return string Hook HTML
     * @throws Exception
     * @throws PrestaShopDatabaseException
     * @throws PrestaShopException
     * @throws SmartyException
     */
    public function hookDisplayCustomerAccountForm()
    {
        if (Configuration::get(static::DEV_MODE) &&
            !in_array(Tools::getRemoteAddr(), explode(',', Configuration::get(static::DEV_MODE_IPS)))) {
            return '';
        }
        if (Configuration::get(static::FRONTOFFICE)) {
            $this->context->controller->addJquery();
            $this->context->controller->addCSS($this->_path.'/views/css/nladdressfiller.css');
            $this->context->smarty->assign([
                'nladdressfiller_nl_iso'      => Country::getByIso('NL'),
                'nladdressfiller_module_link' => $this->context->link->getModuleLink('nladdressfiller', 'postcodeajax', [], true),
                'nladdressfiller_enable_man'  => !Configuration::get(static::FRONTOFFICE_DISABLE_MANUAL_FILL),
            ]);

            return $this->display(__FILE__, '/views/templates/front/nladdressfiller.tpl');
        }
        return '';
    }

    /**
     * Back Office header hook
     *
     * @return string Hook HTML
     * @throws Exception
     * @throws PrestaShopDatabaseException
     * @throws PrestaShopException
     * @throws SmartyException
     */
    public function hookBackOfficeHeader()
    {
        if (Configuration::get(static::DEV_MODE) &&
            !in_array(Tools::getRemoteAddr(), explode(',', Configuration::get(static::DEV_MODE_IPS)))) {
            return '';
        }
        if (Configuration::get(static::BACKOFFICE) &&
            (Tools::getValue('controller') == 'AdminAddresses' ||
                (Tools::getValue('tab') == 'AdminAddresses' && Tools::getValue('realedit') == '1') ||
                Tools::getValue('controller') == 'AdminSuppliers' ||
                Tools::getValue('controller') == 'AdminManufacturers' ||
                Tools::getValue('controller') == 'AdminWarehouses')) {
            $this->context->controller->addCSS(_PS_MODULE_DIR_.$this->name.'/views/css/nladdressfiller.css', 'all');
            $this->context->smarty->assign([
                'nladdressfiller_nl_iso'      => (int) Country::getByIso('NL'),
                'nladdressfiller_module_link' => $this->context->link->getModuleLink($this->name, 'postcodeajax', [], true),
                'nladdressfiller_enable_man'  => !Configuration::get(static::BACKOFFICE_DISABLE_MANUAL_FILL),
            ]);

            return $this->display(__FILE__, '/views/templates/admin/nladdressfillerheader.tpl');
        }

        return '';
    }

    /**
     * Get version of module
     *
     * @param string $module Module name
     *
     * @return string Module version
     * @throws PrestaShopException
     */
    protected function getModuleVersion($module)
    {
        $sql = new DbQuery();
        $sql->select('m.`version`');
        $sql->from('module', 'm');
        $sql->where('m.`name` = \''.pSQL($module).'\'');

        return Db::getInstance(_PS_USE_SQL_SLAVE_)->getValue($sql);
    }
}
