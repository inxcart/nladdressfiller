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
  <p class="required text mppc_autocomplete_invoice">
    <label for="mppc_postcode_invoice">{l s='Postcode' mod='nladdressfiller'}
      <sup>*</sup>
    </label>
    <input class="is_required form-control mpauto_invoice mppc_postcode_invoice" type="text"
           id="mppc_postcode_invoice" name="mppc_postcode_invoice"
           placeholder="{$nladdressfiller_zelarg_postcode|escape:'htmlall':'UTF-8'}">
    <span class="validity"></span>
    <span class="sample_text ex_blur" style="display:none;">{$nladdressfiller_zelarg_postcode|escape:'htmlall':'UTF-8'}</span>
  </p>
  <p class="required text mppc_autocomplete_invoice">
    <label for="mppc_housenr_invoice">{l s='House number + addition' mod='nladdressfiller'}
      <sup>*</sup>
    </label>
    <input class="is_required form-control mpauto_invoice" type="text" id="mppc_housenr_invoice"
           name="mppc_housenr_invoice" placeholder="{$nladdressfiller_zelarg_housenr|escape:'htmlall':'UTF-8'}">
    <span class="validity"></span>
  </p>
  <p class="text mpresults-invoice-container">
    <label for="mpresults_invoice"></label>
    <input class="ui-input-text ui-body-c" type="text" id="mpresults_invoice" style="opacity: 0.7;pointer-events: none;">
  </p>
  {if $nladdressfiller_enable_man}
    <p class="text mppc_autocomplete_invoice">
      <label for="mppc_manualbtn_invoice"></label>
      <button type="button" class="button mpbtn" id="mppc_manualbtn_invoice" tabindex="-1">
        {l s='Enter address manually' mod='nladdressfiller'}
      </button>
    </p>
    <p class="text mppc_manualcomplete_invoice">
      <label for="mppc_autobtn_invoice"></label>
      <button type="button" class="button mpbtn" id="mppc_autobtn_invoice" tabindex="-1">
        {l s='Enter address automatically' mod='nladdressfiller'}
      </button>
    </p>
  {/if}
{/strip}
