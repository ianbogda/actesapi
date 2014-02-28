/* Table users */
CREATE TABLE users (
    id           INTEGER PRIMARY KEY
    ,nom         VARCHAR
    ,publicHash  VARCHAR(32)
    ,privateHash VARCHAR(32)
);

/* Table collectivites */
CREATE TABLE collectivites (
    SIREN               INTEGER PRIMARY KEY
    ,nom                VARCHAR
    ,departementcode    VARCHAR(3)
    ,arrondissementcode VARCHAR(3)
    ,Nature             INTEGER
);

/* Table départements */
CREATE TABLE departements (
    departementid INTEGER PRIMARY KEY
    ,code         VARCHAR(3)
    ,nom         VARCHAR(128)
);

/* Table arrondissements */
CREATE TABLE arrondissements (
    arrondissementid INTEGER PRIMARY KEY
    ,departementid   INTEGER
    ,code            VARCHAR(3)
    ,nom            VARCHAR(128)
);

CREATE TABLE naturecollectivites (
    id           INTEGER PRIMARY KEY
    ,parentid    INTEGER
    ,description VARCHAR(512)
    ,messageid                 INTEGER
);
/* Table NaturesActes de l'acte */
CREATE TABLE NaturesActes (
    siren               INTEGER(9)
    ,DateClassification VARCHAR
    ,CodeNatureActe     INTEGER
    ,Libelle            VARCHAR NOT NULL
    ,TypeAbrege         VARCHAR NOT NULL
    ,messageid          INTEGER
);

/* Table CodeMatiere */
CREATE TABLE CodeMatieres (
    siren               INTEGER (9)
    ,CodeMatiere1       INTEGER NOT NULL DEFAULT 0
    ,CodeMatiere2       INTEGER NOT NULL DEFAULT 0
    ,CodeMatiere3       INTEGER NOT NULL DEFAULT 0
    ,CodeMatiere4       INTEGER NOT NULL DEFAULT 0
    ,CodeMatiere5       INTEGER NOT NULL DEFAULT 0
    ,Libelle            VARCHAR NOT NULL
    ,DateClassification VARCHAR
    ,messageid          INTEGER
);

CREATE TABLE Acte (
    acteid                     INTEGER PRIMARY KEY
    ,aracteid                  INTEGER DEFAULT NULL
    ,annulationacteid          INTEGER DEFAULT NULL
    ,annulationaracteid        INTEGER DEFAULT NULL
    ,dateacte                  VARCHAR DEFAULT NULL
    ,NumeroInterne             VARCHAR DEFAULT NULL
    ,CodeNatureActe            VARCHAR DEFAULT NULL
    ,CodeNatureActeNom         VARCHAR DEFAULT NULL
    ,CodeMatiere1              INTEGER DEFAULT 0
    ,CodeMatiere2              INTEGER DEFAULT 0
    ,CodeMatiere3              INTEGER DEFAULT 0
    ,CodeMatiere4              INTEGER DEFAULT 0
    ,CodeMatiere5              INTEGER DEFAULT 0
    ,CodeMatiereNom            VARCHAR DEFAULT NULL
    ,Objet                     VARCHAR DEFAULT NULL
    ,ClassificationDateVersion VARCHAR DEFAULT NULL
    ,Formulaire                VARCHAR UNIQUE
    ,DocumentNomFichier        VARCHAR DEFAULT NULL
    ,NomFichier                VARCHAR DEFAULT NULL
    ,AnnexesNombre             VARCHAR DEFAULT NULL
    ,AnnexesListe              VARCHAR DEFAULT NULL
    ,IDActe                    VARCHAR DEFAULT NULL
    ,messageid                 INTEGER
);

CREATE TABLE ARActe (
    aracteid                   INTEGER PRIMARY KEY
    ,IDActe                    VARCHAR DEFAULT NULL
    ,DateReception             VARCHAR DEFAULT NULL
    ,ClassificationDateVersion VARCHAR DEFAULT NULL
    ,messageid                 INTEGER
);

CREATE TABLE AnomalieActe (
    anomalieid     INTEGER PRIMARY KEY
    ,IDActe        VARCHAR DEFAULT NULL
    ,DateReception VARCHAR DEFAULT NULL
    ,Nature        VARCHAR DEFAULT NULL
    ,Detail        VARCHAR DEFAULT NULL
    ,messageid     INTEGER
);

CREATE TABLE Annulation (
    annulationid    INTEGER PRIMARY KEY
    ,IDActe         VARCHAR DEFAULT NULL
    ,annulationarid INTEGER DEFAULT NULL
    ,messageid      INTEGER
);

CREATE TABLE ARAnnulation (
    annulationarid  INTEGER PRIMARY KEY
    ,IDActe         VARCHAR DEFAULT NULL
    ,DateReception  VARCHAR DEFAULT NULL
    ,messageid      INTEGER
);

