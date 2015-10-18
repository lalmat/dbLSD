{$app.php_tag}
namespace {$app.namespace};

/**
 * Data Access Objects (DAO) pour le module '{$app.name}'
 */
class DAO extends wfDAO {
{foreach $app.tableAry as $table}

  // -----------------------------------------------------------------------------------------------
  // {$table->name}

  /**
   * Création des paramètres de requête pour {$table->name}
   * @param {$table->name}Search $s
   * @param {if $app.name != 'wf'}wf\{/if}DB $db
   * @return boolean
   */
  protected static function {$table->name|lcfirst}PartSQL({$table->name}Search $s) {
    $data = parent::{$table->name|lcfirst}PartSQL($s);
    return $data;
  }

  /**
   * Remplissage de l'objet {$table->name}
   * @param array $dbAry
   * @return {$app.namespace}\{$table->name}
   */
  protected static function {$table->name|lcfirst}Fill($r) {
    $o = parent::{$table->name|lcfirst}Fill($r);
    return $o;
  }
{/foreach}
}