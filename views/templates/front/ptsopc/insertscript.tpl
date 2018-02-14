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
<script type="text/javascript">
  (function () {
    function initFiller() {
      if (typeof $ === 'undefined') {
        setTimeout(initFiller, 100);

        return;
      }

      window.nladdressfiller = window.nladdressfiller || { };
      window.nladdressfiller.xhr;
      window.nladdressfiller.nlIso = '{$nladdressfiller_nl_iso|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.moduleLink = '{$nladdressfiller_module_link|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.logged = {if isset($nladdressfiller_logged) && $nladdressfiller_logged}true{else}false{/if};
      window.nladdressfiller.deliveryAddressField = '{$nladdressfiller_delivery_address_field|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.deliveryPostcodeField = '{$nladdressfiller_delivery_postcode_field|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.deliveryCityField = '{$nladdressfiller_delivery_city_field|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.invoiceAddressField = '{$nladdressfiller_invoice_address_field|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.invoicePostcodeField = '{$nladdressfiller_invoice_postcode_field|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.invoiceCityField = '{$nladdressfiller_invoice_city_field|escape:'javascript':'UTF-8'}';

      function deliveryAutoFill() {
        $(window.nladdressfiller.deliveryAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.hide();
        $(window.nladdressfiller.deliveryPostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.hide();
        $(window.nladdressfiller.deliveryCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.hide();
        $(window.nladdressfiller.deliveryAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'hidden');
        $(window.nladdressfiller.deliveryPostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'hidden');
        $(window.nladdressfiller.deliveryCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'hidden');

        $('#delivery_nlaf_manualbtn').show();
        $('#delivery_nlaf_autobtn').hide();

        $('#nlaf_delivery_autocomplete').show();
      }

      function deliveryManualFill() {
        $(window.nladdressfiller.deliveryAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'text');
        $(window.nladdressfiller.deliveryPostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'text');
        $(window.nladdressfiller.deliveryCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'text');
        $(window.nladdressfiller.deliveryAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.show();
        $(window.nladdressfiller.deliveryPostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.show();
        $(window.nladdressfiller.deliveryCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.show();

        $('#delivery_nlaf_manualbtn').hide();
        $('#delivery_nlaf_autobtn').show();

        $('#nlaf_delivery_autocomplete').hide();
      }

      function invoiceAutoFill() {
        $(window.nladdressfiller.invoiceAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'hidden');
        $(window.nladdressfiller.invoicePostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'hidden');
        $(window.nladdressfiller.invoiceCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'hidden');
        $(window.nladdressfiller.invoiceAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.hide();
        $(window.nladdressfiller.invoicePostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.hide();
        $(window.nladdressfiller.invoiceCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.hide();


        $('#invoice_nlaf_manualbtn').show();
        $('#invoice_nlaf_autobtn').hide();

        $('#nlaf_invoice_autocomplete').show();
      }

      function invoiceManualFill() {
        $(window.nladdressfiller.invoiceAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'text');
        $(window.nladdressfiller.invoicePostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'text');
        $(window.nladdressfiller.invoiceCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.attr('type', 'text');
        $(window.nladdressfiller.invoiceAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.show();
        $(window.nladdressfiller.invoicePostcodeField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.show();
        $(window.nladdressfiller.invoiceCityField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.show();

        $('#invoice_nlaf_manualbtn').hide();
        $('#invoice_nlaf_autobtn').show();

        $('#nlaf_invoice_autocomplete').hide();
      }


      function initMP() {
        {* Show/hide autofill *}
        $(window.nladdressfiller.deliveryAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.before($('#delivery_nladdressfiller'));
        $(window.nladdressfiller.invoiceAddressField){if isset($nladdressfiller_parent) && $nladdressfiller_parent}.parent(){/if}.before($('#invoice_nladdressfiller'));
        {* $('#delivery_lastname').parent().after($('#uniform-id_country').parent()); *}
        {* $('#invoice_lastname').parent().after($('#uniform-id_country').parent()); *}

        var deliveryPostcodeHider;
        var invoicePostcodeHider;

        {* If selected country is 'nl' *}
        if ($('#delivery_id_country').val() == window.nladdressfiller.nlIso) {
          $('#delivery_nladdressfiller').show();
          deliveryAutoFill();
        } else {
          if (typeof deliveryPostcodeHider !== 'undefined') {
            clearTimeout(deliveryPostcodeHider);
          }
          $('#delivery_nladdressfiller').hide();
          deliveryManualFill();
        }

        {* If selected country is 'nl' *}
        if ($('#invoice_id_country').val() == window.nladdressfiller.nlIso) {
          $('#invoice_nladdressfiller').show();
          invoiceAutoFill();
        } else {
          if (typeof invoicePostcodeHider !== 'undefined') {
            clearTimeout(invoicePostcodeHider);
          }
          $('#invoice_nladdressfiller').hide();
          invoiceManualFill();
        }

        {* If country selectbox changes *}
        $('#delivery_id_country').change(function () {
          if ($(this).val() == window.nladdressfiller.nlIso) {
            $('#delivery_nladdressfiller').show();
            deliveryAutoFill();
            setTimeout(function () {
              $('#delivery_nladdressfiller').show();
            }, 100);
          } else {
            $('#delivery_nladdressfiller').hide();
            deliveryManualFill();
          }
        });

        {* If invoice country selectbox changes *}
        $('#invoice_id_country').change(function () {
          if ($(this).val() == window.nladdressfiller.nlIso) {
            $('#invoice_nladdressfiller').show();
            invoiceAutoFill();
            setTimeout(function () {
              $('#invoice_nladdressfiller').show();
            }, 100);
          }
          else {
            $('#invoice_nladdressfiller').hide();
            invoiceManualFill();
          }
        });

        $('#delivery_nladdressfiller').show();
        $('#invoice_nladdressfiller').show();

        {* If manual checkbox changes *}
        $('#delivery_nlaf_manualbtn').click(deliveryManualFill);
        $('#delivery_nlaf_autobtn').click(deliveryAutoFill);
        $('#invoice_nlaf_manualbtn').click(invoiceManualFill);
        $('#invoice_nlaf_autobtn').click(invoiceAutoFill);

        if (/[?&]delivery_id_address/.test(location.href)) {
          setTimeout(deliveryManualFill, 100);
        } else {
          deliveryAutoFill();
        }
        if (/[?&]invoice_id_address/.test(location.href)) {
          setTimeout(invoiceManualFill, 100);
        } else {
          invoiceAutoFill();
        }

        $('.delivery_mpauto').keyup(function () {
          var postcode = $('#delivery_nlaf_postcode').val().replace(/\s/g, "");
          var housenr = $('#delivery_nlaf_housenr').val().replace(/(^\d+)(.*?$)/i, '$1');
          var addition = $('#delivery_nlaf_housenr').val().replace(/(^\d+)(.*?$)/i, '$2');

          if (postcode.length >= 6 && housenr.length != 0) {
            if (window.nladdressfiller.xhr != null && typeof window.nladdressfiller.xhr.abort === 'function') {
              window.nladdressfiller.xhr.abort();
            }
            window.nladdressfiller.xhr = $.ajax({
              url: window.nladdressfiller.moduleLink,
              type: 'POST',
              dataType: 'json',
              data: {
                postcode: postcode,
                huisnummer: housenr,
                toevoeging: addition
              },
              success: function (data) {
                if (typeof data.result !== 'undefined' &&
                  typeof data.result.street !== 'undefined' &&
                  typeof data.result.houseNumber !== 'undefined' &&
                  typeof data.result.city !== 'undefined') {
                  $('#delivery_address1').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                  $('#delivery_city').val(data.result['city']);
                  $('#delivery_postcode').val(data.result['postcode']);
                  $('#delivery_mpresults').html(data.result['street'] + ' ' + data.result['houseNumber'] + addition + '<br>' + data.result['postcode'] + '<br>' + data.result['city']);
                } else if (data.result['message']) {
                  $('#delivery_mpresults').html('<div class="pcnl_error">' + data.result['message'] + '</div>');
                }
              }
            });

          }
        });

        $('.invoice_mpauto').keyup(function () {
          var postcode = $('#invoice_nlaf_postcode').val().replace(/\s/g, "");
          var housenr = $('#invoice_nlaf_housenr').val().replace(/(^\d+)(.*?$)/i, '$1');
          var addition = $('#invoice_nlaf_housenr').val().replace(/(^\d+)(.*?$)/i, '$2');

          if (postcode.length >= 6 && housenr.length != 0) {
            if (window.nladdressfiller.xhr != null && typeof window.nladdressfiller.xhr.abort === 'function') {
              window.nladdressfiller.xhr.abort();
            }
            window.nladdressfiller.xhr = $.ajax({
              url: window.nladdressfiller.moduleLink,
              type: 'POST',
              dataType: 'json',
              data: {
                postcode: postcode,
                huisnummer: housenr,
                toevoeging: addition
              },
              success: function (data) {
                if (typeof data.result !== 'undefined' &&
                  typeof data.result.street !== 'undefined' &&
                  typeof data.result.houseNumber !== 'undefined' &&
                  typeof data.result.city !== 'undefined') {
                  $('#invoice_address1').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                  $('#invoice_city').val(data.result['city']);
                  $('#invoice_postcode').val(data.result['postcode']);
                  $('#invoice_mpresults').html(data.result['street'] + ' ' + data.result['houseNumber'] + addition + '<br>' + data.result['postcode'] + '<br>' + data.result['city']);
                } else if (data.result['message']) {
                  $('#invoice_mpresults').html('<div class="pcnl_error">' + data.result['message'] + '</div>');
                }
              }
            });
          }
        }
      }


      $(document).ready(function () {
        {if $nladdressfiller_opc_bootstrap}
          $(window.nladdressfiller.deliveryAddressField).before('{{include file="./nladdressfiller-delivery-html.tpl"}|escape:'javascript':'UTF-8'}');
          $(window.nladdressfiller.invoiceAddressField).before('{{include file="./nladdressfiller-invoice-html.tpl.tpl"}|escape:'javascript':'UTF-8'}');
        {else}
          $(window.nladdressfiller.deliveryAddressField).before('{{include file="./nladdressfiller-delivery-html.tpl"}|escape:'javascript':'UTF-8'}');
          $(window.nladdressfiller.invoiceAddressField).before('{{include file="./nladdressfiller-invoice-html.tpl.tpl"}|escape:'javascript':'UTF-8'}');
        {/if}

        initMP();
        if (window.nladdressfiller.logged) {
          deliveryManualFill();
          invoiceManualFill();
        } else {
          deliveryAutoFill();
          invoiceAutoFill();
        }
      });
    }

    initFiller();
  }());
</script>
