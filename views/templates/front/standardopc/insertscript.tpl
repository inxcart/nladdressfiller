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
<script type="text/javascript" data-cfsync="false">
  (function () {
    function initFiller() {
      if (typeof $ === 'undefined') {
        setTimeout(initFiller, 100);

        return;
      }

      window.nladdressfiller = window.nladdressfiller || { };
      window.nladdressfiller.nlIso = '{$nladdressfiller_nl_iso|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.moduleLink = '{$nladdressfiller_module_link|escape:'javascript':'UTF-8'}';
      window.nladdressfiller.logged = {if isset($nladdressfiller_logged) && $nladdressfiller_logged}true{else}false{/if};
      window.nladdressfiller.resultsColor = 'black';
      window.nladdressfiller.animDuration = 'fast';

      function deliveryAutoFill() {
        $('#nlaf_manualbtn').show();
        $('#nlaf_autobtn').hide();

        $('#nlaf_autocomplete').show(function () {
          $('#address1').parent().hide();
          $('#postcode').parent().hide();
          $('#city').parent().hide();
          $('#address1').attr('type', 'hidden');
          $('#postcode').attr('type', 'hidden');
          $('#city').attr('type', 'hidden');
        });
      }

      function deliveryManualFill() {
        $('#nlaf_manualbtn').hide();
        $('#nlaf_autobtn').show();

        $('#nlaf_autocomplete').hide(function () {
          $('#address1').attr('type', 'text');
          $('#postcode').attr('type', 'text');
          $('#city').attr('type', 'text');
          $('#address1').parent().show();
          $('#postcode').parent().show();
          $('#city').parent().show();
        });
      }

      function invoiceAutoFill() {
        $('#nlaf_manualbtn_invoice').show();
        $('#nlaf_autobtn_invoice').hide();
        $('#nlaf_autocomplete_invoice').show(function () {
          $('#address1_invoice').parent().hide();
          $('#postcode_invoice').parent().hide();
          $('#city_invoice').parent().hide();
        });
      }

      function invoiceManualFill() {
        $('#nlaf_manualbtn_invoice').hide();
        $('#nlaf_autobtn_invoice').show();
        $('#nlaf_autocomplete_invoice').hide(function () {
          $('#address1_invoice').parent().show();
          $('#postcode_invoice').parent().show();
          $('#city_invoice').parent().show();
        });
      }

      function initMP() {
        // Show/hide autofill
        var deliveryPostcodeHider;
        var invoicePostcodeHider;

        // If selected country is 'nl'
        if ($('#id_country').val() == window.nladdressfiller.nlIso) {
          $('#nladdressfiller').show(window.nladdressfiller.animDuration);
          deliveryAutoFill();
        } else {
          if (typeof deliveryPostcodeHider !== 'undefined') {
            clearTimeout(deliveryPostcodeHider);
          }
          $('#nladdressfiller').hide(window.nladdressfiller.animDuration);
          deliveryManualFill();
        }

        // If selected country is 'nl'
        if ($('#id_country_invoice').val() == window.nladdressfiller.nlIso) {
          $('#nladdressfiller_invoice').show(window.nladdressfiller.animDuration);
          invoiceAutoFill();
        } else {
          if (typeof invoicePostcodeHider !== 'undefined') {
            clearTimeout(invoicePostcodeHider);
          }
          $('#nladdressfiller_invoice').hide(window.nladdressfiller.animDuration);
          invoiceManualFill();
        }

        // If country selectbox changes
        $('#id_country').change(function () {
          console.log($(this).val());
          if ($(this).val() == window.nladdressfiller.nlIso) {
            $('#nladdressfiller').show(window.nladdressfiller.animDuration);
            deliveryAutoFill();
            setTimeout(function () {
              $('#nladdressfiller').show();
            }, 100);
          }
          else {
            $('#nladdressfiller').hide(window.nladdressfiller.animDuration);
            deliveryManualFill();
          }
        });

        // If invoice country selectbox changes
        $('#id_country_invoice').change(function () {
          if ($(this).val() == window.nladdressfiller.nlIso) {
            $('#nladdressfiller_invoice').show(window.nladdressfiller.animDuration);
            invoiceAutoFill();
            setTimeout(function () {
              $('#nladdressfiller_invoice').show();
            }, 100);
          }
          else {
            $('#nladdressfiller_invoice').hide(window.nladdressfiller.animDuration);
            invoiceManualFill();
          }
        });

        // If manual checkbox changes
        $('#nlaf_manualbtn')
          .click(deliveryManualFill);
        $('#nlaf_autobtn')
          .click(deliveryAutoFill);
        $('#nlaf_manualbtn_invoice')
          .click(invoiceManualFill);
        $('#nlaf_autobtn_invoice')
          .click(invoiceAutoFill);

        // Delay function
        var delay = (function () {
          var timer = 0;
          return function (callback, ms) {
            clearTimeout(timer);
            timer = setTimeout(callback, ms);
          };
        })();

        if (/[?&]id_address/.test(location.href)) {
          setTimeout(deliveryManualFill, 100);
        } else {
          deliveryAutoFill();
        }
        if (/[?&]id_address_invoice/.test(location.href)) {
          setTimeout(invoiceManualFill, 100);
        } else {
          invoiceAutoFill();
        }

        $('.mpauto').keyup(function () {
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
                toevoeging: addition
              },
              success: function (data) {
                if (typeof data.result !== 'undefined' &&
                  typeof data.result.street !== 'undefined' &&
                  typeof data.result.houseNumber !== 'undefined' &&
                  typeof data.result.city !== 'undefined') {
                  $('#address1').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                  $('#city').val(data.result['city']);
                  var formatted_postcode = data.result['postcode'];
                  formatted_postcode = formatted_postcode.slice(0, 4) + ' ' + formatted_postcode.slice(4);
                  $('#postcode').val(formatted_postcode);
                  $('#mpresults').html(
                    data.result['street'] + ' ' + data.result['houseNumber'] +
                    addition + '<br>' +
                    data.result['postcode'] + '<br>' + data.result['city']
                  );
                } else if (data.result['message']) {
                  $('#mpresults').html(
                    '<div class="pcnl_error">' + data.result['message'] +
                    '</div>'
                  );
                }
              }
            });
          }
        });

        $('.mpauto_invoice').keyup(function () {
          var postcode = $('#nlaf_postcode_invoice').val().replace(/\s/g, "");
          var housenr = $('#nlaf_housenr_invoice').val().replace(/(^\d+)(.*?$)/i, '$1');
          var addition = $('#nlaf_housenr_invoice').val().replace(/(^\d+)(.*?$)/i, '$2');

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
                    $('#address1_invoice').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                    $('#city_invoice').val(data.result['city']);
                    $('#postcode_invoice').val(data.result['postcode']);
                    $('#mpresults_invoice').css('color', window.nladdressfiller.resultsColor);
                    $('#mpresults_invoice').val(
                      data.result['street'] + ' ' + data.result['houseNumber'] +
                      addition + ', ' + data.result['postcode'] +
                      ', ' + data.result['city']
                    );
                  } else if (data.result['message']) {
                    $('#mpresults_invoice').html(
                      '<div class="pcnl_error">' + data.result['message'] +
                      '</div>'
                    );
                  }
              }
            });
          }
        });
      }

      $(document).ready(function () {
        $('#address1').parent().before('{{include file="./nladdressfiller-delivery-html.tpl"}|escape:'javascript':'UTF-8'}');
        $('#address1_invoice').parent().before('{{include file="./nladdressfiller-invoice-html.tpl"}|escape:'javascript':'UTF-8'}');
        initMP();
        if (window.nladdressfiller.logged == '1') {
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
<script type="text/javascript">

</script>
