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
<script type="text/javascript">
  (function () {
    function initFiller() {
      if (window.location.hash === '#account-creation') {
        window.location.hash = ''; // You can't fool me! Reset the hash so I can detect when the account creation form is opened
      }

      if (typeof $ === 'undefined') {
        setTimeout(initFiller, 100);

        return;
      }

      window.nladdressfiller = window.nladdressfiller || { };
      window.nladdressfiller.nlIso = '{$nladdressfiller_nl_iso|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.moduleLink = '{$nladdressfiller_module_link|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.lastCall = 0;
      window.nladdressfiller.resultsColor = 'black';
      window.nladdressfiller.animDuration = 'fast';

      function autoFill(invoice) {
        $('#nlaf_manualbtn' + (invoice ? '_invoice' : '')).closest('.nlaf-btn-group').show();
        $('#nlaf_autobtn' + (invoice ? '_invoice' : '')).closest('.nlaf-btn-group').hide();

        $('.nlaf_autocomplete' + (invoice ? '_invoice' : '')).show(window.nladdressfiller.animDuration, function () {
          var $address1 = $('#address1' + (invoice ? '_invoice' : ''));
          var $postcode = $('#postcode' + (invoice ? '_invoice' : ''));
          var $city = $('#city' + (invoice ? '_invoice' : ''));
          $address1.closest('.form-group').hide(window.nladdressfiller.animDuration);
          $postcode.closest('.form-group').hide(window.nladdressfiller.animDuration);
          $city.closest('.form-group').hide(window.nladdressfiller.animDuration);
          $address1.attr('type', 'hidden');
          $postcode.attr('type', 'hidden');
          $city.attr('type', 'hidden');
        });
      }

      function manualFill(invoice) {
        $('#nlaf_manualbtn' + (invoice ? '_invoice' : '')).closest('.nlaf-btn-group').hide();
        $('#nlaf_autobtn' + (invoice ? '_invoice' : '')).closest('.nlaf-btn-group').show();

        $('.nlaf_autocomplete' + (invoice ? '_invoice' : '')).hide(window.nladdressfiller.animDuration, function () {
          var $address1 = $('#address1' + (invoice ? '_invoice' : ''));
          var $postcode = $('#postcode' + (invoice ? '_invoice' : ''));
          var $city = $('#city' + (invoice ? '_invoice' : ''));
          $address1.attr('type', 'text');
          $postcode.attr('type', 'text');
          $city.attr('type', 'text');
          $address1.closest('.form-group').show(window.nladdressfiller.animDuration);
          $postcode.closest('.form-group').show(window.nladdressfiller.animDuration);
          $city.closest('.form-group').show(window.nladdressfiller.animDuration);
        });
      }


      function initMP (invoice) {
        var postcodehider;
        var $idCountry = $('#id_country' + (invoice ? '_invoice' : ''));
        var $nlAddressFiller = $('#nladdressfiller' + (invoice ? '_invoice' : ''));

        // Show/hide autofill
        $('#address1' + (invoice ? '_invoice' : '')).closest('.form-group').before($nlAddressFiller);
        $('#lastname' + (invoice ? '_invoice' : '')).closest('.form-group').after($('#uniform-id_country').closest('.form-group'));

        // If selected country is 'nl'
        if ($idCountry.val() == window.nladdressfiller.nlIso) {
          $nlAddressFiller.show(window.nladdressfiller.animDuration);
          autoFill(invoice);

        } else {
          if (typeof postcodehider !== 'undefined') {
            clearTimeout(postcodehider);
          }
          $nlAddressFiller.hide(window.nladdressfiller.animDuration);
          manualFill(invoice);
        }

        // If country selectbox changes
        $idCountry.change(function () {
          if ($(this).val() == window.nladdressfiller.nlIso) {
            $nlAddressFiller.show(window.nladdressfiller.animDuration);
            autoFill();
            setTimeout(function () {
              $('#postcode' + (invoice ? '_invoice' : '')).closest('.form-group').hide();
            }, 1000);
          }
          else {
            $('#nladdressfiller' + (invoice ? '_invoice' : '')).hide(window.nladdressfiller.animDuration);
            manualFill(invoice);
          }
        });

        $nlAddressFiller.show();

        // Capture results color
        window.nladdressfiller.resultsColor = $('#mpresults' + (invoice ? '_invoice' : '')).css('color');

        // If manual checkbox changes
        $('#nlaf_manualbtn' + (invoice ? '_invoice' : ''))
          .click(function () { manualFill(invoice); });
        $('#nlaf_autobtn' + (invoice ? '_invoice' : ''))
          .click(function () { autoFill(invoice); });

        if (/[?&]id_address/.test(location.href)) {
          setTimeout(function () { manualFill(invoice); }, 100);
        } else {
          autoFill(invoice);
        }

        $('.mpauto' + (invoice ? '_invoice' : '')).keyup(function () {
          var $nlAfPostcode = $('#nlaf_postcode' + (invoice ? '_invoice' : ''));
          var $nlAfHouseNr = $('#nlaf_housenr' + (invoice ? '_invoice' : ''));
          var postcode = $nlAfPostcode.val().replace(/\s/g, "");
          var housenr = $nlAfHouseNr.val().replace(/(^\d+)(.*?$)/i, '$1');
          var addition = $nlAfHouseNr.val().replace(/(^\d+)(.*?$)/i, '$2');

          if (postcode.length >= 6 && housenr.length) {
            if (window.nladdressfiller.xhr && typeof window.nladdressfiller.xhr.abort === 'function') {
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
                  $('#address1' + (invoice ? '_invoice' : '')).val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                  $('#city' + (invoice ? '_invoice' : '')).val(data.result['city']);
                  $('#postcode' + (invoice ? '_invoice' : '')).val(data.result['postcode']);
                  $('#mpresults' + (invoice ? '_invoice' : '')).html(
                    data.result['street'] + ' ' + data.result['houseNumber'] + addition + '<br>' +
                    data.result['postcode'] + '<br>' + data.result['city']
                  );
                } else if (data.result['message']) {
                  $('#mpresults' + (invoice ? '_invoice' : '')).html('<div class="pcnl_error">' + data.result['message'] + '</div>');
                }
              }
            });
          }
        });
      }

      $(document).ready(function () {
        function tryInitInvoice() {
          if (!$('#address1_invoice').is(':visible')) {
            console.log('swagger');
            setTimeout(tryInitInvoice, 100);

            return;
          }

          $('#address1_invoice').after('{{include file="./nladdressfillerinvoicehtml.tpl"}|escape:'javascript':'UTF-8'}');
          initMP(true);
          autoFill(true);
        }

        $('#address1').after('{{include file="./nladdressfillerhtml.tpl"}|escape:'javascript':'UTF-8'}');
        initMP(false);
        autoFill(false);
        $(window).on('hashchange', function () {
          if (window.location.hash === '#account-creation') {
            // Just apply the same changes after the page content was replaced with the account creation form
            $('#address1').after('{{include file="./nladdressfillerhtml.tpl"}|escape:'javascript':'UTF-8'}');
            initMP(false);
            autoFill(false);
          }
        });

        $('#uniform-invoice_address, #invoice_address').change(function () {
          var $target = $(this);
          if ($target[0].tagName !== 'INPUT') {
            $target = $target.find('input');
          }
          if (!$target.attr('checked')) {
            return;
          }

          tryInitInvoice();
        });
      });
    }

    initFiller();
  }());
</script>
