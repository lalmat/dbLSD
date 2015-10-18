<?php
namespace lalmat\dbLSD;

/**
* Class de champs de base de données. (MySQL)
* @author lalmat
*
*/
class dbField {
  public $name;
  public $alias;
  public $type;
  public $length;
  public $classe;
  public $default;
  public $isUnsigned;
  public $isPrimary;
  public $isForeign;
  public $isUnique;
  public $isNullable;
  public $isAutoIncrement;

  public function __construct($dbAry, $aliasAry) {
    $this->name            = $dbAry["Field"];
    $this->alias					 = $this->genAlias($aliasAry);
    $this->type						 = $this->genType($dbAry["Type"]);
    $this->length					 = $this->genLength($dbAry["Type"]);
    $this->classe					 = $this->genClasse($this->type, $this->length);
    $this->isUnsigned      = (strpos($dbAry["Type"], "unsigned") !== false);
    $this->isForeign       = ($dbAry["Key"]=="MUL");
    $this->isPrimary       = ($dbAry["Key"]=="PRI");
    $this->isUnique        = ($dbAry["Key"]=="UNI");
    $this->default         = $dbAry["Default"];
    $this->isNullable      = ($dbAry["Null"]=="YES");
    $this->isAutoIncrement = ($dbAry["Extra"]=="auto_increment");
  }

  public function __destruct() {}


  private function genAlias($aliasAry) {
    // Suppression du Prefix (si Existant)
    $prefixPos = strpos($this->name,"_");
    $tmp = substr($this->name, ($prefixPos!==false)?($prefixPos+1):null);

    // Remplacent par les Alias (couteux en cpu mais bon... on est en local théoriquement.)
    foreach($aliasAry as $k=>$a)
      $tmp = str_replace($k, $a."_", $tmp);

    // On explose le nom pour le passer en camelCase
    $tmpAry = explode("_", $tmp);

    // Concaténation camelCase
    $genAlias = "";
    foreach($tmpAry as $tmpPart) {
      $genAlias .= ucfirst(strtolower($tmpPart));
    }
    $genAlias = lcfirst($genAlias);

    return $genAlias;
  }

  private function genType($rawType) {
    $stop = strpos($rawType, "(");
    return ($stop !== false) ? substr($rawType, 0, $stop) : $rawType;
  }

  private function genLength($rawType) {
    $start = strpos($rawType, "(");
    $stop  = strpos($rawType, ")");
    return ($start!==false && $stop!==false) ? substr($rawType, $start+1, $stop-$start-1) : null;
  }

  private function genClasse($type, $len) {
    switch(strtolower($type)) {
      case "double":
      case "float":
      case "decimal":
        return "FLT";

      case "smallint":
      case "mediumint":
      case "int":
      case "bigint":
        return "INT";

      case "tinyint":
        return ($len == 1) ? "BIT" : "INT";

      case "char":
      case "varchar":
        return ($len > 255) ? "TXT" : "STR";

      case "text":
        return "TXT";

      case "date":
      case "time":
      case "datetime":
        return "DT";

      case "boolean":
        return "BIT";

      default:
        return "NULL";
    }
  }

}