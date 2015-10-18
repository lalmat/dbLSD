{$app.php_tag}
namespace {$app.namespace};

class wfDAO {

{foreach $app.tableAry as $table}
  // -----------------------------------------------------------------------------------------------
  // {$table->name}

  /**
   * Création des paramètres de requête pour {$table->name}
   * @param {$table->name}Search $s
   * @return boolean
   */
  protected static function {$table->name|lcfirst}PartSQL({$table->name}Search $s) {
    $pAry = array();

    $pAry['SQL_Select']  = "{$table->SQL_SelectFields()}";
    $pAry['SQL_From']    = "{$table->tableName}";
    $pAry['SQL_GroupBy'] = "";
    $pAry['SQL_Having']  = null;
    $pAry['SQL_OrderBy'] = "";
    $pAry['Value']       = array();
		$pAry['Token']       = array();

{foreach $table->fields as $f}
 		{"// {$f->alias} ----------------------------------------------------------------------------------------------"|substr:0:97}
{if ($f->isPrimary || $f->isForeign) && $f->classe=="INT"}
    if(is_numeric($s->{$f->alias})) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}";
			$pAry['Value'][':{$f->alias}'] = $s->{$f->alias};
		}
		if(is_array($s->{$f->alias})) {
			$in = {if $app.name != 'wf'}wf\{/if}DB::ary2In("{$f->name}", $s->{$f->alias});
			$pAry['Token'][] = "{$f->name} IN (".$in['LIST'].")";
			$pAry['Value'] = array_merge($pAry['Value'], $in['CODES']);
		}
{elseif $f->classe=="DT"}
    if(is_string($s->min{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} >= :min{$f->alias|ucfirst}";
			$pAry['Value'][':min{$f->alias|ucfirst}'] = $s->min{$f->alias|ucfirst};
		}
	  if(is_string($s->max{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} <= :max{$f->alias|ucfirst}";
			$pAry['Value'][':max{$f->alias|ucfirst}'] = $s->max{$f->alias|ucfirst};
		}
{elseif $f->classe=="TXT"}
    if(is_string($s->{$f->alias}Like)) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}Like";
			$pAry['Value'][':{$f->alias}Like'] = "%".$s->{$f->alias}Like."%";
		}
	  if(is_string($s->{$f->alias}Start)) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}Start";
			$pAry['Value'][':{$f->alias}Start'] = $s->{$f->alias}Start."%";
		}
		if(is_string($s->{$f->alias}End)) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}End";
			$pAry['Value'][':{$f->alias}End'] = "%".$s->{$f->alias}End;
		}
{elseif $f->classe=="STR"}
    if(is_string($s->{$f->alias})) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}";
			$pAry['Value'][':{$f->alias}'] = $s->{$f->alias};
		}
		if(is_array($s->{$f->alias})) {
			$in = {if $app.name != 'wf'}wf\{/if}DB::ary2In("{$f->name}", $s->{$f->alias});
			$pAry['Token'][] = "{$f->name} IN (".$in['LIST'].")";
			$pAry['Value'] = array_merge($pAry['Value'], $in['CODES']);
		}
{elseif $f->classe=="INT"}
   	if(is_numeric($s->{$f->alias})) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}";
			$pAry['Value'][':{$f->alias}'] = $s->{$f->alias};
		}
    if(is_numeric($s->min{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} >= :min{$f->alias|ucfirst}";
			$pAry['Value'][':min{$f->alias|ucfirst}'] = $s->min{$f->alias|ucfirst};
		}
		if(is_numeric($s->max{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} <= :max{$f->alias|ucfirst}";
			$pAry['Value'][':max{$f->alias|ucfirst}'] = $s->max{$f->alias|ucfirst};
		}
{elseif $f->classe=="FLT"}
   	if(is_float($s->{$f->alias})) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}";
			$pAry['Value'][':{$f->alias}'] = $s->{$f->alias};
		}
    if(is_float($s->min{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} >= :min{$f->alias|ucfirst}";
			$pAry['Value'][':min{$f->alias|ucfirst}'] = $s->min{$f->alias|ucfirst};
		}
		if(is_float($s->max{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} <= :max{$f->alias|ucfirst}";
			$pAry['Value'][':max{$f->alias|ucfirst}'] = $s->max{$f->alias|ucfirst};
		}
{elseif $f->classe=="BIT"}
		if(is_bool($s->is{$f->alias|ucfirst})) {
			$pAry['Token'][] = "{$f->name} = :is{$f->alias|ucfirst}";
			$pAry['Value'][':is{$f->alias|ucfirst}'] = $s->is{$f->alias|ucfirst};
		}
{else}
   	if(!is_null($s->{$f->alias})) {
			$pAry['Token'][] = "{$f->name} = :{$f->alias}";
			$pAry['Value'][':{$f->alias}'] = $s->{$f->alias};
		}
{/if}
{/foreach}

    return $pAry;
	}

	/**
	 * Execution de la requête SQL avec les paramètres de recherche
	 * @param {$table->name}Search $s
	 * @param wf\DB $db
	 * @return bool
	 */
	protected static function {$table->name|lcfirst}SQL({$table->name}Search $s, wf\DB $db) {
		$data = static::{$table->name|lcfirst}PartSQL($s);

		$sql  = "SELECT ".$data['SQL_Select']." ";
		$sql .= "FROM ".$data['SQL_From']." ";
		if (is_array($data['Token'])) $sql .= {if $app.name != 'wf'}wf\{/if}DB::ary2where($data['Token'])." ";
		$sql .= ($data['SQL_GroupBy'] != "") ? "GROUP BY ".$data['SQL_GroupBy']." " : "";
		if (is_array($data['SQL_Having'])) $sql .= {if $app.name != 'wf'}wf\{/if}DB::ary2having($data['SQL_Having'])." ";
		$sql .= ($data['SQL_OrderBy'] != "") ? "ORDER BY ".$data['SQL_OrderBy']." " : "";

    return $db->secureQuery($sql, $data['Value']);
	}

  /**
   * Remplissage de l'objet {$table->name}
   * @param array $r
   * @return {$table->name}
   */
  protected static function {$table->name|lcfirst}Fill($r) {
    $o = new {$table->name}();
{foreach $table->fields as $f}
{if $f->classe=="BIT"}
    $o->is{$f->alias|ucfirst} = ( $r["{$f->name}"] == 1 );
{else}
    $o->{$f->alias} = $r["{$f->name}"];
{/if}
{/foreach}
    return $o;
	}

  /**
   * Chargement des objets {$table->name} en fonction de l'objet de recherche {$table->name}Search
   * @param {$table->name}Search $s
   * @param bool $asAry
   * @return {$table->name} | {$table->name}[] | null
   */
  public static function {$table->name|lcfirst}Load({$table->name}Search $s, $asAry=true) {
    $db = new wf\DB();
		$r = null;
    if(static::{$table->name|lcfirst}SQL($s,$db)) {
      if(!$asAry) { if($rAry = $db->fetch()) $r = static::{$table->name|lcfirst}Fill($rAry); }
      else { while ($rAry = $db->fetch()) $r[] = static::{$table->name|lcfirst}Fill($rAry); }
		}
    return $r;
  }

  /**
   * Enregistrement de l'objet {$table->name} en base de données.
   * @param {$table->name} $o
   * @return bool
   */
  public static function {$table->name|lcfirst}Save({$table->name} $o) {
    $db = new wf\DB();
{if $table->nbPrimary() == 1}
{foreach $table->fields as $f}
{if $f->isPrimary}
    $isNew = !is_numeric($o->{$f->alias});
{else}
{if $f->classe=="BIT"}
		$pAry['Value'][':{$f->alias}'] = $o->is{$f->alias|ucfirst} ? 1 : 0;
{else}
    $pAry['Value'][':{$f->alias}'] = $o->{$f->alias};
{/if}
{/if}
{/foreach}
{else}
{foreach $table->fields as $f}
{if $f->classe=="BIT"}
		$pAry['Value'][':{$f->alias}'] = $o->is{$f->alias|ucfirst} ? 1 : 0;
{else}
    $pAry['Value'][':{$f->alias}'] = $o->{$f->alias};
{/if}
{/foreach}
{/if}
{if $table->nbPrimary() == 1}
    if($isNew) {
      $sql = "INSERT INTO {$table->tableName} (
						   {$table->SQL_SelectFields(false)}
						  ) VALUES (
						   {$table->SQL_InsertAlias(false)}
						  );";
    } else {
{foreach $table->fields as $f}
{if ($f->isPrimary)}
			$pAry['Value'][':{$f->alias}'] = $o->{$f->alias};
{/if}
{/foreach}
      $sql = "UPDATE {$table->tableName}
              SET
{$table->SQL_UpdateAlias(false)}
      				WHERE
      				 {$table->SQL_PrimaryAlias()}";
   }
{else}
		static::{$table->name|lcfirst}Delete($o);

$sql = "INSERT INTO {$table->tableName} (
						   {$table->SQL_SelectFields(true)}
						  ) VALUES (
						   {$table->SQL_InsertAlias(true)}
						  );";

