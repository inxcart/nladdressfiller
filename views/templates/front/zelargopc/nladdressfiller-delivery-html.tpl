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
  <p class="required text nlaf_autocomplete">
    <label for="nlaf_postcode">
      {l s='Postcode' mod='nladdressfiller'}
      <sup>*</sup>
    </label>
    <input class="text mpauto nlaf_postcode" type="text" id="nlaf_postcode" name="nlaf_postcode"
           placeholder="{$nladdressfiller_zelarg_postcode|escape:'htmlall':'UTF-8'}">
    <span class="validity"></span>
    <span class="sample_text ex_blur" style="display:none;">{$nladdressfiller_zelarg_postcode|escape:'htmlall':'UTF-8'}</span>
  </p>
  <p class="required text nlaf_autocomplete">
    <label for="nlaf_housenr">
      {l s='House number + addition' mod='nladdressfiller'}
      <sup>*</sup>
    </label>
    <input class="text mpauto" type="text" id="nlaf_housenr" name="nlaf_housenr"
           placeholder="{$nladdressfiller_zelarg_housenr|escape:'htmlall':'UTF-8'}">
    <span class="validity"></span>
    <span class="sample_text ex_blur" style="display:none;">{$nladdressfiller_zelarg_housenr|escape:'htmlall':'UTF-8'}</span>
  </p>
  <p class="text mpresults-container">
    <label for="mpresults"></label>
    <input class="ui-input-text ui-body-c" type="text" id="mpresults" style="opacity: 0.7;pointer-events: none;">
  </p>
  {if $nladdressfiller_enable_man}
    <p class="text nlaf_autocomplete">
      <label for="nlaf_manualbtn"></label>
      <button type="button" class="button mpbtn" id="nlaf_manualbtn" tabindex="-1">
        {l s='Enter address manually' mod='nladdressfiller'}
      </button>
    </p>
    <p class="text nlaf_manualcomplete">
      <label for="nlaf_autobtn"></label>
      <button type="button" class="button mpbtn" id="nlaf_autobtn" tabindex="-1">
        {l s='Enter address automatically' mod='nladdressfiller'}
      </button>
    </p>
  {/if}
{/strip}
