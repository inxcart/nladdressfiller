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
{extends file="helpers/form/form.tpl"}

{block name="input"}
  {if $input.type == 'maintenance_ip'}
    <script type="text/javascript">
      function addRemoteAddr() {ldelim}
        var length = $('input[name={$input.name|escape:'htmlall':'UTF-8'}]').prop('value').length;
        if (length > 0)
          $('input[name={$input.name|escape:'htmlall':'UTF-8'}]').prop('value', $('input[name={$input.name|escape:'htmlall':'UTF-8'}]').prop('value') + ',{Tools::getRemoteAddr()|escape:'javascript':'UTF-8'}');
        else
          $('input[name={$input.name|escape:'htmlall':'UTF-8'}]').prop('value', '{Tools::getRemoteAddr()|escape:'javascript':'UTF-8'}');
        {rdelim}
    </script>
    <div class="col-lg-9">
      <div class="row">
        <div class="col-lg-8">
          <input type="text" id="{$input.name|escape:'htmlall':'UTF-8'}"
                 name="{$input.name|escape:'htmlall':'UTF-8'}"
                 value="{$fields_value[$input.name]|escape:'htmlall':'UTF-8'}"/>
        </div>
        <div class="col-lg-1">
          <button type="button" class="btn btn-default" onclick="addRemoteAddr();"><i
                    class="icon-plus"></i> {l s='Add my IP' mod='mppostcode'}</button>
        </div>
      </div>
    </div>
  {else}
    {$smarty.block.parent}
  {/if}
{/block}