{/if}
   $rs = $db->secureQuery($sql, $pAry['Value']);

{if $table->nbPrimary() == 1}
{foreach $table->fields as $f}
{if $f->isPrimary}
    if($rs && $isNew) $o->id = $db->lastInsertId();
{/if}
{/foreach}
{/if}
   unset($db);
   return $rs;
  }

  /**
   * Retroune true si un enregistrement de l'objet {$table->name} existe dans la base de données avec l'ID donné.
{foreach $table->fields as $f}
{if $f->isPrimary}
   * @param int ${$f->alias}
{/if}
{/foreach}
   * @return bool
   */
  public static function {$table->name|lcfirst}Exists({$isFirst=true}{foreach $table->fields as $f}{if $f->isPrimary}{if $isFirst}{$isFirst=false}{else}, {/if}${$f->alias}{/if}{/foreach}) {
    $db = new wf\DB();
{foreach $table->fields as $f}
{if $f->isPrimary}
    $pAry['Value'][':{$f->alias}'] = ${$f->alias};
{/if}
{/foreach}
	  $db->secureQuery("SELECT * FROM {$table->tableName} WHERE {$table->SQL_PrimaryAlias()}", $pAry['Value']);
	  $nb = $db->getNumRows();
	  unset($db);
	  return ($nb>0);
  }

  /**
   * Suppression de l'objet {$table->name} de la base de données.
   * @param {$table->name} $o
   * @return bool
   */
  public static function {$table->name|lcfirst}Delete({$table->name} $o) {
    $db = new wf\DB();
{foreach $table->fields as $f}
{if $f->isPrimary}
    $pAry['Value'][':{$f->alias}'] = $o->{$f->alias};
{/if}
{/foreach}
	  $rs = $db->secureQuery("DELETE FROM {$table->tableName} WHERE {$table->SQL_PrimaryAlias()}", $pAry['Value']);
	  unset($db);
	  return $rs;
  }

{/foreach}
}

