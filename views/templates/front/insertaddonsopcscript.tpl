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

      window.nladdressfiller = window.nladdressfiller || {};
      window.nladdressfiller.nlIso = '{$nladdressfiller_nl_iso|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.moduleLink = '{$nladdressfiller_module_link|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.resultsColor = 'black';
      window.nladdressfiller.animDuration = 'fast';

      function deliveryAutoFill() {
        $('#address1').parent().hide();
        $('#postcode').parent().hide();
        $('#city').parent().hide();
        $('#address1').attr('type', 'hidden');
        $('#postcode').attr('type', 'hidden');
        $('#city').attr('type', 'hidden');

        $('#nlaf_manualbtn').show();
        $('#nlaf_autobtn').hide();

        $('.nlaf_autocomplete').show();
        $('.nlaf_manualcomplete').hide();

        $('.mpresults-container').show();
      }

      function deliveryManualFill() {
        $('#address1').attr('type', 'text');
        $('#postcode').attr('type', 'text');
        $('#city').attr('type', 'text');
        $('#address1').parent().show();
        $('#postcode').parent().show();
        $('#city').parent().show();

        $('#nlaf_manualbtn').hide();
        $('#nlaf_autobtn').show();

        $('.nlaf_autocomplete').hide();
        $('.nlaf_manualcomplete').show();

        $('.mpresults-container').hide();
      }

      function invoiceAutoFill() {
        $('#address1_invoice').parent().hide();
        $('#postcode_invoice').parent().hide();
        $('#city_invoice').parent().hide();
        $('#address1_invoice').attr('type', 'hidden');
        $('#postcode_invoice').attr('type', 'hidden');
        $('#city_invoice').attr('type', 'hidden');

        $('#nlaf_manualbtn_invoice').show();
        $('#nlaf_autobtn_invoice').hide();

        $('.nlaf_autocomplete_invoice').show();
        $('.nlaf_manualcomplete_invoice').hide();

        $('.mpresults-invoice-container').show();
      }

      function invoiceManualFill() {
        $('#address1_invoice').attr('type', 'text');
        $('#postcode_invoice').attr('type', 'text');
        $('#city_invoice').attr('type', 'text');
        $('#address1_invoice').parent().show();
        $('#postcode_invoice').parent().show();
        $('#city_invoice').parent().show();

        $('#nlaf_manualbtn_invoice').hide();
        $('#nlaf_autobtn_invoice').show();

        $('.nlaf_autocomplete_invoice').hide();
        $('.nlaf_manualcomplete_invoice').show();

        $('.mpresults-invoice-container').hide();
      }

      /**
       * Check if delivery address filler needs to be shown
       */
      function checkDelivery(force_manual) {
        // If selected country is 'nl'
        if ($('#id_country').val() == window.nladdressfiller.nlIso) {
          $('#nladdressfiller').show();
          deliveryAutoFill();

        } else {
          if (typeof delivery_postcodehider !== 'undefined') {
            clearTimeout(delivery_postcodehider);
          }
          $('#nladdressfiller').hide();
          deliveryManualFill();
        }
      }

      /**
       * Check if invoice address filler needs to be shown
       */
      function checkInvoice() {
        // If selected country is 'nl'
        if ($('#id_country_invoice').val() == window.nladdressfiller.nlIso) {
          $('#nladdressfiller_invoice').show();
          invoiceAutoFill();
        } else {
          if (typeof invoice_postcodehider !== 'undefined') {
            clearTimeout(invoice_postcodehider);
          }
          $('#nladdressfiller_invoice').hide();
          invoiceManualFill();
        }
      }

      /**
       * Shows or hides delivery address filler
       *
       * @params $context Current jQuery DOM elem
       * @params force_manual Force manual fill
       */
      function checkShowDelivery($context, forceManual) {
        if ($context.val() == window.nladdressfiller.nlIso) {
          setTimeout(function () {
            if (forceManual) {
              deliveryManualFill();
            } else {
              deliveryAutoFill();
            }
          }, 100);
        } else {
          deliveryManualFill();
          $('.nlaf_autocomplete').hide();
          $('.nlaf_manualcomplete').hide();
        }
      }

      /**
       * Hides or shows invoice address filler
       *
       * @params $context Current jQuery DOM elem
       * @params force_manual Force manual fill
       */
      function checkShowInvoice($context, forceManual) {
        if ($context.val() == window.nladdressfiller.nlIso) {
          setTimeout(function () {
            if (forceManual) {
              invoiceManualFill();
            } else {
              invoiceAutoFill();
            }
          }, 100);
        } else {
          invoiceManualFill();
          $('.nlaf_autocomplete_invoice').hide();
          $('.nlaf_manualcomplete_invoice').hide();
        }
      }

      /**
       * Initialize address filler
       */
      function initMP() {
        checkShowDelivery($('#id_country'), ($('#address1').val()) ? true : false);
        checkShowInvoice($('#id_country_invoice'), ($('#address1_invoice').val()) ? true : false);

        // If country selectbox changes
        $('#id_country').change(function () {
          checkShowDelivery($(this), false);
        });

        // If invoice country selectbox changes
        $('#id_country_invoice').change(function () {
          checkShowInvoice($(this), false);
        });

        // If manual checkbox changes
        $('#nlaf_manualbtn').click(deliveryManualFill);
        $('#nlaf_autobtn').click(deliveryAutoFill);
        $('#nlaf_manualbtn_invoice').click(invoiceManualFill);
        $('#nlaf_autobtn_invoice').click(invoiceAutoFill);

        // Init validation
        fields_definition.nlaf_postcode = [true, 'isPostcode', 6];
        fields_definition.nlaf_postcode_invoice = [true, 'isPostcode', 6];

        $('#nlaf_postcode').blur(function () {
          validateFieldAndDisplayInline($(this));
        });
        $('#nlaf_housenr').blur(function () {
          validateFieldAndDisplayInline($(this));
        });
        $('#nlaf_postcode_invoice').blur(function () {
          validateFieldAndDisplayInline($(this));
        });
        $('#nlaf_housenr_invoice').blur(function () {
          validateFieldAndDisplayInline($(this));
        });

        $('.mpauto').change(function () {
          var postcode = $('#nlaf_postcode').val().replace(/\s/g, "");
          var housenr = $('#nlaf_housenr').val().replace(/(^\d+)(.*?$)/i, '$1');
          var addition = $('#nlaf_housenr').val().replace(/(^\d+)(.*?$)/i, '$2');

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
                toevoeging: addition,
              },
              success: function (data) {
                if (typeof data.result !== 'undefined' &&
                  typeof data.result.street !== 'undefined' &&
                  typeof data.result.houseNumber !== 'undefined' &&
                  typeof data.result.city !== 'undefined') {
                  $('#address1').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                  $('#city').val(data.result['city']);
                  $('#postcode').val(data.result['postcode']);
                  $('#mpresults').css('color', window.nladdressfiller.resultsColor);
                  $('#mpresults').val(
                    data.result['street'] + ' ' + data.result['houseNumber'] +
                    addition + ', ' + data.result['postcode'] +
                    ', ' + data.result['city']
                  );
                  deliveryManualFill();
                } else if (data.result['message']) {
                  $('#mpresults').css('color', 'red');
                  $('#mpresults').val(data.result['message']);
                }
              }
            });
          }
        });

        $('.mpauto_invoice').change(function () {
          var postcode = $('#nlaf_postcode_invoice').val().replace(/\s/g, "");
          var housenr = $('#nlaf_housenr_invoice').val().replace(/(^\d+)(.*?$)/i, '$1');
          var addition = $('#nlaf_housenr_invoice').val().replace(/(^\d+)(.*?$)/i, '$2');

          if (postcode.length >= 6 && housenr.length != 0) {
            if (window.nladdressfiller != null && typeof window.nladdressfiller.xhr.abort === 'function') {
              window.nladdressfiller.xhr.abort();
            }
            window.nladdressfiller.xhr = $.ajax({
              url: window.nladdressfiller.moduleLink,
              type: 'POST',
              dataType: 'json',
              data: {
                postcode: postcode,
                huisnummer: housenr,
                toevoeging: addition,
                lastCall: window.nladdressfiller.lastCall
              },
              success: function (data) {
                if (typeof data.result !== 'undefined' &&
                  typeof data.result.street !== 'undefined' &&
                  typeof data.result.houseNumber !== 'undefined' &&
                  typeof data.result.city !== 'undefined') {
                  $('#address1_invoice').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                  $('#city_invoice').val(data.result['city']);
                  $('#postcode_invoice').val(data.result['postcode']);
                  $('#mpresults_invoice').css('color', window.nladdressfiller.resultsColor);
                  $('#mpresults_invoice').val(
                    data.result['street'] + ' ' + data.result['houseNumber'] +
                    addition + ', ' + data.result['postcode'] + ', ' + data.result['city']
                  );
                  invoiceManualFill();
                } else if (data.result['message']) {
                  $('#mpresults_invoice').css('color', 'red');
                  $('#mpresults_invoice').val(data.result['message']);
                }
              }
            });
          }
        });

        $('#dlv_addresses').on('change', function () {
          setTimeout(function () {
            checkShowDelivery($('#id_country'), true);
          }, 610); // After hide/show anim (takes 600ms)
        });

        $('#inv_addresses, #invoice_address_checkbox').on('change', function () {
          setTimeout(function () {
            checkShowInvoice($('#id_country_invoice'));
          }, 610); // After hide/show anim (takes 600ms)
        });

        $('#invoice_address_checkbox').on('change', function () {
          setTimeout(function () {
            checkShowInvoice($('#id_country_invoice'));
          }, 610); // After hide/show anim (takes 600ms)
        });
      }

      $(document).ready(function () {
        $('#id_country').parent().after('{{include file="./nladdressfilleraddonsopcdeliveryhtml.tpl"}|escape:'javascript':'UTF-8'}');
        $('#id_country_invoice').parent().after('{{include file="./nladdressfilleraddonsopcinvoicehtml.tpl"}|escape:'javascript':'UTF-8'}');
        setTimeout(function () {
          initMP();
        }, 610); // After 600ms, the OPC tries to show the postcode
      });
    }

    initFiller();
  }());
</script>
