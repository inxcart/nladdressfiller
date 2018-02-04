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
    exit;
}

/**
 * Class nladdressfillerPostcodeajaxModuleFrontController
 */
class nladdressfillerPostcodeajaxModuleFrontController extends ModuleFrontController
{
    /**
     * @throws PrestaShopDatabaseException
     * @throws PrestaShopException
     */
    public function init()
    {
        $postcode = Tools::getValue('postcode');
        $houseNumber = Tools::getValue('huisnummer');
        $houseNumberAddition = Tools::getValue('huisnummersuffix');

        if ($postcode && $houseNumber) {
            $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow(
                (new DbQuery())
                    ->select('*')
                    ->from('nladdressfiller_postcodes')
                    ->where('`postcode` = \''.pSQL($postcode).'\'')
                    ->where('`number` = '.(int) $houseNumber)
                    ->where('`suffix` = \''.pSQL($houseNumberAddition).'\' OR `suffix` = \'\'')
                    ->orderBy('`suffix` DESC')
            );
            if ($result) {
                die(json_encode([
                    'success' => true,
                    'result'  => [
                        'houseNumber'         => $result['number'],
                        'houseNumberAddition' => $result['suffix'],
                        'postcode'            => $result['postcode'],
                        'street'              => $result['street'],
                        'city'                => $result['city'],
                    ],
                ]));
            }
        }
        die(json_encode([
            'success' => false,
            'result'  => [
                'message' => $this->module->l('Address not found. Please try again.'),
            ],
        ]));
    }
}
