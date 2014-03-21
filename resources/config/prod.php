<?php
if (!defined (ACTESAPI_IMPORT)) $app['log.level'] = Monolog\Logger::ERROR;
$app['api.version'] = "v1";
$app['api.endpoint'] = "/api";
$app['db.driver'] = 'pdo_sqlite';
$app['db.name'] = 'app.db';
$app['api.secret'] = 'tslsmdpduCDGlot-46';
