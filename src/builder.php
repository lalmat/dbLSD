<?php
namespace lalmat\dbLSD;

/**
 * Classe du builder - Assistant de création de code.
 * @author lalmat
 *
 */
class builder {

	private $namespace;
	private $appName;
	private $tableAry;
	private $aliasAry;
	private $dbCnx;
	private $dbBase;

	/**
	 * Constructeur
	 * @param $prefix    : Préfixe des tables
	 * @param $namespace : NameSpace du parent
	 */
	public function __construct($prefix, $namespace) {
		$this->appName = strtolower($prefix);
		$this->namespace = strtoupper($namespace."\\".trim($prefix));
		$this->namespace = str_replace("\r", "", $this->namespace);
		$this->namespace = str_replace("\n", "", $this->namespace);
		$this->tableAry = array();
	}

	/**
	 * Destructeur
	 */
	public function __destruct() {
		unset($this->tableAry);
		unset($this->dbCnx);
	}

	/**
	 * Défini le tableau d'alias pour "humaniser" le nom des champs
	 * @param array $aliasAry
	 */
	public function setAlias($aliasAry) {
		$this->aliasAry = $aliasAry;
	}

	/**
	 * Défini les paramètres de connexion à la base de données.
	 * @param array $dbInf
	 */
	public function setDB($dbInf) {
		$this->dbCnx = new \PDO($dbInf['DSN'], $dbInf['USER'], $dbInf['PASS']);
		$this->dbBase = $dbInf['BASE'];
	}

	/**
	 * Construit tous les objets possibles sur les tables trouvées
	 * @param string $outDirectory
	 */
	public function build($outDirectory) {
		$this->tableAry = array();
		$sql  = "SHOW TABLES FROM `".$this->dbBase."` LIKE '".$this->appName."_%'";
		$stmt = $this->dbCnx->query($sql);
		while ($tableName = $stmt->fetch(\PDO::FETCH_NUM)) {
			echo "Inspecting ".$tableName[0].PHP_EOL;
			$this->tableAry[] = new dbTable($tableName[0], $this->dbCnx, $this->aliasAry);
		}

		$isDir = false;
		if (!is_dir($outDirectory)) {
			throw new \Exception("Repertoire de destination invalide");
		} else {
			if (!is_dir($outDirectory)) $isDir=mkdir($outDirectory."/".$this->appName);
			else $isDir = true;
		}

		if ($isDir) {
      $output = $outDirectory."/".str_replace("\\", "/", $this->namespace);
			$fileDir = $output;
      if (!is_dir($fileDir)) mkdir($fileDir,0777,true);

			$this->build_WF($fileDir);
			$this->build_GEN($fileDir);

		}
	}

	/**
	 * Construit l'objet DBO (DataBase Objects)
	 * @param string $outDirectory
	 */
	public function build_WF($outDirectory) {
		if (!is_dir($outDirectory)) throw new \Exception("Impossible de trouver le répertoire ".$outDirectory);
		$s = new \Smarty();
		$app['php_tag']   = "<?php";
		$app['name']      = $this->appName;
		$app['namespace'] = $this->namespace;
		$app['tableAry']  = $this->tableAry;
		$s->assign("app",$app);

		$dataENT = $s->fetch(__DIR__."/templates/wfENT.tpl");
		file_put_contents($outDirectory."/wfENT_".$this->appName.".class.php", $dataENT);
		$dataDAO = $s->fetch(__DIR__."/templates/wfDAO.tpl");
		file_put_contents($outDirectory."/wfDAO_".$this->appName.".class.php", $dataDAO);
  }

	/**
	 * Construit l'objet ENT (Entities)
	 * @param string $outDirectory
	 */
	public function build_GEN($outDirectory) {
		if (!is_dir($outDirectory)) throw new \Exception("Impossible de trouver le répertoire ".$outDirectory);
		$s = new \Smarty();
		$app['php_tag']   = "<?php";
		$app['name']      = $this->appName;
		$app['namespace'] = $this->namespace;
		$app['tableAry']  = $this->tableAry;
		$s->assign("app",$app);

		$fileHeadAry = array("ENT", "DAO");
		foreach($fileHeadAry as $fileHead) {
			$filename = $outDirectory."/".$fileHead."_".$this->appName.".class.php";
			if (!is_file($filename)) {
				$data = $s->fetch(__DIR__."/templates/".$fileHead.".tpl");
				file_put_contents($filename, $data);
			}
		}
	}

}


