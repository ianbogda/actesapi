<?php

namespace App;

use Silex\Application;

class RoutesLoader
{
    private $app;

    public function __construct(Application $app)
    {
        $this->app = $app;
        $this->instantiateControllers();

    }

    private function instantiateControllers()
    {
        $this->app['naturesactes.controller'] = $this->app->share(function () {
            return new Controllers\NaturesActesController($this->app['naturesactes.service']);
        });

        $this->app['matieres.controller'] = $this->app->share(function () {
            return new Controllers\MatieresController($this->app['matieres.service']);
        });

        $this->app['actes.controller'] = $this->app->share(function () {
            return new Controllers\ActesController($this->app['actes.service']);
        });

    }

    public function bindRoutesToControllers()
    {
        $api = $this->app["controllers_factory"];

/*        $api->get('/notes', "notes.controller:getAll");
        $api->post('/notes', "notes.controller:save");
        $api->post('/notes/{id}', "notes.controller:update");
        $api->delete('/notes/{id}', "notes.controller:delete");
 */

        $api->get('/coll/{siren}/naturesactes', "naturesactes.controller:getAll");

        $api->get('/coll/{siren}/matieres', "matieres.controller:getAll");

        $api->get('/coll/{siren}/actes', "actes.controller:getAll");
        $api->get('/coll/{siren}/actes/total', "actes.controller:getCount");
        $api->get('/coll/{siren}/actes/page/{page}', "actes.controller:getAllPage");
        $api->get('/coll/{siren}/actes/pagination/{perpage}', "actes.controller:getAllPerPage");
        $api->get('/coll/{siren}/actes/page/{page}/pagination/{perpage}', "actes.controller:getAllPagePerpage");

        $api->get('/acte/{acteid}', "actes.controller:getActe");
        $api->get('/acte/{acteid}/anomalie', "actes.controller:getAnomalie");
        $api->get('/acte/{acteid}/aracte', "actes.controller:getARActe");
        $api->get('/acte/{acteid}/annulation', "actes.controller:getAnnulation");
        $api->get('/acte/{acteid}/document', "actes.controller:document");
        $api->get('/acte/{acteid}/document/tampon', "actes.controller:tampon");

        $this->app->mount($this->app["api.endpoint"].'/'.$this->app["api.version"], $api);
    }
}

