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
  <div id="nladdressfiller_invoice">
    <div class="nlaf_autocomplete_invoice">
      <div class="required form-group" style="display: block;">
        <label for="nlaf_postcode_invoice">{l s='Postcode' mod='nladdressfiller'}
          <sup>*</sup>
        </label>
        <input class="is_required form-control mpauto_invoice" type="text" id="nlaf_postcode_invoice">
      </div>
      <div class="required form-group" style="display: block;">
        <label for="nlaf_housenr_invoice">{l s='House number + addition' mod='nladdressfiller'}
          <sup>*</sup>
        </label>
        <input class="is_required form-control mpauto_invoice" type="text" id="nlaf_housenr_invoice">
      </div>
      <br/>
      <div class="nlaf-form-group">
        <div class="well nladdressfiller-well">
          <span id="mpresults_invoice" class="mpresults16"></span>
        </div>
      </div>
      <div class="clearfix"></div>
    </div>
    {if $nladdressfiller_enable_man || Tools::isSubmit('id_address')}
      <div class="nlaf-btn-group">
        <button type="button" class="btn btn-default" id="nlaf_manualbtn_invoice" tabindex="-1">
          <span>{l s='Enter address manually' mod='nladdressfiller'}&nbsp;<span class="icon-chevron-right right"></span></span>
        </button>
      </div>
      <div class="nlaf-btn-group">
        <br/>
        <button type="button" class="btn btn-default" id="nlaf_autobtn_invoice" tabindex="-1">
          <span>{l s='Enter address automatically' mod='nladdressfiller'}&nbsp;<span class="icon-chevron-right right"></span></span>
        </button>
      </div>
    {/if}
    <br/>
  </div>
{/strip}
