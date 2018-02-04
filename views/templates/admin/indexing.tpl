<div class="panel">
  <div class="panel-heading"><i class="icon icon-list"></i> {l s='Indexing' mod='nladdressfiller'}</div>
  {if !$manifest}
    <div class="alert alert-danger">{l s='Address data needs to be refreshed first' mod='nladdressfiller'}</div>
    <form action="{$link->getAdminLink('AdminModules', true)|escape:'htmlall':'UTF-8'}&configure=nladdressfiller" method="POST">
      <button type="submit" name="refreshAddressData" class="btn btn-info">{l s='Refresh address data' mod='nladdressfiller'} <i class="icon icon-refresh"></i></button>
    </form>
  {else}
    <div class="alert alert-info">
      {l s='This panel shows the amount of addresses that have been indexed and the amount remaining. Note that indexing can take up to 4 hours, so only do a full reindex when the Kadaster has released a new dataset.' mod='nladdressfiller'}
    </div>
    <div class="panel">
      <h3>{l s='Information' mod='nladdressfiller'}</h3>
      <strong>{l s='Source' mod='nladdressfiller'}:</strong> <em><a href="https://www.kadaster.{if strtolower($iso) === 'nl'}nl{else}com{/if}/" target="_blank">Het Kadaster</a></em><br />
      <strong>{l s='Latest version available' mod='nladdressfiller'}:</strong> <em>{$manifest['date']|strtotime|date_format:'d-m-Y'}</em><br />
      <strong>{l s='Indexed version' mod='nladdressfiller'}:</strong> <em>{if $datasetIndexed}{$datasetIndexed|strtotime|date_format:'d-m-Y'}{else}{l s='Unknown' mod='nladdressfiller'}{/if}</em><br />
      <strong>{l s='Amount of addresses' mod='nladdressfiller'}:</strong> <em>{$total|intval}</em>
      <br />
      <br />
      <form action="{$link->getAdminLink('AdminModules', true)|escape:'htmlall':'UTF-8'}&configure=nladdressfiller"
            method="POST"
      >
        <button type="submit" name="refreshAddressData" class="btn btn-default">{l s='Refresh address data' mod='nladdressfiller'} <i class="icon icon-refresh"></i></button>
      </form>
    </div>
    <div class="panel">
      <h3>{l s='Progress' mod='nladdressfiller'}</h3>
      <div class="progress">
        <div id="progress-bar-addresses"
             class="progress-bar"
             role="progressbar"
             style="width: {($indexed / $total * 100)|floatval}%; text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000"
        >
          <span style="position: absolute; padding-left: 5px; padding-right: 5px">
            <span id="indexed-addresses">{$indexed|intval}</span> / <span id="total-addresses">{$total|intval}</span> <span id="percentage-addresses">({($indexed / $total * 100)|floatval|round:2}%)</span>
          </span>
        </div>
      </div>
    </div>
    <div class="panel-footer">
      <button id="btn-full-index" class="btn btn-default" disabled="disabled">
        <i class="process-icon-refresh"></i> {l s='Full reindex' mod='nladdressfiller'}
      </button>
      <button id="btn-continue-index" class="btn btn-default" disabled="disabled">
        <i class="process-icon-next"></i> {l s='Continue' mod='nladdressfiller'}
      </button>
      <button id="btn-pause-index" class="btn btn-default pull-right" style="display: none">
        <i class="process-icon-cancel"></i> {l s='Cancel' mod='nladdressfiller'}
      </button>
    </div>
  {/if}
</div>
<script type="text/javascript">
  (function () {
    function initIndexing() {
      if (typeof $ === 'undefined') {
        setTimeout(initIndexing, 100);

        return;
      }

      var xhr;
      function enableButtons() {
        $('#btn-full-index').find('i').removeClass('icon-spin');
        $('#btn-full-index').removeAttr('disabled');
        $('#btn-continue-index').removeAttr('disabled');
        $('#btn-pause-index').hide();
      }

      function disableButtons() {
        $('#btn-full-index').attr('disabled', 'disabled');
        $('#btn-full-index').find('i').addClass('icon-spin');
        $('#btn-continue-index').attr('disabled', 'disabled');
        $('#btn-pause-index').removeAttr('disabled');
        $('#btn-pause-index').show();
      }

      function continueIndex() {
        if (xhr && typeof xhr.abort === 'function') {
          xhr.abort();
        }
        disableButtons();
        xhr = $.ajax({
          url: '{$link->getAdminLink('AdminModules', true)|escape:'javascript':'UTF-8'}&configure=nladdressfiller',
          type: 'POST',
          dataType: 'json',
          data: {
            action: 'ContinueIndex',
            ajax: true,
          },
          success: function (response) {
            if (response && response.success) {
              if (response.indexed < response.total) {
                $('#indexed-addresses').text(parseInt(response.indexed), 10);
                $('#total-addresses').text(parseInt(response.total), 10);
                $('#percentage-addresses').text('(' + (response.indexed / response.total * 100).toFixed(2) + '%)');
                $('#progress-bar-addresses').css('width', ((response.indexed / response.total) * 100) + '%');
                continueIndex();
              } else {
                $('#indexed-addresses').text(parseInt(response.total), 10);
                $('#total-addresses').text(parseInt(response.total), 10);
                $('#percentage-addresses').text('(' + parseFloat('100').toFixed(2) + '%)');
                $('#progress-bar-addresses').css('width', '100%');
                window.showSuccessMessage('{l s='Indexing successful' mod='nladdressfiller' js=1}');
                enableButtons();
              }
            } else {
              window.showErrorMessage('{l s='Indexing failed' mod='nladdressfiller' js=1}');
              if (response && response.message) {
                console.log('nladdressfiller error: ' + response.message);
              }

              enableButtons();
            }
          },
          error: function (jqXHR) {
            if (jqXHR.status > 0) {
              window.showErrorMessage('{l s='An error occurred. Indexing did not succeed.' mod='nladdressfiller' js=1}');
            }
            enableButtons();
          }
        });
      }

      function fullReindex() {
        if (xhr && typeof xhr.abort === 'function') {
          xhr.abort();
        }
        disableButtons();
        xhr = $.ajax({
          url: '{$link->getAdminLink('AdminModules', true)|escape:'javascript':'UTF-8'}&configure=nladdressfiller',
          type: 'POST',
          dataType: 'json',
          data: {
            action: 'RestartIndex',
            ajax: true,
          },
          success: function (response) {
            xhr = null;
            $('#indexed-addresses').text(0);
            $('#total-addresses').text(parseInt(response.total, 10));
            $('#percentage-addresses').text('(' + parseFloat('0').toFixed(2) + '%)');
            $('#progress-bar-addresses').css('width', '0');
            continueIndex();
          },
          error: function () {
            window.showErrorMessage('{l s='An error occurred. Full reindex did not succeed.' mod='nladdressfiller' js=1}');
            enableButtons();
          }
        });
      }

      function pauseIndex(event) {
        var $elem = $(event.target).closest('button');
        $elem.attr('disabled', 'disabled');

        if (xhr && typeof xhr.abort === 'function') {
          xhr.abort();
        }
        enableButtons();
      }

      window.nladdressfiller = window.nladdressfiller || { };
      $('#btn-full-index')
        .click(fullReindex)
        .removeAttr('disabled');
      $('#btn-continue-index')
        .click(continueIndex)
        .removeAttr('disabled');
      $('#btn-pause-index')
        .click(pauseIndex);
    }

    initIndexing();
  }());
</script>
