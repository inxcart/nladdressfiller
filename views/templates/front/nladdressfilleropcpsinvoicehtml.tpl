{*
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
*}
{strip}
  <div id="invoice_nladdressfiller">
    <div id="nlaf_invoice_autocomplete">
      <tr id="mp_invoice_postcode">
        <td>
          <p class="text">
            <label for="invoice_nlaf_postcode">{l s='Postcode:' mod='nladdressfiller'}</label>
            <sup id="sup_delivery_mp_postcode">*</sup>
            <input class="form-control invoice_mpauto" type="text" id="invoice_nlaf_postcode">
        </td>
      </tr>
      <tr id="mp_invoice_housenr">
        <td>
          <p class="text">
            <label for="invoice_nlaf_housenr">{l s='House number + addition:' mod='nladdressfiller'}</label>
            <sup id="sup_invoice_mp_housenr">*</sup>
            <input class="form-control invoice_mpauto" type="text" id="invoice_nlaf_housenr">
        </td>
      </tr>
      <p class="textarea mpresultsarea">
        <label for="invoice_mpresults"></label>
        <span id="invoice_mpresults" class="text">
            </span>
      </p>
    </div>
    {if $nladdressfiller_enable_man}
      <p class="text">
        <label for="invoice_nlaf_manualbtn"></label>
        <button type="button" class="mpbtn" id="invoice_nlaf_manualbtn" tabindex="-1">
          {l s='Enter address manually' mod='nladdressfiller'}
        </button>

      </p>
      <p class="text">
        <label for="invoice_nlaf_autobtn"></label>
        <button type="button" class="mpbtn" id="invoice_nlaf_autobtn" tabindex="-1">
          {l s='Enter address automatically' mod='nladdressfiller'}
        </button>
      </p>
    {/if}
  </div>
{/strip}
