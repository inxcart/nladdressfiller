<?php

// CLI args to $_GET
$first = true;
foreach ($argv as $arg) {
    if ($first) {
        $first = false;
        continue;
    }

    $arg = substr($arg, 2); // --
    $e = explode('=', $arg);
    if (count($e) == 2) {
        $_GET[$e[0]] = $e[1];
    } else {
        $_GET[$e[0]] = true;
    }
}
$bagdate = '';
if (!isset($_GET['skipbag'])) {
    $xmlReader = new XMLReader();
    $numberDesignations = [];
    $streets = [];
    $cities = [];

    // Find postcode + numbers
    $files = scandir(__DIR__.'/../bag/num');
    $total = count($files) - 2;
    echo "=== Processing postcodes and numbers\n";
    if (!file_exists(__DIR__.'/data/')) {
        mkdir(__DIR__.'/data/');
    }
    $fp = fopen(__DIR__.'/data/num.csv', 'w');
    foreach ($files as $numfile) {
        // Skip . and ..
        if (in_array($numfile, ['.', '..'])) {
            continue;
        }

        if (!$bagdate) {
            preg_match("/NUM(\d+)-/", $numfile, $m);
            $bagdate = $m[1];
        }

        // Open the file
        $xml = simplexml_load_file(__DIR__."/../bag/num/$numfile");
        $xml->registerXPathNamespace('xs', 'http://www.w3.org/2001/XMLSchema');
        $xml->registerXPathNamespace('xb', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-deelbestand-lvc/v20090901');
        $xml->registerXPathNamespace('bag_LVC', 'http://www.kadaster.nl/schemas/imbag/lvc/v20090901');
        $xml->registerXPathNamespace('gml', 'http://www.opengis.net/gml');
        $xml->registerXPathNamespace('xlink', 'http://www.w3.org/1999/xlink');
        $xml->registerXPathNamespace('bagtype', 'http://www.kadaster.nl/schemas/imbag/imbag-types/v20090901');
        $xml->registerXPathNamespace('nen5825', 'http://www.kadaster.nl/schemas/imbag/nen5825/v20090901');
        $xml->registerXPathNamespace('product_LVC', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-producten-lvc/v20090901');
        $xml->registerXPathNamespace('selecties-extract', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-selecties/v20090901');
        foreach ($xml->xpath('//xb:producten/product_LVC:LVC-product/bag_LVC:Nummeraanduiding') as $nummerAanduiding) {
            if (!isset($nummerAanduiding->xpath('./bag_LVC:postcode')[0])) {
                continue;
            }

            $postcode = (string) $nummerAanduiding->xpath('./bag_LVC:postcode')[0];
            $number = (string) $nummerAanduiding->xpath('./bag_LVC:huisnummer')[0];
            $suffix = (string) (isset($nummerAanduiding->xpath('./bag_LVC:huisnummertoevoeging')[0])
                ? trim($nummerAanduiding->xpath('./bag_LVC:huisnummertoevoeging')[0])
                : ''
            );
            $numberDesignations["{$postcode}{$number}{$suffix}"] = [
                (string) $nummerAanduiding->xpath('./bag_LVC:gerelateerdeOpenbareRuimte/bag_LVC:identificatie')[0],
                $postcode,
                $number,
                $suffix,
            ];
        }
        list(, $docId) = explode('-', basename($numfile, '.xml'));
        $current = (int) $docId;
        echo "  Processed ({$current}/{$total})\n";
    }
    foreach ($numberDesignations as $designation) {
        fputcsv($fp, $designation);
    }
    fclose($fp);

    // Find streets
    $files = scandir(__DIR__.'/../bag/opr');
    $total = count($files) - 2;
    $fp = fopen(__DIR__.'/data/opr.csv', 'w');
    echo "=== Processing streets\n";
    foreach ($files as $oprfile) {
        // Skip . and ..
        if (in_array($oprfile, ['.', '..'])) {
            continue;
        }
        // Open the file
        $xml = simplexml_load_file(__DIR__."/../bag/opr/$oprfile");
        $xml->registerXPathNamespace('xs', 'http://www.w3.org/2001/XMLSchema');
        $xml->registerXPathNamespace('xb', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-deelbestand-lvc/v20090901');
        $xml->registerXPathNamespace('bag_LVC', 'http://www.kadaster.nl/schemas/imbag/lvc/v20090901');
        $xml->registerXPathNamespace('gml', 'http://www.opengis.net/gml');
        $xml->registerXPathNamespace('xlink', 'http://www.w3.org/1999/xlink');
        $xml->registerXPathNamespace('bagtype', 'http://www.kadaster.nl/schemas/imbag/imbag-types/v20090901');
        $xml->registerXPathNamespace('nen5825', 'http://www.kadaster.nl/schemas/imbag/nen5825/v20090901');
        $xml->registerXPathNamespace('product_LVC', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-producten-lvc/v20090901');
        $xml->registerXPathNamespace('selecties-extract', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-selecties/v20090901');
        foreach ($xml->xpath('//xb:producten/product_LVC:LVC-product/bag_LVC:OpenbareRuimte') as $openbareRuimte) {
            $streetId = (string) $openbareRuimte->xpath('./bag_LVC:identificatie')[0];
            $streets[$streetId] = [
                $streetId,
                (string) $openbareRuimte->xpath('./bag_LVC:openbareRuimteNaam')[0],
                (string) $openbareRuimte->xpath('./bag_LVC:gerelateerdeWoonplaats/bag_LVC:identificatie')[0],
            ];
        }
        list(, $docId) = explode('-', basename($oprfile, '.xml'));
        $current = (int) $docId;
        echo "  Processed ({$current}/{$total})\n";
    }
    foreach ($streets as $street) {
        fputcsv($fp, $street);
    }
    fclose($fp);

    // Find cities
    $files = scandir(__DIR__.'/../bag/wpl');
    $total = count($files) - 2;
    $fp = fopen(__DIR__.'/data/wpl.csv', 'w');
    echo "=== Processing cities\n";
    foreach ($files as $wplfile) {
        // Skip . and ..
        if (in_array($wplfile, ['.', '..'])) {
            continue;
        }
        // Open the file
        $xml = simplexml_load_file(__DIR__."/../bag/wpl/$wplfile");
        $xml->registerXPathNamespace('xs', 'http://www.w3.org/2001/XMLSchema');
        $xml->registerXPathNamespace('xb', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-deelbestand-lvc/v20090901');
        $xml->registerXPathNamespace('bag_LVC', 'http://www.kadaster.nl/schemas/imbag/lvc/v20090901');
        $xml->registerXPathNamespace('gml', 'http://www.opengis.net/gml');
        $xml->registerXPathNamespace('xlink', 'http://www.w3.org/1999/xlink');
        $xml->registerXPathNamespace('bagtype', 'http://www.kadaster.nl/schemas/imbag/imbag-types/v20090901');
        $xml->registerXPathNamespace('nen5825', 'http://www.kadaster.nl/schemas/imbag/nen5825/v20090901');
        $xml->registerXPathNamespace('product_LVC', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-producten-lvc/v20090901');
        $xml->registerXPathNamespace('selecties-extract', 'http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-selecties/v20090901');
        foreach ($xml->xpath('//xb:producten/product_LVC:LVC-product/bag_LVC:Woonplaats') as $woonplaats) {
            $cityId = (string) $woonplaats->xpath('./bag_LVC:identificatie')[0];
            $cities[$cityId] = [
                $cityId,
                (string) $woonplaats->xpath('./bag_LVC:woonplaatsNaam')[0],
            ];
        }
        list(, $docId) = explode('-', basename($wplfile, '.xml'));
        $current = (int) $docId;
        echo "  Processed ({$current}/{$total})\n";
    }
    foreach ($cities as $city) {
        fputcsv($fp, $city);
    }
    fclose($fp);


    unset($numberDesignations);
    unset($streets);
    unset($cities);
}

// Continue from files

// Check BAG date first before continuing
if (!$bagdate && isset($bagdate)) {
    $bagdate = $_GET['bagdate'];
}
if (!$bagdate) {
    fwrite(STDERR, "ERROR: No BAG date found\n");
    exit(1);
}

$streets = [];
$allPostcodes = array_map('str_getcsv', file('data/num.csv'));
$allStreets = array_map('str_getcsv', file('data/opr.csv'));
foreach ($allStreets as &$street) {
    $streets[$street[0]] = $street;
}
unset($street);
$allCities = array_map('str_getcsv', file('data/wpl.csv'));
foreach ($allCities as &$city) {
    $cities[$city[0]] = $city;
}
unset($city);

// In chunks
function rrmdir($src)
{
    $dir = opendir($src);
    while (false !== ($file = readdir($dir))) {
        if (($file != '.') && ($file != '..')) {
            $full = $src.'/'.$file;
            if (is_dir($full)) {
                rrmdir($full);
            } else {
                unlink($full);
            }
        }
    }
    closedir($dir);
    rmdir($src);
}


rrmdir(__DIR__.'/output');
mkdir(__DIR__.'/output');
if (isset($_GET['chunksize'])) {
    $chunkSize = (int) $_GET['chunksize'];
    $chunk = 1;
    $postcodeFp = fopen(__DIR__.'/output/postcodes'.str_pad($chunk, 5, '0', STR_PAD_LEFT).'.csv', 'w');
} else {
    $chunkSize = 0;
    $chunk = 0;
    $postcodeFp = fopen(__DIR__.'/output/postcodes.csv', 'w');
}

$i = 0;
foreach ($allPostcodes as &$postcode) {
    if (!isset($streets[$postcode[0]][1])) {
        continue;
    }
    $street = $streets[$postcode[0]][1];

    if (!isset($cities[$streets[$postcode[0]][2]][1])) {
        continue;
    }
    $city = $cities[$streets[$postcode[0]][2]][1];

    $newPostcode = [
        $postcode[1],
        $postcode[2],
        $postcode[3],
        $street,
        $city,
    ];

    fputs($postcodeFp, implode($newPostcode, ',')."\n");

    if ($chunkSize) {
        if ($i >= $chunkSize) {
            $i = 0;
            $chunk++;
            fclose($postcodeFp);
            $postcodeFp = fopen(__DIR__.'/output/postcodes'.str_pad($chunk, 5, '0', STR_PAD_LEFT).'.csv', 'w');
        }
    }
    $i++;
}
fclose($postcodeFp);

// Generate manifest if chunked
file_put_contents(__DIR__.'/output/manifest.json', json_encode([
    'source'    => [
        'name'    => 'Het Kadaster',
        'website' => 'https://kadaster.nl',
    ],
    'license'   => 'http://creativecommons.org/publicdomain/zero/1.0/deed.nl',
    'date'      => substr($bagdate, 0, 2).'-'.substr($bagdate, 2, 2).'-'.substr($bagdate, 4, 4),
    'chunks'    => (int) $chunk,
    'chunksize' => (int) $chunkSize,
], JSON_PRETTY_PRINT + JSON_UNESCAPED_SLASHES));
