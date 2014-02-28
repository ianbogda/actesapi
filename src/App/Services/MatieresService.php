<?php

namespace App\Services;

class matieresService extends BaseService
{
    public function getAll($siren)
    {
        $sql = "SELECT
                    CodeMatiere1 || '-' || CodeMatiere2 || '-' || CodeMatiere3 || '-' || CodeMatiere4 || '-' || CodeMatiere5 AS value,
                    Libelle
                FROM CodeMatieres
                WHERE %s";
        $sql = str_replace('%s', ( $siren ? 'siren='.$siren : 1), $sql);
        return $this->db->fetchAll($sql);
    }
}