CREATE TABLE AnomalieActe (
    anomalieid     INTEGER PRIMARY KEY
    ,IDActe        VARCHAR DEFAULT NULL
    ,DateReception VARCHAR DEFAULT NULL
    ,Nature        VARCHAR DEFAULT NULL
    ,Detail        VARCHAR DEFAULT NULL
    ,messageid     INTEGER
);
CREATE TABLE Messages (
    messageid    INTEGER
    ,code        VARCHAR(3)
    ,description VARCHAR
    ,type        VARCHAR
);
CREATE UNIQUE INDEX IndexMessages ON Messages(code,type);

CREATE TABLE transactions(
    id            INTEGER PRIMARY KEY
    ,type         INTEGER
    ,parentid     INTEGER
    ,short        VARCHAR DEFAULT NULL
    ,description  VARCHAR DEFAULT NULL
);

CREATE TABLE EnveloppeMISILLCL (
    message_id              INTEGER PRIMARY KEY
    ,env_ITC                VARCHAR DEFAULT NULL
    ,env_APPLI              VARCHAR DEFAULT NULL
    ,env_INFO_APPLI         VARCHAR DEFAULT NULL
    ,env_EMETTEUR           VARCHAR DEFAULT NULL
    ,env_DESTINATAIRE       VARCHAR DEFAULT NULL
    ,env_DATE               VARCHAR DEFAULT NULL
    ,env_NUMERO             VARCHAR DEFAULT NULL
    ,EmetteurDepartement    VARCHAR DEFAULT NULL
    ,EmetteurArrondissement VARCHAR DEFAULT NULL
    ,Emetteurtype           VARCHAR DEFAULT NULL
    ,NomFichier             VARCHAR DEFAULT NULL
    ,Destinataire           VARCHAR DEFAULT NULL
);
CREATE UNIQUE INDEX IndexEnveloppeMISILLCL ON EnveloppeMISILLCL(env_APPLI, env_INFO_APPLI, env_EMETTEUR, env_DESTINATAIRE, env_DATE, env_NUMERO);

CREATE TABLE EnveloppeCLMISILL (
    message_id                  INTEGER PRIMARY KEY
    ,env_ITC                    VARCHAR DEFAULT NULL
    ,env_APPLI                  VARCHAR DEFAULT NULL
    ,env_INFO_APPLI             VARCHAR DEFAULT NULL
    ,env_EMETTEUR               VARCHAR DEFAULT NULL
    ,env_DESTINATAIRE           VARCHAR DEFAULT NULL
    ,env_DATE                   VARCHAR DEFAULT NULL
    ,env_NUMERO                 VARCHAR DEFAULT NULL
    ,EmetteurIDCLDepartement    VARCHAR DEFAULT NULL
    ,EmetteurIDCLArrondissement VARCHAR DEFAULT NULL
    ,EmetteurIDCLNature         VARCHAR DEFAULT NULL
    ,EmetteurIDCLSIREN          VARCHAR DEFAULT NULL
    ,EmetteurReferentNom        VARCHAR DEFAULT NULL
    ,EmetteurReferentTelephone  VARCHAR DEFAULT NULL
    ,EmetteurReferentEmail      VARCHAR DEFAULT NULL
    ,AdressesRetour             VARCHAR DEFAULT NULL
    ,NomFichier                 VARCHAR DEFAULT NULL
);
CREATE UNIQUE INDEX IndexEnveloppeCLMISILL ON EnveloppeCLMISILL(env_APPLI, env_INFO_APPLI, env_EMETTEUR, env_DESTINATAIRE, env_DATE, env_NUMERO);
/* populate db */


