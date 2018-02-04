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
 *
*}
{strip}
  <div id="nladdressfiller" class="col-md-12">
    <div class="mppc_autocomplete">
      <div style="display: block;" class="form-group">
        <label class="control-label col-lg-3 required"
               for="mppc_postcode">{l s='Postcode' mod='nladdressfiller'}</label>
        <div class="col-lg-2">
          <input class="is_required form-control mpauto" type="text" id="mppc_postcode" required>
        </div>
      </div>
      <div style="display: block;" class="form-group">
        <label class="control-label col-lg-3 required"
               for="mppc_housenr"
        >
          {l s='House number + addition' mod='nladdressfiller'}
        </label>
        <div class="col-lg-2">
          <input class="is_required form-control mpauto" type="text" id="mppc_housenr" required>
        </div>
      </div>
      <div style="display: block;" class="form-group">
        <label class="control-label col-lg-3" for="mpresults">{l s='Address' mod='nladdressfiller'}</label>
        <div class="col-lg-6">
          <input class="form-control disabled" type="text" id="mpresults" disabled>
        </div>
      </div>
      <div class="clearfix"></div>
    </div>
    <div class="form-group">
      <label class="control-label col-lg-3" for="mppc_manualbtn"></label>
      <div class="col-lg-2">
        <a class="btn btn-default button button-small" id="mppc_manualbtn">
          <span>{l s='Fill out address manually' mod='nladdressfiller'} <i class="icon-chevron-right right"></i></span>
        </a>
        <a class="btn btn-default button button-small" id="mppc_autobtn">
          <span>{l s='Fill out address automatically' mod='nladdressfiller'} <i class="icon-chevron-right right"></i></span>
        </a>
      </div>
    </div>
  </div>
{/strip}
