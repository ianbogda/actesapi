<?php

namespace App\Services;

class NaturesActesService extends BaseService
{
    public function getAll($siren)
    {
        $sql = "SELECT
                    CodeNatureActe AS value,
                    Libelle
                FROM NaturesActes
                WHERE %s";
        $sql = str_replace('%s', ( $siren ? 'siren='.$siren : 1), $sql);
        return $this->db->fetchAll($sql);
    }
}
