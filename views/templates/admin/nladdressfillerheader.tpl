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
  var nl_iso = '{$nl_iso|escape:'javascript':'UTF-8'}';
  var module_link = '{$module_link|escape:'javascript':'UTF-8'}';
  var postcodehtml = '{include file="./nladdressfillerhtml.tpl"}';
  var lastCall = $.now();

  $(document).ready(function () {
    // Show/hide autofill
    function autoFill() {
      $('#mppc_manualbtn').show();
      $('#mppc_autobtn').hide();

      $('.mppc_autocomplete').show();

      if ($('#address').length) {
        $('#address').parent().hide();
        $('#address').parent().prev().hide();
      } else {
        $('#address1').parent().hide();
        $('#address1').parent().prev().hide();
      }
      $('#postcode').parent().hide();
      $('#postcode').parent().prev().hide();
      $('#city').parent().hide();
      $('#city').parent().prev().hide();
      $('#address1').attr('type', 'hidden');
      $('#postcode').attr('type', 'hidden');
      $('#city').attr('type', 'hidden');

    }

    function manualFill() {
      $('#mppc_manualbtn').hide();
      $('#mppc_autobtn').show();

      $('.mppc_autocomplete').hide();

      $('#address1').attr('type', 'text');
      $('#postcode').attr('type', 'text');
      $('#city').attr('type', 'text');

      if ($('#address').length) {
        $('#address').parent().prev().show();
        $('#address').parent().show();
      } else {
        $('#address1').parent().prev().show();
        $('#address1').parent().show();
      }

      $('#postcode').parent().prev().show();
      $('#postcode').parent().show();
      $('#city').parent().show();
      $('#city').parent().prev().show();
    }

    if ($('#address').length) {
      $('#address').parent().prev().before(postcodehtml);
    } else {
      $('#address1').parent().prev().before(postcodehtml);
    }

    $('#lastname').parent().after($('#uniform-id_country').parent());

    // If selected country is 'nl'
    if ($('#id_country').val() == nl_iso) {
      $('#nladdressfiller').show();
    } else {
      $('#nladdressfiller').hide();
    }

    if ((/[?&]addaddress/.test(location.href) && !/[?&]realedit/.test(location.href)) || /[?&]addwarehouse/.test(location.href) || /[?&]addsupplier/.test(location.href)) {
      autoFill();
    } else {
      manualFill();
    }

    // If country selectbox changes
    $('#id_country').change(function () {
      if ($(this).val() == nl_iso) {
        $('#nladdressfiller').show();
        setTimeout(function () {
        }, 100);
      }
      else {
        $('#nladdressfiller').hide();
      }
    });

    // If manual checkbox changes
    $('#mppc_manualbtn').click(manualFill);
    $('#mppc_autobtn').click(autoFill);

    $('.mpauto').keyup(function () {
      var postcode = $('#mppc_postcode').val().replace(/\s/g, "");
      var housenr = $('#mppc_housenr').val().replace(/(^\d+)(.*?$)/i, '$1');
      var addition = $('#mppc_housenr').val().replace(/(^\d+)(.*?$)/i, '$2');

      if (postcode.length >= 6 && housenr.length != 0) {
        lastCall = $.now();
        $.ajax({
          url: module_link,
          type: 'POST',
          dataType: 'json',
          data: {
            postcode: postcode,
            huisnummer: housenr,
            toevoeging: addition,
            lastCall: lastCall
          },
          success: function (data) {
            if (data.result.lastCall >= lastCall) {
              if (typeof data.result !== 'undefined' &&
                typeof data.result.street !== 'undefined' &&
                typeof data.result.houseNumber !== 'undefined' &&
                typeof data.result.city !== 'undefined') {
                if ($('#address').length)
                  $('#address').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                else
                  $('#address1').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition);
                $('#city').val(data.result['city']);
                $('#postcode').val(data.result['postcode']);
                $('#mpresults').val(data.result['street'] + ' ' + data.result['houseNumber'] + addition + ', ' + data.result['postcode'] + ', ' + data.result['city']);
              } else if (data.result['message']) {
                $('#mpresults').val(data.result['message']);
              }
            }
          }
        });
      }
    });
  });
</script>
