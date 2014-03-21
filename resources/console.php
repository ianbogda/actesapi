<?php 
define('ACTESAPI_IMPORT', true);
require_once __DIR__ . '/../vendor/autoload.php';
$app = new Silex\Application();
use Silex\Provider\MonologServiceProvider;
require __DIR__ . '/config/prod.php';
/*
Nommage flux
DPT-SIREN-DATEACTE-NUMACTE-NATUREACTE-CODEMSG_NUMERO

DPT        : ([0-9]{3}|02[AB])
SIREN      : ([0-9]{9})
DATEACTE   : (([0-9]{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1]))
NUMACTE    : ([_A-Z0-9]{1,15})
NATUREACTE : (DE|AR|AI|CC|BF|AU)
CODEMESG   : (1-1|1-2|1-3|6-1|6-2|7-1|7-2|7-3)
NUMERO     : ([0-9]{1,4})


Identifiants Contrôle légalité
Préfectures      : PREF[0-9]{3}
Sous-préfectures : SPREF[0-9]{3}[0-9]
SGAR             : SGAR[0-9]{3}

Identifiant unique d’un acte
DPT        : ([0-9]{3}|02[AB])
SIREN      : ([0-9]{9})
DATEACTE   : (([0-9]{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1]))
NUMACTE    : ([_A-Z]{1,15})
NATUREACTE : (DE|AR|AI|CC|BF|AU)

Nommage des fichiers compressés
ITC-NOMFICHIERENVELOPPE.tar.gz
ITC                 : [A-Z]{3}
NOMFICHIERENVELOPPE : APPLI-INFO_APPLI-EMETTEUR-DESTINATAIRE-DATE-NUMERO

APPLI-INFO_APPLI-EMETTEUR-DESTINATAIRE-DATE-NUMERO
APPLI        : ([FQETD][A-Z]{3})
INFO_APPLI   : (.*)
EMETTEUR     : (.*)
DESTINATAIRE : (.*)
DATE         : (([0-9]{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1]))
NUMERO       : ([0-9]{1-4})

coll -> pref
EACT--SIREN--DATE-NUMERO.xml
pref -> coll
EACT--SERVICE-SIREN-DATE-NUMERO.xml
SERVICE cf Identifiants Contrôle légalité
ANO_EACT--SERVICE-SIREN-DATE-NUMERO.xml

Cas particulier demande classification
DPT-SIREN----CODEMSG_NUMERO

Demande classification
046-([09]{9})----(7-1)_([0-9]{1-4})
envoi classification
046-([09]{9})----(7-2)_([0-9]{1-4})
classification à jour
046-([09]{9})----(7-3)_([0-9]{1-4})
 */

class actes
{
    protected $ITC          = 'SLO';
    protected $APPLI        = '([FQETD][A-Z]{3})';
    protected $INFO_APPLI   = '';
    protected $EMETTEUR     = '(.*)';
    protected $DESTINATAIRE = '(.*)';
    protected $DATE         = '(([0-9]{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1]))';
    protected $NUMERO       = '([0-9]{1,4})';
    protected $NUMACTE      = '([_A-Z0-9]{1,15})';
    protected $CODEMESG     = '(1-1|1-2|1-3|6-1|6-2|7-1|7-2|7-3)';

    protected $Acte                  = array();
    protected $ARActe                = array();
    protected $AnomalieActe          = array();
    protected $DemandeClassification = array();
    protected $RetourClassification  = array();
    protected $EnveloppeCLMISILL     = array();
    protected $EnveloppeMISILLCL     = array();

    protected $db;
    protected $tables = array(
        'users',
        'collectivites',
    );