/* departements */
INSERT INTO departements (departementid, code, nom) VALUES (101, '001', "Ain");
INSERT INTO departements (departementid, code, nom) VALUES (102, '002', "Aisne");
INSERT INTO departements (departementid, code, nom) VALUES (103, '003', "Allier");
INSERT INTO departements (departementid, code, nom) VALUES (104, '004', "Alpes-de-Haute-Provence");
INSERT INTO departements (departementid, code, nom) VALUES (105, '005', "Hautes-Alpes");
INSERT INTO departements (departementid, code, nom) VALUES (106, '006', "Alpes-Maritimes");
INSERT INTO departements (departementid, code, nom) VALUES (107, '007', "Ardèche");
INSERT INTO departements (departementid, code, nom) VALUES (108, '008', "Ardennes");
INSERT INTO departements (departementid, code, nom) VALUES (109, '009', "Ariège");
INSERT INTO departements (departementid, code, nom) VALUES (110, '010', "Aube");
INSERT INTO departements (departementid, code, nom) VALUES (111, '011', "Aude");
INSERT INTO departements (departementid, code, nom) VALUES (112, '012', "Aveyron");
INSERT INTO departements (departementid, code, nom) VALUES (113, '013', "Bouches-du-Rhône");
INSERT INTO departements (departementid, code, nom) VALUES (114, '014', "Calvados");
INSERT INTO departements (departementid, code, nom) VALUES (115, '015', "Cantal");
INSERT INTO departements (departementid, code, nom) VALUES (116, '016', "Charente");
INSERT INTO departements (departementid, code, nom) VALUES (117, '017', "Charente-Maritime");
INSERT INTO departements (departementid, code, nom) VALUES (118, '018', "Cher");
INSERT INTO departements (departementid, code, nom) VALUES (119, '019', "Corrèze");
INSERT INTO departements (departementid, code, nom) VALUES (120, '02A', "Corse-du-Sud");
INSERT INTO departements (departementid, code, nom) VALUES (121, '02B', "Haute-Corse");
INSERT INTO departements (departementid, code, nom) VALUES (122, '021', "Côte-d'Or");
INSERT INTO departements (departementid, code, nom) VALUES (123, '022', "Côtes-d'Armor");
INSERT INTO departements (departementid, code, nom) VALUES (124, '023', "Creuse");
INSERT INTO departements (departementid, code, nom) VALUES (125, '024', "Dordogne");
INSERT INTO departements (departementid, code, nom) VALUES (126, '025', "Doubs");
INSERT INTO departements (departementid, code, nom) VALUES (127, '026', "Drôme");
INSERT INTO departements (departementid, code, nom) VALUES (128, '027', "Eure");
INSERT INTO departements (departementid, code, nom) VALUES (129, '028', "Eure-et-Loir");
INSERT INTO departements (departementid, code, nom) VALUES (130, '029', "Finistère");
INSERT INTO departements (departementid, code, nom) VALUES (131, '030', "Gard");
INSERT INTO departements (departementid, code, nom) VALUES (132, '031', "Haute-Garonne");
INSERT INTO departements (departementid, code, nom) VALUES (133, '032', "Gers");
INSERT INTO departements (departementid, code, nom) VALUES (134, '033', "Gironde");
INSERT INTO departements (departementid, code, nom) VALUES (135, '034', "Hérault");
INSERT INTO departements (departementid, code, nom) VALUES (136, '035', "Ille-et-Vilaine");
INSERT INTO departements (departementid, code, nom) VALUES (137, '036', "Indre");
INSERT INTO departements (departementid, code, nom) VALUES (138, '037', "Indre-et-Loire");
INSERT INTO departements (departementid, code, nom) VALUES (139, '038', "Isère");
INSERT INTO departements (departementid, code, nom) VALUES (140, '039', "Jura");
INSERT INTO departements (departementid, code, nom) VALUES (141, '040', "Landes");
INSERT INTO departements (departementid, code, nom) VALUES (142, '041', "Loir-et-Cher");
INSERT INTO departements (departementid, code, nom) VALUES (143, '042', "Loire");
INSERT INTO departements (departementid, code, nom) VALUES (144, '043', "Haute-Loire");
INSERT INTO departements (departementid, code, nom) VALUES (145, '044', "Loire-Atlantique");
INSERT INTO departements (departementid, code, nom) VALUES (146, '045', "Loiret");
INSERT INTO departements (departementid, code, nom) VALUES (147, '046', "Lot");
INSERT INTO departements (departementid, code, nom) VALUES (148, '047', "Lot-et-Garonne");
INSERT INTO departements (departementid, code, nom) VALUES (149, '048', "Lozère");
INSERT INTO departements (departementid, code, nom) VALUES (150, '049', "Maine-et-Loire");
INSERT INTO departements (departementid, code, nom) VALUES (151, '050', "Manche");
INSERT INTO departements (departementid, code, nom) VALUES (152, '051', "Marne");
INSERT INTO departements (departementid, code, nom) VALUES (153, '052', "Haute-Marne");
INSERT INTO departements (departementid, code, nom) VALUES (154, '053', "Mayenne");
INSERT INTO departements (departementid, code, nom) VALUES (155, '054', "Meurthe-et-Moselle");
INSERT INTO departements (departementid, code, nom) VALUES (156, '055', "Meuse");
INSERT INTO departements (departementid, code, nom) VALUES (157, '056', "Morbihan");
INSERT INTO departements (departementid, code, nom) VALUES (158, '057', "Moselle");
INSERT INTO departements (departementid, code, nom) VALUES (159, '058', "Nièvre");
INSERT INTO departements (departementid, code, nom) VALUES (160, '059', "Nord");
INSERT INTO departements (departementid, code, nom) VALUES (161, '060', "Oise");
INSERT INTO departements (departementid, code, nom) VALUES (162, '061', "Orne");
INSERT INTO departements (departementid, code, nom) VALUES (163, '062', "Pas-de-Calais");
INSERT INTO departements (departementid, code, nom) VALUES (164, '063', "Puy-de-Dôme");
INSERT INTO departements (departementid, code, nom) VALUES (165, '064', "Pyrénées-Atlantiques");
INSERT INTO departements (departementid, code, nom) VALUES (166, '065', "Hautes-Pyrénées");
INSERT INTO departements (departementid, code, nom) VALUES (167, '066', "Pyrénées-Orientales");
INSERT INTO departements (departementid, code, nom) VALUES (168, '067', "Bas-Rhin");
INSERT INTO departements (departementid, code, nom) VALUES (169, '068', "Haut-Rhin");
INSERT INTO departements (departementid, code, nom) VALUES (170, '069', "Rhône");
INSERT INTO departements (departementid, code, nom) VALUES (171, '070', "Haute-Saône");
INSERT INTO departements (departementid, code, nom) VALUES (172, '071', "Saône-et-Loire");
INSERT INTO departements (departementid, code, nom) VALUES (173, '072', "Sarthe");
INSERT INTO departements (departementid, code, nom) VALUES (174, '073', "Savoie");
INSERT INTO departements (departementid, code, nom) VALUES (175, '074', "Haute-Savoie");
INSERT INTO departements (departementid, code, nom) VALUES (176, '075', "Paris");
INSERT INTO departements (departementid, code, nom) VALUES (177, '076', "Seine-Maritime");
INSERT INTO departements (departementid, code, nom) VALUES (178, '077', "Seine-et-Marne");
INSERT INTO departements (departementid, code, nom) VALUES (179, '078', "Yvelines");
INSERT INTO departements (departementid, code, nom) VALUES (180, '079', "Deux-Sèvres");
INSERT INTO departements (departementid, code, nom) VALUES (181, '080', "Somme");
INSERT INTO departements (departementid, code, nom) VALUES (182, '081', "Tarn");
INSERT INTO departements (departementid, code, nom) VALUES (183, '082', "Tarn-et-Garonne");
INSERT INTO departements (departementid, code, nom) VALUES (184, '083', "Var");
INSERT INTO departements (departementid, code, nom) VALUES (185, '084', "Vaucluse");
INSERT INTO departements (departementid, code, nom) VALUES (186, '085', "Vendée");
INSERT INTO departements (departementid, code, nom) VALUES (187, '086', "Vienne");
INSERT INTO departements (departementid, code, nom) VALUES (188, '087', "Haute-Vienne");
INSERT INTO departements (departementid, code, nom) VALUES (189, '088', "Vosges");
INSERT INTO departements (departementid, code, nom) VALUES (190, '089', "Yonne");
INSERT INTO departements (departementid, code, nom) VALUES (191, '090', "Territoire de Belfort");
INSERT INTO departements (departementid, code, nom) VALUES (192, '091', "Essonne");
INSERT INTO departements (departementid, code, nom) VALUES (193, '092', "Hauts-de-Seine");
INSERT INTO departements (departementid, code, nom) VALUES (194, '093', "Seine-Saint-Denis");
INSERT INTO departements (departementid, code, nom) VALUES (195, '094', "Val-de-Marne");
INSERT INTO departements (departementid, code, nom) VALUES (196, '095', "Val-d'Oise");
INSERT INTO departements (departementid, code, nom) VALUES (197, '971', "Guadeloupe");
INSERT INTO departements (departementid, code, nom) VALUES (198, '972', "Martinique");
INSERT INTO departements (departementid, code, nom) VALUES (199, '973', "Guyane");
INSERT INTO departements (departementid, code, nom) VALUES (200, '974', "La Réunion");

