{$app.php_tag}
namespace {$app.namespace};

{foreach $app.tableAry as $table}
/**
 * Classe {$table->name}Fields (Table {$table->tableName})
 *
 */
class {$table->name}Fields{
{foreach $table->fields as $field}
{if $field->classe == "BIT"}
  public $is{$field->alias|ucfirst};
{else}
  public ${$field->alias};
{/if}
{/foreach}
}
class {$table->name}SearchFields  {
{foreach $table->fields as $field}
{if $field->classe == "DT" || ( ($field->classe == "INT" || $field->classe == "FLT")  && !$field->isPrimary && !$field->isForeign )}
{if $field->classe == "INT" || $field->classe == "FLT"}
  public ${$field->alias};
{/if}
  public $min{$field->alias|ucfirst};
  public $max{$field->alias|ucfirst};
{elseif $field->classe == "TXT"}
  public ${$field->alias}Like;
  public ${$field->alias}Start;
  public ${$field->alias}End;
  public ${$field->alias};
{elseif $field->classe == "BIT"}
  public $is{$field->alias|ucfirst};
{else}
  public ${$field->alias};
{/if}
{/foreach}
}

{/foreach}