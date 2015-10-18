{$app.php_tag}
namespace {$app.namespace};

/**
 * Classes ENTITIES du module '{$app.name}'
 */
require_once(__DIR__."/wfENT_{$app.name}.class.php");

{foreach $app.tableAry as $table}
/**
 * Classe {$table->name} (Table {$table->tableName}
 *
 */
class {$table->name} extends {$table->name}Fields {
  // Placez ici vos attributs supplémentaires
}
class {$table->name}Search extends {$table->name}SearchFields {
	// Placez ici vos attributs de recherche supplémentaires
}

{/foreach}