/* arrondissements */
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (685, 101, 1, "Belley");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (686, 101, 2, "Bourg-en-Bresse");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (687, 101, 3, "Gex");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (688, 101, 4, "Nantua");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (689, 102, 1, "Château-Thierry");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (690, 102, 2, "Laon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (691, 102, 3, "Saint-Quentin");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (692, 102, 4, "Soissons");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (693, 102, 5, "Vervins");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (694, 103, 1, "Montluçon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (695, 103, 2, "Moulins");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (696, 103, 3, "Vichy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (697, 104, 1, "Barcelonnette");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (698, 104, 2, "Castellane");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (699, 104, 3, "Digne-les-Bains");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (700, 104, 4, "Forcalquier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (701, 105, 1, "Briançon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (702, 105, 2, "Gap");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (703, 106, 1, "Grasse");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (704, 106, 2, "Nice");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (705, 107, 1, "Largentière");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (706, 107, 2, "Privas");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (707, 107, 3, "Tournon-sur-Rhône");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (708, 108, 1, "Charleville-Mézières");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (709, 108, 2, "Rethel");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (710, 108, 3, "Sedan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (711, 108, 4, "Vouziers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (712, 109, 1, "Foix");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (713, 109, 2, "Pamiers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (714, 109, 3, "Saint-Girons");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (715, 110, 1, "Bar-sur-Aube");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (716, 110, 2, "Nogent-sur-Seine");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (717, 110, 3, "Troyes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (718, 111, 1, "Carcassonne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (719, 111, 2, "Limoux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (720, 111, 3, "Narbonne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (721, 112, 1, "Millau");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (722, 112, 2, "Rodez");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (723, 112, 3, "Villefranche-de-Rouergue");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (724, 113, 1, "Aix-en-Provence");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (725, 113, 2, "Arles");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (726, 113, 3, "Marseille");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (727, 113, 4, "Istres");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (728, 114, 1, "Bayeux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (729, 114, 2, "Caen");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (730, 114, 3, "Lisieux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (731, 114, 4, "Vire");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (732, 115, 1, "Aurillac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (733, 115, 2, "Mauriac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (734, 115, 3, "Saint-Flour");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (735, 116, 1, "Angoulême");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (736, 116, 2, "Cognac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (737, 116, 3, "Confolens");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (738, 117, 1, "Jonzac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (739, 117, 2, "Rochefort");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (740, 117, 3, "(La)\tRochelle");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (741, 117, 4, "Saintes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (742, 117, 5, "Saint-Jean-d'Angély");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (743, 118, 1, "Bourges");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (744, 118, 2, "Saint-Amand-Montrond");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (745, 118, 3, "Vierzon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (746, 119, 1, "Brive-la-Gaillarde");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (747, 119, 2, "Tulle");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (748, 119, 3, "Ussel");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (749, 120, 1, "Ajaccio");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (750, 120, 4, "Sartène");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (751, 121, 2, "Bastia");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (752, 121, 3, "Corte");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (753, 121, 5, "Calvi");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (754, 122, 1, "Beaune");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (755, 122, 2, "Dijon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (756, 122, 3, "Montbard");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (757, 123, 1, "Dinan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (758, 123, 2, "Guingamp");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (759, 123, 3, "Lannion");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (760, 123, 4, "Saint-Brieuc");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (761, 124, 1, "Aubusson");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (762, 124, 2, "Guéret");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (763, 125, 1, "Bergerac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (764, 125, 2, "Nontron");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (765, 125, 3, "Périgueux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (766, 125, 4, "Sarlat-la-Canéda");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (767, 126, 1, "Besançon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (768, 126, 2, "Montbéliard");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (769, 126, 3, "Pontarlier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (770, 127, 1, "Die");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (771, 127, 2, "Nyons");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (772, 127, 3, "Valence");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (773, 128, 1, "(Les)\tAndelys");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (774, 128, 2, "Bernay");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (775, 128, 3, "Évreux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (776, 129, 1, "Chartres");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (777, 129, 2, "Châteaudun");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (778, 129, 3, "Dreux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (779, 129, 4, "Nogent-le-Rotrou");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (780, 130, 1, "Brest");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (781, 130, 2, "Châteaulin");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (782, 130, 3, "Morlaix");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (783, 130, 4, "Quimper");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (784, 131, 1, "Alès");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (785, 131, 2, "Nîmes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (786, 131, 3, "(Le)\tVigan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (787, 132, 1, "Muret");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (788, 132, 2, "Saint-Gaudens");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (789, 132, 3, "Toulouse");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (790, 133, 1, "Auch");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (791, 133, 2, "Condom");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (792, 133, 3, "Mirande");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (793, 134, 1, "Blaye");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (794, 134, 2, "Bordeaux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (795, 134, 3, "Langon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (796, 134, 4, "Lesparre-Médoc");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (797, 134, 5, "Libourne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (798, 135, 1, "Béziers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (799, 135, 2, "Lodève");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (800, 135, 3, "Montpellier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (801, 136, 1, "Fougères");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (802, 136, 2, "Redon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (803, 136, 3, "Rennes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (804, 136, 4, "Saint-Malo");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (805, 137, 1, "(Le)\tBlanc");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (806, 137, 2, "Châteauroux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (807, 137, 3, "(La)\tChâtre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (808, 137, 4, "Issoudun");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (809, 138, 1, "Chinon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (810, 138, 2, "Tours");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (811, 138, 3, "Loches");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (812, 139, 1, "Grenoble");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (813, 139, 2, "(La)\tTour-du-Pin");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (814, 139, 3, "Vienne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (815, 140, 1, "Dole");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (816, 140, 2, "Lons-le-Saunier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (817, 140, 3, "Saint-Claude");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (818, 141, 1, "Dax");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (819, 141, 2, "Mont-de-Marsan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (820, 142, 1, "Blois");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (821, 142, 2, "Vendôme");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (822, 142, 3, "Romorantin-Lanthenay");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (823, 143, 1, "Montbrison");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (824, 143, 2, "Roanne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (825, 143, 3, "Saint-Étienne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (826, 144, 1, "Brioude");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (827, 144, 2, "(Le)\tPuy-en-Velay");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (828, 144, 3, "Yssingeaux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (829, 145, 1, "Châteaubriant");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (830, 145, 2, "Nantes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (831, 145, 3, "Saint-Nazaire");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (832, 145, 4, "Ancenis");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (833, 146, 1, "Montargis");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (834, 146, 2, "Orléans");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (835, 146, 3, "Pithiviers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (836, 147, 1, "Cahors");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (837, 147, 2, "Figeac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (838, 147, 3, "Gourdon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (839, 148, 1, "Agen");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (840, 148, 2, "Marmande");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (841, 148, 3, "Villeneuve-sur-Lot");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (842, 148, 4, "Nérac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (843, 149, 1, "Florac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (844, 149, 2, "Mende");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (845, 150, 1, "Angers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (846, 150, 2, "Cholet");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (847, 150, 3, "Saumur");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (848, 150, 4, "Segré");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (849, 151, 1, "Avranches");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (850, 151, 2, "Cherbourg-Octeville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (851, 151, 3, "Coutances");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (852, 151, 4, "Saint-Lô");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (853, 152, 1, "Châlons-en-Champagne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (854, 152, 2, "Épernay");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (855, 152, 3, "Reims");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (856, 152, 4, "Vitry-le-François");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (857, 152, 5, "Sainte-Menehould");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (858, 153, 1, "Chaumont");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (859, 153, 2, "Langres");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (860, 153, 3, "Saint-Dizier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (861, 154, 1, "Château-Gontier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (862, 154, 2, "Laval");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (863, 154, 3, "Mayenne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (864, 155, 1, "Briey");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (865, 155, 2, "Lunéville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (866, 155, 3, "Nancy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (867, 155, 4, "Toul");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (868, 156, 1, "Bar-le-Duc");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (869, 156, 2, "Commercy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (870, 156, 3, "Verdun");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (871, 157, 1, "Lorient");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (872, 157, 2, "Pontivy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (873, 157, 3, "Vannes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (874, 158, 1, "Boulay-Moselle");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (875, 158, 2, "Château-Salins");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (876, 158, 3, "Forbach");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (877, 158, 4, "Metz-Campagne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (878, 158, 5, "Sarrebourg");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (879, 158, 6, "Sarreguemines");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (880, 158, 7, "Thionville-Est");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (881, 158, 8, "Thionville-Ouest");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (882, 158, 9, "Metz-Ville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (883, 159, 1, "Château-Chinon(Ville)");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (884, 159, 2, "Clamecy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (885, 159, 3, "Nevers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (886, 159, 4, "Cosne-Cours-sur-Loire");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (887, 160, 1, "Avesnes-sur-Helpe");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (888, 160, 2, "Cambrai");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (889, 160, 3, "Douai");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (890, 160, 4, "Dunkerque");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (891, 160, 5, "Lille");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (892, 160, 6, "Valenciennes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (893, 161, 1, "Beauvais");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (894, 161, 2, "Clermont");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (895, 161, 3, "Compiègne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (896, 161, 4, "Senlis");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (897, 162, 1, "Alençon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (898, 162, 2, "Argentan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (899, 162, 3, "Mortagne-au-Perche");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (900, 163, 1, "Arras");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (901, 163, 2, "Béthune");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (902, 163, 3, "Boulogne-sur-Mer");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (903, 163, 4, "Montreuil");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (904, 163, 5, "Saint-Omer");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (905, 163, 6, "Calais");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (906, 163, 7, "Lens");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (907, 164, 1, "Ambert");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (908, 164, 2, "Clermont-Ferrand");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (909, 164, 3, "Issoire");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (910, 164, 4, "Riom");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (911, 164, 5, "Thiers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (912, 165, 1, "Bayonne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (913, 165, 2, "Oloron-Sainte-Marie");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (914, 165, 3, "Pau");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (915, 166, 1, "Argelès-Gazost");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (916, 166, 2, "Bagnères-de-Bigorre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (917, 166, 3, "Tarbes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (918, 167, 1, "Céret");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (919, 167, 2, "Perpignan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (920, 167, 3, "Prades");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (921, 168, 2, "Haguenau");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (922, 168, 3, "Molsheim");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (923, 168, 4, "Saverne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (924, 168, 5, "Sélestat-Erstein");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (925, 168, 6, "Strasbourg-Campagne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (926, 168, 7, "Wissembourg");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (927, 168, 8, "Strasbourg-Ville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (928, 169, 1, "Altkirch");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (929, 169, 2, "Colmar");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (930, 169, 3, "Guebwiller");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (931, 169, 4, "Mulhouse");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (932, 169, 5, "Ribeauvillé");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (933, 169, 6, "Thann");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (934, 170, 1, "Lyon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (935, 170, 2, "Villefranche-sur-Saône");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (936, 171, 1, "Lure");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (937, 171, 2, "Vesoul");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (938, 172, 1, "Autun");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (939, 172, 2, "Chalon-sur-Saône");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (940, 172, 3, "Charolles");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (941, 172, 4, "Louhans");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (942, 172, 5, "Mâcon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (943, 173, 1, "(La)\tFlèche");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (944, 173, 2, "Mamers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (945, 173, 3, "(Le)\tMans");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (946, 174, 1, "Albertville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (947, 174, 2, "Chambéry");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (948, 174, 3, "Saint-Jean-de-Maurienne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (949, 175, 1, "Annecy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (950, 175, 2, "Bonneville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (951, 175, 3, "Saint-Julien-en-Genevois");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (952, 175, 4, "Thonon-les-Bains");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (953, 176, 1, "Paris");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (954, 177, 1, "Dieppe");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (955, 177, 2, "(Le)\tHavre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (956, 177, 3, "Rouen");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (957, 178, 1, "Meaux");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (958, 178, 2, "Melun");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (959, 178, 3, "Provins");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (960, 178, 4, "Fontainebleau");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (961, 178, 5, "Torcy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (962, 179, 1, "Mantes-la-Jolie");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (963, 179, 2, "Rambouillet");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (964, 179, 3, "Saint-Germain-en-Laye");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (965, 179, 4, "Versailles");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (966, 180, 1, "Bressuire");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (967, 180, 2, "Niort");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (968, 180, 3, "Parthenay");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (969, 181, 1, "Abbeville");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (970, 181, 2, "Amiens");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (971, 181, 3, "Montdidier");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (972, 181, 4, "Péronne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (973, 182, 1, "Albi");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (974, 182, 2, "Castres");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (975, 183, 1, "Castelsarrasin");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (976, 183, 2, "Montauban");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (977, 184, 1, "Draguignan");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (978, 184, 2, "Toulon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (979, 184, 3, "Brignoles");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (980, 185, 1, "Apt");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (981, 185, 2, "Avignon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (982, 185, 3, "Carpentras");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (983, 186, 1, "Fontenay-le-Comte");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (984, 186, 2, "(La)\tRoche-sur-Yon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (985, 186, 3, "(Les)\tSables-d'Olonne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (986, 187, 1, "Châtellerault");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (987, 187, 2, "Montmorillon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (988, 187, 3, "Poitiers");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (989, 188, 1, "Bellac");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (990, 188, 2, "Limoges");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (991, 188, 3, "Rochechouart");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (992, 189, 1, "Épinal");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (993, 189, 2, "Neufchâteau");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (994, 189, 3, "Saint-Dié-des-Vosges");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (995, 190, 1, "Auxerre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (996, 190, 2, "Avallon");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (997, 190, 3, "Sens");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (998, 191, 1, "Belfort");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (999, 192, 1, "Étampes");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1000, 192, 2, "Évry");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1001, 192, 3, "Palaiseau");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1002, 193, 1, "Antony");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1003, 193, 2, "Nanterre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1004, 193, 3, "Boulogne-Billancourt");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1005, 194, 1, "Bobigny");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1006, 194, 2, "(Le)\tRaincy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1007, 194, 3, "Saint-Denis");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1008, 195, 1, "Créteil");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1009, 195, 2, "Nogent-sur-Marne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1010, 195, 3, "Haó-les-Roses");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1011, 196, 1, "Argenteuil");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1012, 196, 2, "Sarcelles");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1013, 196, 3, "Pontoise");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1014, 197, 1, "Basse-Terre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1015, 197, 2, "Pointe-à-Pitre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1016, 197, 3, "Saint-Martin-Saint-Barthélemy");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1017, 198, 1, "Fort-de-France");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1018, 198, 2, "(La)\tTrinité");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1019, 198, 3, "(Le)\tMarin");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1020, 198, 4, "Saint-Pierre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1021, 199, 1, "Cayenne");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1022, 199, 2, "Saint-Laurent-du-Maroni");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1023, 200, 1, "Saint-Denis");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1024, 200, 2, "Saint-Pierre");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1025, 200, 3, "Saint-Benoît");
INSERT INTO arrondissements (departementid, departementid, code, nom) VALUES (1026, 200, 4, "Saint-Paul");

/* naturecollectivites */
INSERT INTO naturecollectivites (id, parentid, description) VALUES (1, null, 'Région');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (11, 1, 'Conseil régional');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (12, 1, 'Établissements publics locaux d\'enseignement');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (13, 1, 'Autres établissements publics');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (14, 1, 'Sociétés d\'économie mixte locales');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (2, null, 'Département');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (21, 2, 'Conseil général');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (22, 2, 'Établissements publics de santé');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (23, 2, 'Établissements publics locaux d\'enseignement');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (24, 2, 'Autres établissements publics');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (25, 2, 'Sociétés d\'économie mixte locales');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (3, null, 'Commune');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (31, 3, 'Commune');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (32, 3, 'Établissements publics de santé');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (33, 3, 'Autres établissements publics');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (34, 3, 'Sociétés d\'économie mixte locales');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (4, null, 'Établissements publics de coopération intercommunale et syndicats');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (41, 4, 'Syndicats de communes et syndicats mixtes « fermés » associant exclusivement des communes, et des EPCI');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (42, 4, 'Syndicats mixtes « ouverts » associant des collectivités territoriales, des groupements de collectivités territoriales et d\'autres personnes morales de droit public');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (43, 4, 'Syndicats d\'agglomération nouvelle');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (44, 4, 'Communautés de communes');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (45, 4, 'Communautés urbaines');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (46, 4, 'Communautés d\'agglomération');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (47, 4, 'Sociétés d\'économie mixte locales');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (5, null, 'Autres');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (51, 5, 'Service départemental d\'incendie et de secours');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (52, 5, 'Entente interdépartementale');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (53, 5, 'Entente interrégionale');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (54, 5, 'Autres sociétés d\'économie mixte locales');
INSERT INTO naturecollectivites (id, parentid, description) VALUES (55, 5, 'Autres');

/* transactions */
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (10, 1, null, '1',   'Transmission d\'un acte');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (11, 1, 110,  '1-1', 'Transmission acte');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (12, 1, 110,  '1-2', 'Accusé de réception');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (13, 1, 110,  '1-3', 'Anomalie dans le formulaire signalétique de l\'acte');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (60, 6, null, 'Annulation de la transmission d\'un acte (suite à une erreur matérielle)');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (61, 6, 60,   '6-1', 'Annulation de transmission');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (62, 6, 60,   '6-2', 'Accusé de réception');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (70, 7, null, 'Demande de la structuration des matières et sous-matières');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (71, 7, 70,   '7-1', 'Demande classif. en matières');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (72, 7, 70,   '7-2', 'Classif. en matières');
INSERT INTO transactions (id, type, parentid, short, description, emetteur, destinataire) VALUES (73, 7, 70,   '7-3', 'Classif. en matières à jour');

/* Messages */
INSERT INTO Messages (code, description, type) VALUES ('001', 'Acte déjà transmis, ou numérotation incorrecte',         'Acte');
INSERT INTO Messages (code, description, type) VALUES ('002', 'Version de la classification en sous-matières obsolète', 'Acte');
INSERT INTO Messages (code, description, type) VALUES ('003', 'Classification dans les sous-matières incomplète',       'Acte');
INSERT INTO Messages (code, description, type) VALUES ('004', 'Champ(s) du formulaire signalétique non remplis',        'Acte');
INSERT INTO Messages (code, description, type) VALUES ('005', 'Anomalie sur un ou plusieurs champs du formulaire',      'Acte');
INSERT INTO Messages (code, description, type) VALUES ('006', 'Pièces jointes manquantes',                              'Acte');
INSERT INTO Messages (code, description, type) VALUES ('007', 'Anomalie sur les pièces jointes',                        'Acte');
INSERT INTO Messages (code, description, type) VALUES ('999', 'Autre',                                                  'Acte');
INSERT INTO Messages (code, description, type) VALUES ('001', 'Pièces jointes manquantes',                              'EnveloppeMISILLCL');
INSERT INTO Messages (code, description, type) VALUES ('002', 'Anomalie sur les pièces jointes',                        'EnveloppeMISILLCL');
INSERT INTO Messages (code, description, type) VALUES ('003', 'Fichier mal formé',                                      'EnveloppeMISILLCL');
INSERT INTO Messages (code, description, type) VALUES ('004', 'Un ou plusieurs champs du formulaire sont manquants',    'EnveloppeMISILLCL');
INSERT INTO Messages (code, description, type) VALUES ('005', 'Anomalie sur un ou plusieurs champs du formulaire',      'EnveloppeMISILLCL');
INSERT INTO Messages (code, description, type) VALUES ('100', 'Autre',                                                  'EnveloppeMISILLCL');
