<?php

namespace App\Controllers;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

use App;

class NaturesActesController extends BaseController
{
    public function getAll($siren = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAll($siren));
    }
}
