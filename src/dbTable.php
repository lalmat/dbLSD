<?php
namespace lalmat\dbLSD;

/**
* Classe de table de base de données. (MySQL)
* @author lalmat
*
*/
class dbTable {
  public $tableName;
  public $name;
  public $fields;

  /**
   * Constructeur
   * @param string $tableName
   * @param \PDO $db
   * @param array $aliasAry
   */
  public function __construct($tableName, \PDO $db, $aliasAry) {
    try {

      // Nom de la table
      $this->tableName = $tableName;

      // Nom Fonctionnel de l'objet
      $this->name = "";
      $explode = explode("_", $tableName);
      for($i=1; $i<sizeof($explode); $i++)
        $this->name .= ucfirst(strtolower($explode[$i]));

      // Récupération des champs de l'objet
      $stm = $db->query("SHOW COLUMNS FROM $tableName");
      $this->fields = array();
      while($r = $stm->fetch(\PDO::FETCH_ASSOC)) {
        $this->fields[$r['Field']] = new dbField($r, $aliasAry);
      }
    }
    catch (\Exception $e) {
      echo "Erreur $tableName: ".$e->getMessage().PHP_EOL;
    }
  }

  /**
   * Destructeur
   */
  public function __destruct() {}

  /**
   * Retourne la chaine des champs de la table pour un Select
   * @param string $withPrimaryKey
   * @return string
   */
  public function SQL_SelectFields($withPrimaryKey=true) {
    $sql = "";
    foreach ($this->fields as $f) {
      if ( ($f->isPrimary && $withPrimaryKey) || !$f->isPrimary ) {
        $sql .= (($sql == "")?"":", ").$f->name;
      }
    }
    return $sql;
  }

  /**
   * Retourne la chaine des champs alias de valeur pour un Insert
   * @param string $withPrimaryKey
   * @return string
   */
  public function SQL_InsertAlias($withPrimaryKey=true) {
    $sql = "";
    foreach ($this->fields as $f) {
      if ( ($f->isPrimary && $withPrimaryKey) || !$f->isPrimary ) {
        $sql .= (($sql == "")?"":", ").":".$f->alias;
      }
    }
    return $sql;
  }

  /**
   * Retourne la chaine des champs alias de valeur pour un Update
   * @param string $withPrimaryKey
   * @return string
   */
  public function SQL_UpdateAlias($withPrimaryKey=true) {
    $sql = "";
    foreach ($this->fields as $f) {
      if ( ($f->isPrimary && $withPrimaryKey) || !$f->isPrimary ) {
        $sql .= (($sql == "")?"                ":",".PHP_EOL."                ").$f->name."=:".$f->alias;
      }
    }
    return $sql;
  }

  /**
   * Retourne la chaine des champs alias pour les clés primaires
   * @return string
   */
  public function SQL_PrimaryAlias() {
    $sql = "";
    foreach ($this->fields as $f) {
      if ($f->isPrimary)
        $sql .= ($sql == "") ? $f->name."=:".$f->alias:" AND ".$f->name."=:".$f->alias;
    }
    return $sql;
  }

  public function Func_PrimaryAlias() {
    $sql = "";
    foreach ($this->fields as $f) {
      if ($f->isPrimary) $sql .= ($sql == "")?"$".$f->alias:", $".$f->alias;
    }
    return $sql;
  }

  public function nbPrimary() {
    $p=0;
    foreach ($this->fields as $f) {
      if ($f->isPrimary) $p++;
    }
    return $p;
  }
}