    public function __construct($db, $options = null)
    {
        global $app;

        $this->db = new PDO('sqlite:'.$db);
        $options = (array) $options;

        /* create tables si elle n'existe pas */
        $r = $this->db->query("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;");
        if (0 == count($r->fetchAll()))
        {
            $schema = __DIR__ . '/sql/schema.sql';
            echo "\033[0;33mCréation de la base : {$db}\033[0m\n";
            echo "\033[0;31m/!\ \033[0m Importation du fichier {$schema}\n";
            $rr = exec("cat {$schema} | sqlite3 {$db}");
            echo "Base créée et peuplée\n";
        }
        else echo "La base {$db} existe.\n";

        /* création utilisateur */
        if (isset($options['user']))
        {
            $key  = hash_hmac('sha256', $options['user'], $app['api.secret']);
            $hash = hash_hmac('sha256', $key, $app['api.secret']);

            $this->db->exec("INSERT INTO users (nom, publicHash, privateHash) VALUES (
'{$options['user']}', '{$key}', '{$hash}');");

            echo "\033[0;33mCréation de l'utilisateur {$options['user']} \033[0m
\033[0;33mAPIKey    :\033[0m {$key}
\033[0;33mAPISecret :\033[0m {$hash}
";
        }
    }

    public function populate($path, $collectivites = array())
    {
        try {
            $this->db->setAttribute(
                PDO::ATTR_ERRMODE,
                PDO::ERRMODE_EXCEPTION
            );

            $target = dirname( $path ) . DIRECTORY_SEPARATOR;
            $colls  = $this->getTree($target);

            echo "Import des actes par collectivité\n";
            foreach($colls as $SIREN)
            {
                if (in_array($SIREN, $collectivites))
                { 
                    $transact = $trans7 = 0;
                    echo "\033[0;33mCollectivité : {$SIREN}\033[0m\n";
                    /* Si la collectivité n'existe pas dans la base, on l'ajoute */

                    $requete = $this->db->prepare("SELECT siren FROM collectivites WHERE siren=:SIREN");
                    if (!$result = $requete->execute(array('SIREN' => $SIREN)))
                    {
                        $requete = $this->db->prepare("INSERT INTO collectivites (siren) VALUES(:SIREN)");
                        $requete->execute(array('SIREN' => $SIREN));
                    }

                    $collPath = $target . $SIREN . DIRECTORY_SEPARATOR;

                    /* Récupération des transactions 7 */
                    $trans7 = $this->getEnveloppe($collPath, $SIREN);

                    /* Récupération des répertoires ACTES */
                    $actes = $this->getTree($collPath);
                    foreach($actes as $acte)
                    {
                        $transact += $this->getEnveloppe($collPath . $acte . DIRECTORY_SEPARATOR, $SIREN, $acte);
                    }

                    echo "{$trans7} demandes de classification importées\n";
                    echo "{$transact} transactions actes importés\n";
                }
            }
        } catch(PDOException $e) {
            echo $e->getMessage();
        }
    }

    protected function getEnveloppe($path, $SIREN = null, $ACTE = null)
    {
        $gz = $path . "{$this->ITC}-EACT--*.{tar.gz}";

        /* scan la coll pour récupérer les enveloppes classifications */

        $enveloppes = glob($gz, GLOB_BRACE);
        array_multisort(
           array_map( 'filemtime', $enveloppes ),
           SORT_NUMERIC,
           SORT_ASC,
           $enveloppes
        );

        foreach ($enveloppes as $enveloppe)
        {
            $enveloppe = preg_replace("/{$this->ITC}-/", '', basename($enveloppe, '.tar.gz'));

            /* Enveloppe CLMISILL ou MISILLCL */
            $CLMISILL = "EACT--{$SIREN}--{$this->DATE}-{$this->NUMERO}";
            $MISILLCL = "EACT--{$this->EMETTEUR}-{$SIREN}-{$this->DATE}-{$this->NUMERO}";

            if (preg_match("/{$CLMISILL}/", $enveloppe) || preg_match("/{$MISILLCL}/", $enveloppe))
            {
                list($APPLI, $INFO_APPLI, $EMETTEUR, $DESTINATAIRE, $DATE, $NUMERO) = explode('-', $enveloppe);

                /* get enveloppe */
                $xml = "phar://{$path}{$this->ITC}-{$enveloppe}.tar.gz/{$enveloppe}.xml";
                if (false !== ($xml = @file_get_contents($xml)))
                {
                    $x = ActesEnveloppeXML::getInfo($xml);
                    $date = filemtime("phar://{$path}{$this->ITC}-{$enveloppe}.tar.gz");

                    // traitement de l'enveloppe MISILLCL */
                    $table = $x['type'];
                    switch ($table)
                    {
                    case 'EnveloppeMISILLCL':
                        $this->{$table} = array(
                            'env_ITC'                => $this->ITC,
                            'env_APPLI'              => $APPLI,
                            'env_INFO_APPLI'         => $INFO_APPLI,
                            'env_EMETTEUR'           => $EMETTEUR,
                            'env_DESTINATAIRE'       => $DESTINATAIRE,
                            'env_DATE'               => $DATE,
                            'env_NUMERO'             => $NUMERO,
                            'EmetteurDepartement'    => $x['Emetteur']['Departement'],
                            'EmetteurArrondissement' => $x['Emetteur']['Arrondissement'],
                            'Emetteurtype'           => $x['Emetteur']['type'],
                            'NomFichier'             => $x['FormulairesEnvoyes'][0]['NomFichier'],
                            'Destinataire'           => $x['Destinataire'],
                        );
                        $messageid=$this->setEnveloppeMISILLCL($this->{$table});
                    break;
                    case 'EnveloppeCLMISILL':
                        $this->{$table} = array(
                            'env_ITC'                => $this->ITC,
                            'env_APPLI'                  => $APPLI,
                            'env_INFO_APPLI'             => $INFO_APPLI,
                            'env_EMETTEUR'               => $EMETTEUR,
                            'env_DESTINATAIRE'           => $DESTINATAIRE,
                            'env_DATE'                   => $DATE,
                            'env_NUMERO'                 => $NUMERO,
                            'EmetteurIDCLDepartement'    => $x['Emetteur']['IDCL']['Departement'],
                            'EmetteurIDCLArrondissement' => $x['Emetteur']['IDCL']['Arrondissement'],
                            'EmetteurIDCLNature'         => $x['Emetteur']['IDCL']['Nature'],
                            'EmetteurIDCLSIREN'          => $x['Emetteur']['IDCL']['SIREN'],
                            'EmetteurReferentNom'        => $x['Emetteur']['Referent'][0]['Nom'],
                            'EmetteurReferentTelephone'  => $x['Emetteur']['Referent'][0]['Telephone'],
                            'EmetteurReferentEmail'      => $x['Emetteur']['Referent'][0]['Email'][0],
                            'AdressesRetour'             => serialize($x['AdressesRetour']['Email']),
                            'NomFichier'                 => $x['FormulairesEnvoyes'][0]['NomFichier'],
                        );
                        $messageid=$this->setEnveloppeCLMISILL($this->{$table});
                    break;
                    }
                }

                /* get flux */
                if (isset($x['FormulairesEnvoyes']))
                { 
                    $FormulairesEnvoyesNomFichier = $x['FormulairesEnvoyes'][0]['NomFichier'];
                    $xml = "phar://{$path}{$this->ITC}-{$enveloppe}.tar.gz/{$FormulairesEnvoyesNomFichier}";
                    $x = MessageMetierXML::getInfo(file_get_contents($xml));
                    $table = $x['type'];

                    list($DPT, $SIREN, $DATEACTE, $NUMACTE, $NATUREACTE, $CODEMESG, $NUMERO) = explode('-', $FormulairesEnvoyesNomFichier);
                    list($CODEMESG2, $NUMERO) = explode('_', $NUMERO);
                    $CODEMESG = $CODEMESG . '-' . $CODEMESG2;

                    switch ($CODEMESG)
                    {
                    case '1-1':  // Dépôt d'un acte
                        $this->{$table} = array(
                            'dateacte'                  => $x['Date'],
                            'NumeroInterne'             => $x['NumeroInterne'],
                            'CodeNatureActe'            => $x['CodeNatureActe'],
                            'CodeMatiere1'              => (isset($x['CodeMatiere1'])) ? $x['CodeMatiere1'] : 0,
                            'CodeMatiere2'              => (isset($x['CodeMatiere2'])) ? $x['CodeMatiere2'] : 0,
                            'CodeMatiere3'              => (isset($x['CodeMatiere3'])) ? $x['CodeMatiere3'] : 0,
                            'CodeMatiere4'              => (isset($x['CodeMatiere4'])) ? $x['CodeMatiere4'] : 0,
                            'CodeMatiere5'              => (isset($x['CodeMatiere5'])) ? $x['CodeMatiere5'] : 0,
                            'Objet'                     => $x['Objet'],
                            'ClassificationDateVersion' => $x['ClassificationDateVersion'],
                            'Formulaire'                => $enveloppe,
                            'DocumentNomFichier'        => $x['Document']['NomFichier'],
                            'AnnexesNombre'             => isset($x['Annexes']['Nombre']) ? $x['Annexes']['Nombre'] : 0,
                            'AnnexesListe'              => (isset($x['Annexes']['Liste'])) ? $x['Annexes']['Liste'] : '',
                            'IDActe'                    => implode('-', array($DPT, $SIREN, $DATEACTE, $NUMACTE, $NATUREACTE)),
                            'messageid'                 => $messageid,
                        );
                        $this->setActe($this->{$table});
                    break;
                    case '1-2':  // ARActe
                        $this->{$table} = array(
                            'IDActe'                    => $x['IDActe'],
                            'DateReception'             => $x['DateReception'],
                            'ClassificationDateVersion' => $x['ActeRecu'][0]['ClassificationDateVersion'],
                            'messageid'                 => $messageid,
                        );
                        $this->setARActe($this->{$table});
                    break;
                    case '1-3':  // AnomalieActe
                        $this->{$table} = array(
                            'DateReception' => is_array($x['Date']) ? $x['Date'][0] : $x['Date'],
                            'Nature'        => is_array($x['Nature']) ? $x['Nature'][0] : $x['Nature'],
                            'Detail'        => is_array($x['Detail']) ? $x['Detail'][0] : $x['Detail'],
                            'IDActe'        => implode('-', array($DPT, $SIREN, $DATEACTE, $NUMACTE, $NATUREACTE)),
                            'messageid'     => $messageid,
                        );
                        $this->AnomalieActe($this->{$table});
                    break;
                    case '6-1':  // Annulation
                        $this->{$table} = array(
                            'IDActe'        => $x['IDActe'],
                            'messageid'     => $messageid,
                        );
                        $this->Annulation($this->{$table});
                    break;
                    case '6-2': // ARAnnulation
                        $this->{$table} = array(
                            'IDActe'        => $x['IDActe'],
                            'DateReception' => $x['DateReception'],
                            'messageid'     => $messageid,
                        );
                        $this->ARAnnulation($this->{$table});
                    break;
                    case '7-1':  // DemandeClassification
                        $x = DemandeClassificationXML::getInfo(file_get_contents($xml));
                        $this->{$table} = array(
                            'siren'              => $SIREN,
                            'DateClassification' => $x['DateClassification'],
                            'messageid'          => $messageid,
                        );
                        $this->DemandeClassification($this->{$table});
                    break;
                    case '7-2': // RetourClassification
                        $x = RetourClassificationXML::getInfo(file_get_contents($xml));
                        $this->{$table} = array(
                            'siren'              => $SIREN,
                            'DateClassification' => $x['DateClassification'],
                            'NaturesActes'       => $x['NaturesActes'][0],
                            'Matieres'           => $x['Matieres'][0],
                            'messageid'          => $messageid,
                        );
                        $this->RetourClassification($this->{$table});
                    break;
                    }
                }
            }
        }

        return count($enveloppes);
    }

    protected function DemandeClassification($data)
    {
    }

    protected function RetourClassification($data)
    {
        /* MAJ NaturesActes */
        $sql = "SELECT *
                FROM NaturesActes
                WHERE
                    siren='{$data['siren']}'
                    AND DateClassification='{$data['DateClassification']}'";
        $r = $this->db->query($sql);

        if (false == $r->fetch(PDO::FETCH_ASSOC))
        {
            /* populate NaturesActes */
            $sql = 'INSERT INTO NaturesActes
                    (
                        siren
                        ,DateClassification
                        ,CodeNatureActe
                        ,Libelle
                        ,TypeAbrege
                    )
                    VALUES
                    (
                        :siren
                        , :DateClassification
                        , :CodeNatureActe
                        , :Libelle
                        , :TypeAbrege
                    )';
            $requete = $this->db->prepare($sql);
            $datas = array('siren' => $data['siren'], 'DateClassification' => $data['DateClassification']);
            foreach($data['NaturesActes'] as $natureActe)
            {
                $datas['CodeNatureActe'] = $natureActe['CodeNatureActe'];
                $datas['Libelle']        = $natureActe['Libelle'];
                $datas['TypeAbrege']     = $natureActe['TypeAbrege'];
                $requete = $this->db->prepare($sql);
                $requete->execute($datas);
            }
        }

        /* MAJ CodeMatieres */
        $sql = "SELECT *
                FROM CodeMatieres
                WHERE
                    siren='{$data['siren']}'
                    AND DateClassification='{$data['DateClassification']}'";
        $r = $this->db->query($sql);

        if (false == $r->fetch(PDO::FETCH_ASSOC))
        {
        /* populate CodeMatieres */
            $sql = 'INSERT INTO CodeMatieres
                    (
                        siren
                        ,DateClassification
                        ,CodeMatiere1
                        ,CodeMatiere2
                        ,CodeMatiere3
                        ,CodeMatiere4
                        ,CodeMatiere5
                        ,Libelle
                    )
                    VALUES
                    (
                        :siren
                        , :DateClassification
                        , :CodeMatiere1
                        , :CodeMatiere2
                        , :CodeMatiere3
                        , :CodeMatiere4
                        , :CodeMatiere5
                        , :Libelle
                    )';
            
            $datas = array('siren' => $data['siren'], 'DateClassification' => $data['DateClassification']);
            foreach($data['Matieres'] as $matiere)
            {
                $datas['CodeMatiere1'] = $matiere['CodeMatiere'];
                $datas['CodeMatiere2'] = 0;
                $datas['CodeMatiere3'] = 0;
                $datas['CodeMatiere4'] = 0;
                $datas['CodeMatiere5'] = 0;

                if (isset($matiere['Matiere2']))
                {
                    foreach($matiere['Matiere2'] as $matiere2)
                    {
                        $datas['CodeMatiere2'] = $matiere2['CodeMatiere'];
                        $datas['Libelle']      = utf8_decode($matiere['Libelle'] .' / ' . $matiere2['Libelle']);
                        if (isset($matiere2['Matiere3']))
                        {
                            foreach($matiere2['Matiere3'] as $matiere3)
                            {
                                $datas['CodeMatiere3'] = $matiere3['CodeMatiere'];
                                $datas['Libelle']      = utf8_decode($matiere['Libelle'] .' / ' . $matiere2['Libelle'] . ' / ' . $matiere3['Libelle']);
                                if (isset($matiere3['Matiere4']))
                                {
                                    foreach($matiere3['Matiere4'] as $matiere4)
                                    {
                                        $datas['CodeMatiere4'] = $matiere4['CodeMatiere'];
                                        $datas['Libelle']      = utf8_decode($matiere['Libelle'] .' / ' . $matiere2['Libelle'] . ' / ' . $matiere3['Libelle'] . ' / ' . $matiere4['Libelle']);
                                        if (isset($matiere4['Matiere5']))
                                        {
                                            foreach($matiere4['Matiere4'] as $matiere5)
                                            {
                                                $datas['CodeMatiere5'] = $matiere5['CodeMatiere'];
                                                $datas['Libelle']      = utf8_decode($matiere['Libelle'] .' / ' . $matiere2['Libelle'] . ' / ' . $matiere3['Libelle'] . ' / ' . $matiere4['Libelle'] . ' / ' . $matiere5['Libelle']);

                                                $requete = $this->db->prepare($sql);
                                                $requete->execute($datas);
                                            }
                                        }
                                        else
                                        {
                                            $requete = $this->db->prepare($sql);
                                            $requete->execute($datas);
                                        }
                                    }
                                }
                                else
                                {
                                    $requete = $this->db->prepare($sql);
                                    $requete->execute($datas);
                                }
                            }
                        }
                        else
                        {
                            $requete = $this->db->prepare($sql);
                            $requete->execute($datas);
                        }
                    }
                }
                else
                {
                    $datas['Libelle'] = utf8_decode($matiere['Libelle']);

                    $requete = $this->db->prepare($sql);
                    $requete->execute($datas);
                }
            }
        }
    }

    protected function ARAnnulation($data)
    {
        $sql = 'INSERT or IGNORE INTO ARAnnulation
            (
                IDActe
                ,DateReception
                ,messageid
            )
            VALUES
            (
                :IDActe
                , :DateReception
                , :messageid
            )';
        $requete = $this->db->prepare($sql);
        $requete->execute($data);
        if ($id = $this->db->lastInsertId())
        {
            /* test si l'annulation de l'acte est déjà renseigné */
            $this->db->exec("UPDATE Annulation SET annulationarid={$id} WHERE IDActe='{$data['IDActe']}'");
        }
    }

    protected function Annulation($data)
    {
        $sql = 'INSERT or IGNORE INTO Annulation
            (
                IDActe
                ,messageid
            )
            VALUES
            (
                :IDActe
                , :messageid
            )';
        $requete = $this->db->prepare($sql);
        $requete->execute($data);
        if ($id = $this->db->lastInsertId())
        {
            /* test si l'acte est déjà renseigné */
            $this->db->exec("UPDATE Acte SET annulationacteid={$id} WHERE IDActe='{$data['IDActe']}'");
        }
    }

    protected function AnomalieActe($data)
    {
        $sql = 'INSERT or IGNORE INTO AnomalieActe
            (
                IDActe
                ,DateReception
                ,Nature
                ,Detail
                ,messageid
            )
            VALUES
            (
                :IDActe
                , :DateReception
                , :Nature
                , :Detail
                , :messageid
            )';

        $requete = $this->db->prepare($sql);
        $requete->execute($data);
        if ($id = $this->db->lastInsertId())
        {
            /* test si l'acte est déjà renseigné */
            $this->db->exec("UPDATE Acte SET anomalieacteid={$id} WHERE IDActe='{$data['IDActe']}'");
        }
    }

    protected function setARActe($data)
    {
        $sql = 'INSERT or IGNORE INTO ARActe
            (
                IDActe
                ,DateReception
                ,ClassificationDateVersion
                ,messageid
            )
            VALUES
            (
                :IDActe
                , :DateReception
                , :ClassificationDateVersion
                , :messageid
            )';
        $requete = $this->db->prepare($sql);
        $requete->execute($data);
        if ($id = $this->db->lastInsertId())
        {
            /* test si l'acte est déjà renseigné */
            $this->db->exec("UPDATE Acte SET aracteid={$id} WHERE IDActe='{$data['IDActe']}'");
        }
    }

    protected function setActe($data)
    {
        list($DPT, $SIREN) = explode ('-', $data['IDActe']);
        $data['siren'] = $SIREN;

        $sql = "SELECT Libelle AS CodeNatureActeNom
                FROM NaturesActes
                WHERE DateClassification='{$data['ClassificationDateVersion']}'
                    AND siren='{$SIREN}'
                    AND CodeNatureActe='{$data['CodeNatureActe']}'";
        $NatureActe = $this->db->query($sql)->fetch(PDO::FETCH_ASSOC);
        $data['CodeNatureActeNom'] = $NatureActe['CodeNatureActeNom'];

        $sql = "SELECT Libelle AS CodeMatiereNom
                FROM CodeMatieres
                WHERE DateClassification='{$data['ClassificationDateVersion']}'
                    AND siren='{$SIREN}'
                    AND CodeMatiere1='{$data['CodeMatiere1']}'
                    AND CodeMatiere2='{$data['CodeMatiere2']}'
                    AND CodeMatiere3='{$data['CodeMatiere3']}'
                    AND CodeMatiere4='{$data['CodeMatiere4']}'
                    AND CodeMatiere5='{$data['CodeMatiere5']}'";
        $Matiere =  $this->db->query($sql)->fetch(PDO::FETCH_ASSOC);
        $data['CodeMatiereNom'] = $Matiere['CodeMatiereNom'];

        $sql = 'INSERT or IGNORE INTO Acte
            (
                dateacte
                ,NumeroInterne
                ,CodeNatureActe
                ,CodeNatureActeNom
                ,CodeMatiere1
                ,CodeMatiere2
                ,CodeMatiere3
                ,CodeMatiere4
                ,CodeMatiere5
                ,CodeMatiereNom
                ,Objet
                ,ClassificationDateVersion
                ,Formulaire
                ,DocumentNomFichier
                ,NomFichier
                ,AnnexesNombre
                ,AnnexesListe
                ,IDActe
                ,siren
                ,messageid
            )
            VALUES
            (
                :dateacte
                , :NumeroInterne
                , :CodeNatureActe
                , :CodeNatureActeNom
                , :CodeMatiere1
                , :CodeMatiere2
                , :CodeMatiere3
                , :CodeMatiere4
                , :CodeMatiere5
                , :CodeMatiereNom
                , :Objet
                , :ClassificationDateVersion
                , :Formulaire
                , :DocumentNomFichier
                , :NomFichier
                , :AnnexesNombre
                , :AnnexesListe
                , :IDActe
                , :siren
                , :messageid
            )';
        $requete = $this->db->prepare($sql);
        $requete->execute($data);
    }

    protected function setEnveloppeMISILLCL($data)
    {
        $sql = 'INSERT or IGNORE INTO EnveloppeMISILLCL
            (
                env_ITC
                ,env_APPLI
                ,env_INFO_APPLI
                ,env_EMETTEUR
                ,env_DESTINATAIRE
                ,env_DATE
                ,env_NUMERO
                ,EmetteurDepartement
                ,EmetteurArrondissement
                ,Emetteurtype
                ,NomFichier
                ,Destinataire
            )
            VALUES
            (
                :env_ITC
                , :env_APPLI
                , :env_INFO_APPLI
                , :env_EMETTEUR
                , :env_DESTINATAIRE
                , :env_DATE
                , :env_NUMERO
                , :EmetteurDepartement
                , :EmetteurArrondissement
                , :Emetteurtype
                , :NomFichier
                , :Destinataire
            )';
        $requete = $this->db->prepare($sql);
        $requete->execute($data);
        $messageid= $this->db->lastInsertID();

        return $messageid;
    }

    protected function setEnveloppeCLMISILL($data)
    {
        $sql = 'INSERT or IGNORE INTO EnveloppeCLMISILL
            (
                env_ITC
                ,env_APPLI
                ,env_INFO_APPLI
                ,env_EMETTEUR
                ,env_DESTINATAIRE
                ,env_DATE
                ,env_NUMERO
                ,EmetteurIDCLDepartement
                ,EmetteurIDCLArrondissement
                ,EmetteurIDCLNature
                ,EmetteurIDCLSIREN
                ,EmetteurReferentNom
                ,EmetteurReferentTelephone
                ,EmetteurReferentEmail
                ,AdressesRetour
                ,NomFichier
            )
            VALUES
            (
                :env_ITC
                , :env_APPLI
                , :env_INFO_APPLI
                , :env_EMETTEUR
                , :env_DESTINATAIRE
                , :env_DATE
                , :env_NUMERO
                , :EmetteurIDCLDepartement
                , :EmetteurIDCLArrondissement
                , :EmetteurIDCLNature
                , :EmetteurIDCLSIREN
                , :EmetteurReferentNom
                , :EmetteurReferentTelephone
                , :EmetteurReferentEmail
                , :AdressesRetour
                , :NomFichier
            )';
        $requete = $this->db->prepare($sql);
        $requete->execute($data);
        $messageid= $this->db->lastInsertID();

        /* MAJ table collectivites si nécessaire */
        $sql = "UPDATE collectivites SET
                    departementcode     = :EmetteurIDCLDepartement
                    ,arrondissementcode = :EmetteurIDCLArrondissement
                    ,Nature             = :EmetteurIDCLNature
                WHERE SIREN= :EmetteurIDCLSIREN AND departementcode=NULL";
        $requete = $this->db->prepare($sql);
        $requete->execute(
            array(
                'EmetteurIDCLDepartement'    => $data['EmetteurIDCLDepartement'],
                'EmetteurIDCLArrondissement' => $data['EmetteurIDCLArrondissement'],
                'EmetteurIDCLNature'         => $data['EmetteurIDCLNature'],
                'EmetteurIDCLSIREN'          => $data['EmetteurIDCLSIREN'],
            )
        );

        return $messageid;
    }

    protected function getTree($target)
    {
        $tree = array();
        $weeds  = array('.', '..');
        $directories = array_diff(scandir($target), $weeds);
        foreach($directories as $value)
        {
            if (is_dir($target.$value))
            {
                $tree[] = $value;
            }
        }

        return $tree;
    }
}

class XML2Array
{
    private $namespaces;
    private $uniqueNode;
    private $remonteNode;

    public function __construct()
    {
        $this->uniqueNode = array();
        $this->remonteNode = array();
    }

    public function setUniqueNode(array $nodeName)
    {
        $this->uniqueNode = $nodeName;
    }

    public function setNode2Remonte(array $nodeName)
    {
        $this->remonteNode = $nodeName;
    }

    public function getArray($xml_content)
    {
        $root = simplexml_load_string($xml_content);
        $this->namespaces = $root->getDocNamespaces(true);
        $this->namespaces[''] = '';
        $result['type'] = $root->getName();
        $result += $this->getChildNode($root);

        return $result;
    }

    private function isUniqueNode($nodeName)
    {
        return in_array($nodeName,$this->uniqueNode) ;
    }

    private function getChildNode($node)
    {
        $result = false;
        foreach ($this->namespaces as $namespace => $namespaceUrl)
        {
            foreach ($node->attributes($namespaceUrl) as $a => $b)
            {
                $result[strval($a)] = strval($b);
            }
            foreach ($node->children($namespaceUrl) as $b)
            {
                if ($this->isUniqueNode($b->getName()))
                {
                    $result[$b->getName()] = $this->getChildNode($b);
                }
                else
                {
                    $result[$b->getName()][] = $this->getChildNode($b);
                }
            }
            if (trim(strval($node)))
            {
                $result = strval($node);
            }
        }
        foreach($this->remonteNode as $node)
        {
            if (is_array($result) && isset($result[$node]))
            {
                $result = $result[$node];
            }
        }

        return $result;
    }
}

class DemandeClassificationXML
{
    public function getInfo($xml_content)
    {
        $XML2Array = new XML2Array();
        $XML2Array->setUniqueNode(
            array(
                'DateClassification',
            )
        );
        $XML2Array->setNode2Remonte(array('NaturesActes'));
        $result = $XML2Array->getArray($xml_content);

        unset($result['schemaLocation']);

        return $result;
    }
}

class RetourClassificationXML
{
    public function getInfo($xml_content)
    {
        $XML2Array = new XML2Array();
        $XML2Array->setUniqueNode(
            array(
                'DateClassification',
                'CodeNatureActe',
                'Libelle',
                'TypeAbrege',
                'CodeMatiere',
            )
        );
        $XML2Array->setNode2Remonte(array('NatureActe','Matiere1'));
        $result = $XML2Array->getArray($xml_content);

        unset($result['schemaLocation']);

        return $result;
    }
}
class MessageMetierXML
{
    public function getInfo($xml_content)
    {
        $XML2Array = new XML2Array();
        $XML2Array->setUniqueNode(
            array(
                'CodeMatiere1',
                'CodeMatiere2',
                'CodeMatiere3',
                'CodeMatiere4',
                'CodeMatiere5',
                'NomFichier',
                'Annexes',
                'Document',
                'Motif',
                'InfosCourrierPref',
                'Objet',
                'ClassificationDateVersion',
                'PiecesJointes',
                'NatureIllegalite',
                'DateDepot',
                'DateClassification',
            )
        );
        $XML2Array->setNode2Remonte(array('CodeMatiere','Annexe','Matiere1'));
        $result = $XML2Array->getArray($xml_content);

        unset($result['schemaLocation']);

        return $result;
    }
}

class ActesEnveloppeXML
{
    public function getInfo($xml_content)
    {
        $XML2Array = new XML2Array();
        $XML2Array->setUniqueNode(
            array(
                'IDSGAR',
                'IDPref',
                'IDSousPref',
                'Destinataire',
                'IDCL',
                'Emetteur',
                'AdressesRetour',
                'Formulaire',
                'Nom',
                'Telephone',
                'NomFichier',
            )
        );
        $XML2Array->setNode2Remonte(array('Formulaire'));
        $result = $XML2Array->getArray($xml_content);

        unset($result['schemaLocation']);
        foreach(array('IDSGAR','IDPref','IDSousPref') as $type)
        {
            if (isset($result['Emetteur'][$type]))
            {
                $result['Emetteur']= $result['Emetteur'][$type];
                $result['Emetteur']['type'] = $type;
            }
        }
        if (isset($result['Destinataire']))
        {
            $result['Destinataire'] = $result['Destinataire']['SIREN'];
        }

        return $result;
    }
}

echo "
****************************************

    Import des actes s2low dans l'API

****************************************
";
$commands = array('create:user', 'list:user', 'import');
if (isset($argv[1]) && in_array($argv[1], $commands))
{
    switch($argv[1])
    {
    case 'list:user' :
        $db = new PDO('sqlite:/var/www/actesapi/app.db');
        $users = $db->query("SELECT nom FROM users")->fetchAll();
        echo "\033[0;33mListe des utilisateurs de l'API\033[0m\n";
        foreach($users as $user)
        {
            echo " {$user['nom']}\033[0m\n";
        }
    break;
    case 'create:user' :
        $options['user'] = $argv[2];
        $actes = new Actes('/var/www/actesapi/app.db', $options);
    break;
    case 'import' :
        if (!isset($argv[2])) continue;
        $colls = explode(',', $argv[2]);
        $actes = new Actes('/var/www/actesapi/app.db');
        $actes->populate( '/var/www/actesapi/storage/data/actes/.gitignore', $colls);
    break;
    }
}
else echo "
\033[0;33musage :\033[0m
console.php [commande] [options]
\033[0;33mcommandes :\033[0m
\tlist:user
\tcreate:user NOM
\timport siren1[,siren2]\n";
