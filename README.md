# NL Address Filler
![NL Address Filler](/logo.png)

## About

Auto fill the streetname and city field when the postcode + number are known and speed up the checkout process.

## How to build / install

This module does not depend on any external services, but instead works with an internal database with about ~7.7 million addresses.
These addresses are extracted from a public address registry.

### Requirements

The module and database can only be prepared on a select amount of systems. If you'd like to run it on a different environment you will likely have to change a few scripts here and then.

This module should build on:
- Any *NIX system
- PHP 5.5+
- A machine that has 8GB free RAM or more (this script has been designed to work, not to be efficient, hence the requirement)

This module has been designed for the `community-theme-default` theme. Using this module on another theme will require some manual changes.

### Extract address data

Download the file `inspireadressen.zip` from the following page: [http://www.nationaalgeoregister.nl/geonetwork/srv/dut/catalog.search#/metadata/76091be7-358a-4a44-8182-b4139c96c6a4](http://www.nationaalgeoregister.nl/geonetwork/srv/dut/catalog.search#/metadata/76091be7-358a-4a44-8182-b4139c96c6a4).
Extract the xml files in the folders with the codes `NUM`, `OPR` and `WPL` resp. into the folders `/build/bag/num`, `/build/bag/opr` and `/build/bag/wpl`.
For a `NUM` file the path should look like `/build/bag/num/9999NUM08012018-000001.xml`.

CD into the folder `build/bagsql` 
Run the file `bagsql.php` with PHP:
```shell
$ php ./bagsql.php
```

This will generate the file `postcodes.csv`, containing about 7.7 million addresses (addresses with suffices have been removed).

This will will need to be imported into the database table `{DB_PREFIX}nladdressfiller_postcodes`.
You can create this table with the following DDL (make sure you replace the `{DB_PREFIX}` with your own):
```sql
CREATE TABLE `{DB_PREFIX}nladdressfiller_postcodes`
(
	`number`   INT(8) UNSIGNED NOT NULL,
	`postcode` CHAR(6)         NOT NULL,
	`street`   VARCHAR(127)    NOT NULL,
	`city`     VARCHAR(127)    NOT NULL,
	PRIMARY KEY (`postcode`, `number`)
)
ENGINE=InnoDB
CHARSET=utf8;

``` 
Import the CSV into this database table. You can use command line tools like `mysqlimport`.
PhpMyAdmin is the recommended graphical way to import the file, but be aware that it might take a couple of hours before all ~7.7 million rows have been imported.

### Building the module

You can build the module by running `build.sh` on any *NIX system.

### Installing the module

Install the module via your thirty bees back office. Most of the configuration options are plug and play.
