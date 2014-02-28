<?php

namespace App;

use Silex\Application;

class ServicesLoader
{
    protected $app;

    public function __construct(Application $app)
    {
        $this->app = $app;
    }

    public function bindServicesIntoContainer()
    {
/*
        $this->app['notes.service'] = $this->app->share(function () {
            return new Services\NotesService($this->app["db"]);
        });
 */

        $this->app['naturesactes.service'] = $this->app->share(function () {
            return new Services\NaturesActesService($this->app["db"]);
        });

        $this->app['matieres.service'] = $this->app->share(function () {
            return new Services\MatieresService($this->app["db"]);
        });

        $this->app['actes.service'] = $this->app->share(function () {
            return new Services\ActesService($this->app["db"]);
        });
    }
}

