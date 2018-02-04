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
      window.nladdressfiller.lastCall = 0;
      window.nladdressfiller.resultsColor = 'black';
      window.nladdressfiller.animDuration = 'fast';

      function autoFill() {
        $('#nlaf_manualbtn').closest('.nlaf-btn-group').show();
        $('#nlaf_autobtn').closest('.nlaf-btn-group').hide();

        $('.nlaf_autocomplete').show(window.nladdressfiller.animDuration, function () {
          $('#address1').closest('.form-group').hide(window.nladdressfiller.animDuration);
          $('#postcode').closest('.form-group').hide(window.nladdressfiller.animDuration);
          $('#city').closest('.form-group').hide(window.nladdressfiller.animDuration);
          $('#address1').attr('type', 'hidden');
          $('#postcode').attr('type', 'hidden');
          $('#city').attr('type', 'hidden');
        });
      }

      function manualFill() {
        $('#nlaf_manualbtn').closest('.nlaf-btn-group').hide();
        $('#nlaf_autobtn').closest('.nlaf-btn-group').show();

        $('.nlaf_autocomplete').hide(window.nladdressfiller.animDuration, function () {
          $('#address1').attr('type', 'text');
          $('#postcode').attr('type', 'text');
          $('#city').attr('type', 'text');
          $('#address1').closest('.form-group').show(window.nladdressfiller.animDuration);
          $('#postcode').closest('.form-group').show(window.nladdressfiller.animDuration);
          $('#city').closest('.form-group').show(window.nladdressfiller.animDuration);
        });
      }


      var initMP = function () {
        // Show/hide autofill
        $('#address1').closest('.form-group').before($('#nladdressfiller'));
        $('#lastname').closest('.form-group').after($('#uniform-id_country').closest('.form-group'));

        var postcodehider;

        // If selected country is 'nl'
        if ($('#id_country').val() == window.nladdressfiller.nlIso) {
          $('#nladdressfiller').show(window.nladdressfiller.animDuration);
          autoFill();

        } else {
          if (typeof postcodehider !== 'undefined') {
            clearTimeout(postcodehider);
          }
          $('#nladdressfiller').hide(window.nladdressfiller.animDuration);
          manualFill();
        }

        // If country selectbox changes
        $('#id_country').change(function () {
          if ($(this).val() == window.nladdressfiller.nlIso) {
            $('#nladdressfiller').show(window.nladdressfiller.animDuration);
            autoFill();
            setTimeout(function () {
              $('#postcode').closest('.form-group').hide();
            }, 1000);
          }
          else {
            $('#nladdressfiller').hide(window.nladdressfiller.animDuration);
            manualFill();
          }
        });

        $('#nladdressfiller').show();

        // Capture results color
        window.nladdressfiller.resultsColor = $('#mpresults').css('color');

        // If manual checkbox changes
        $('#nlaf_manualbtn')
          .click(manualFill);
        $('#nlaf_autobtn')
          .click(autoFill);

        if (/[?&]id_address/.test(location.href)) {
          setTimeout(manualFill, 100);
        } else {
          autoFill();
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
                  $('#postcode').val(data.result['postcode']);
                  $('#mpresults').html(
                    data.result['street'] + ' ' + data.result['houseNumber'] + addition + '<br>' +
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
      };

      $(document).ready(function () {
        $('#address1').after('{{include file="./nladdressfillerhtml.tpl"}|escape:'javascript':'UTF-8'}');
        initMP();
        autoFill();
      });
    }

    initFiller();
  }());
</script>
