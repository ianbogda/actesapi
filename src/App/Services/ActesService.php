<?php

namespace App\Services;

class ActesService extends BaseService
{
    public function getAll($siren, $page = null, $perpage = null)
    {
        $debut = ($page - 1 ) * $perpage;

        $sql = "SELECT
               ac.acteid
               ,ac.aracteid
               ,ac.anomalieacteid
               ,ac.annulationacteid
               ,ac.dateacte
               ,ac.NumeroInterne
               ,ac.Objet
               ,ac.CodeNatureActeNom
               ,ar.DateReception AS dateARPref
               ,ac.siren
            FROM
                Acte ac
                ,ARActe ar
            WHERE ac.siren IN (".$siren.")
                AND ac.aracteid=ar.aracteid";
//            LIMIT {$perpage} OFFSET {$page}";

        return $this->db->fetchAll($sql);
    }

    public function getActe($acteid)
    {
        return $this->db->fetchAll("SELECT
                ac.acteid
               ,ac.aracteid
               ,ac.anomalieacteid
               ,ac.annulationacteid
               ,ac.dateacte
               ,ac.NumeroInterne
               ,ac.Objet
               ,ac.CodeNatureActeNom
               ,ac.CodeMatiereNom
               ,ac.DocumentNomFichier
               ,IDActe
               ,cm.EmetteurReferentNom
               ,cm.env_DATE
           FROM
                Acte ac
                ,EnveloppeCLMISILL cm
           WHERE
               ac.acteid={$acteid}
               AND ac.messageid=cm.messageid
        ");
    }

    public function getAnomalie($acteid)
    {
        return $this->db->fetchAll("SELECT
                an.DateReception
               ,an.Nature
               ,an.Detail
           FROM
                Acte ac
                ,AnomalieActe an
           WHERE
               ac.acteid={$acteid}
               AND ac.anomalieacteid=an.anomalieid
        ");
    }

    public function getARActe($acteid)
    {
        return $this->db->fetchAll("SELECT
                ar.DateReception
           FROM
                Acte ac
                ,ARActe ar
           WHERE
               ac.acteid={$acteid}
               AND ac.aracteid=ar.aracteid
        ");
    }

    public function getAnnulation($acteid)
    {
        return $this->db->fetchAll("SELECT
                an.DateReception
           FROM
                Acte ac
                ,Annulation an
                ,ARAnnulation arn
           WHERE
               ac.acteid={$acteid}
               AND ac.annulationacteid=arn.annulationid
               AND ac.IDActe=arn.IDActe
        ");
    }

    public function document($acteid)
    {
        return $this->db->fetchAll("SELECT * FROM Acte a, EnveloppeCLMISILL cm  WHERE acteid={$acteid} ");
    }

    public function tampon($acteid)
    {
        
        return $this->db->fetchAll("SELECT * FROM Acte a, ARActe ar, EnveloppeCLMISILL cm  WHERE a.acteid={$acteid} AND ar.aracteid=a.aracteid");
    }
}
