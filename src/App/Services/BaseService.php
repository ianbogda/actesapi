<?php

namespace App\Services;

class BaseService
{
    protected $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function authentication($request)
    {
        // Check if authorized or not
        $publicHash  = $request->headers->get('X-Public');
        $contentHash = $request->headers->get('X-Hash');
        $privateHash = $this->db->fetchAll("SELECT privateHash FROM users WHERE publicHash='{$publicHash}'");

        $privateHash = $privateHash[0]['privateHash'];

        $content     = $_SERVER['REDIRECT_URL'];
        $hash = hash_hmac('sha256', $content, $privateHash);

        if ($contentHash != $hash)
            return array('statusCode' => 401, 'message' => 'Unauthorized');

        return $this->db->fetchAll("SELECT privateHash FROM users WHERE publicHash='{$publicHash}'");
    }
}
