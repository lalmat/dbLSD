<?php
// Composer autoloader
require_once(__DIR__."/vendor/autoload.php");
include_once(__DIR__."/config/config.inc.php");


// Command line data
$tablePrefix     = $argv[1];
$targetNamespace = $argv[2];

try {

	// Empty args ? Show help message.
	if ($argv[1] == null) die("Usage: ./builder.sh [tablePrefix] [Namespace]".PHP_EOL);

  // Initialization of the builder
  $b = new \lalmat\dbLSD\builder($tablePrefix, $targetNamespace);

  echo "Loading aliases.".PHP_EOL;
  include_once($_cfg['DB']['ALIAS']);
	$b->setAlias($alias);
  $b->setDB($_cfg['DB']);

	// Lancement du builder
	echo "-----------------------------------------------------------------------".PHP_EOL;
	echo "Fechting ".$tablePrefix."_% table structure on ".$_cfg['DB']['BASE'].PHP_EOL;
	echo "-----------------------------------------------------------------------".PHP_EOL;
	echo $_cfg['OUTPUT_DIR'].PHP_EOL;
	$b->build($_cfg['OUTPUT_DIR']);
}
catch (\Exception $e) {
	echo $e->getMessage();
}