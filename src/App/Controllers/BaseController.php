<?php

namespace App\Controllers;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use App;


class BaseController
{

    protected $service;

    public function __construct($service)
    {
        $this->service = $service;
    }

    protected function authentication($request)
    {
        return $this->service->authentication($request);
    }

}
