<?php

namespace App\Controllers;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

use App;


class ActesController extends BaseController
{

    public function getCount($siren, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getCount($siren));
    }

    public function getAll($siren, Request $request)
    {
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAll($siren));
    }

    public function getAllPage($siren, $page = 1, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAll($siren, $page));
    }

    public function getAllPerpage($siren, $perpage = 10, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAll($siren, null, $perpage));
    }

    public function getAllPagePerpage($siren, $page = 1, $perpage = 10, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAll($siren, $page, $perpage));
    }

    public function getActe($acteid = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getActe($acteid));
    }

    public function getAnomalie($acteid = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAnomalie($acteid));
    }

    public function getARActe($acteid = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getARActe($acteid));
    }

    public function getAnnulation($acteid = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        return new JsonResponse($this->service->getAnnulation($acteid));
    }

    protected function original($acteid = null, $tampon = false)
    {
        $doc = !!$tampon ? $this->service->tampon($acteid) : $this->service->document($acteid);

        /* SI il n'y a rien dans la base on retourne d'où l'on vient */
        if (!isset($doc[0])) return false;

        $doc = $doc[0];

        list($DPT, $SIREN, $DATEACTE, $NUMACTE) = explode('-', $doc['IDActe']);
        $enveloppe = "{$doc['env_ITC']}-{$doc['Formulaire']}";

        $src = realpath(ACTES_PATH) . "/{$SIREN}/{$NUMACTE}/{$enveloppe}.tar.gz";
        $enveloppe = glob($src);
        $file = $enveloppe[0]. "/" . $doc['DocumentNomFichier'];

        /* récupération infos du fichier */
        $pathinfo = pathinfo("phar://" . $file );
        $pathinfo['dirname'] = $file;

        /* ajoutons quelques infos pour l'affichage dans le tampon */
        if (!!$tampon)
        {
            $pathinfo['envoi_date'] = preg_replace('/(\d{4}).*(\d{2}).*(\d{2})/', '$3/$2/$1', $doc['dateacte']);
            $pathinfo['recu_date']  = preg_replace('/(\d{4}).*(\d{2}).*(\d{2})/', '$3/$2/$1', $doc['DateReception']);
            $pathinfo['IDActe']     = $doc['IDActe'];
        }

        return $pathinfo;
    }

    public function document($acteid = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        if ($pathinfo = $this->original($acteid))
        {
            $ext = $pathinfo['extension'];
            $contentType = ('pdf' == $ext) ? 'application' : 'image';
            /* Renvoi du fichier */
            header("Content-type: {$contentType}/{$ext}");
            header('Content-Disposition: attachment; filename="'. $pathinfo['basename'] . '"');
            header('Content-Length: '.filesize("phar://" . $pathinfo['dirname']));
            readfile("phar://" . $pathinfo['dirname']);
        }
        else return new JsonResponse(false);
    }

    public function tampon($acteid = null, Request $request)
    {
        $auth = $this->authentication($request);
        if (isset($auth['statusCode']) && 401 === $auth['statusCode']) return new JsonResponse ($auth);

        if ($pathinfo = $this->original($acteid, true))
        {
            try {
                    $pdf = \Zend_Pdf::load("phar://" . $pathinfo['dirname']);
                    $tampon = new App\TamponPDF($pdf);
                    $tampon->setText(array(
                        $pathinfo['IDActe'],
                        "Envoyé en préfecture le " . $pathinfo['envoi_date'],
                        "Reçu en préfecture le "   . $pathinfo['recu_date'],
                    ));

                    $tampon->setFileSize(filesize("phar://" . $pathinfo['dirname']));
                    $tampon->setNameFile($pathinfo['basename']);
                    $tampon->render();
            } catch (Exception $e){
                return $this->document($acteid, $request);
            }
        }
        else return new JsonResponse(false);
    }
}
