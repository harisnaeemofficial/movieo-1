CREATE SEQUENCE people_personid_seq;
CREATE TABLE "people" (
"personid" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('people_personid_seq'),
"dob" DATE NOT NULL,
"age" INT,
"fname" TEXT NOT NULL,
"mname" TEXT,
"lname" TEXT
);

CREATE SEQUENCE shows_showid_seq;
CREATE TABLE "shows" (
"showid" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('shows_showid_seq'),
"title" TEXT NOT NULL,
"rating" BIGINT,
"language" TEXT,
"genre" TEXT
);

CREATE TABLE "awards" (
"awardid" BIGINT NOT NULL PRIMARY KEY,
"name" TEXT
);

CREATE TABLE "countries" (
"countryid" BIGINT NOT NULL PRIMARY KEY,
"name" TEXT NOT NULL
);

CREATE TABLE "countrygroups" (
"cgid" BIGINT NOT NULL PRIMARY KEY
);

CREATE TABLE "currencies" (
"curid" BIGINT NOT NULL PRIMARY KEY,
"name" TEXT
);

CREATE TABLE "distributors" (
"distid" BIGINT NOT NULL PRIMARY KEY,
"name" TEXT NOT NULL
);

CREATE TABLE "distribute" (
"distid" BIGINT CONSTRAINT distribute_distributors_distid
REFERENCES distributors("distid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT distribute_shows_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "org" (
"orgid" BIGINT NOT NULL PRIMARY KEY,
"name" TEXT
);

CREATE TABLE "salariespoints" (
"salid" BIGINT NOT NULL PRIMARY KEY,
"personid" BIGINT CONSTRAINT salariespoints_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT salariespoints_showid
REFERENCES shows("showid") ON DELETE SET NULL,
"type" TEXT
);

CREATE TABLE "revenuehist" (
"showid" BIGINT CONSTRAINT revenuehist_shows_showid
REFERENCES shows("showid") ON DELETE CASCADE,
"cgid" BIGINT CONSTRAINT revenuehist_CGROPUS_cgid
REFERENCES countrygroups("cgid") ON DELETE CASCADE,
"revid" BIGINT NOT NULL PRIMARY KEY,
"amount" NUMERIC(12,2),
"rhdate" DATE
);

CREATE TABLE "actors" (
"personid" BIGINT CONSTRAINT actorid
REFERENCES people("personid") ON DELETE CASCADE
);

CREATE TABLE "acthist" (
"personid" BIGINT CONSTRAINT acthist_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT acthist_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "actin" (
"personid" BIGINT CONSTRAINT actin_personid REFERENCES people("personid") ON
DELETE SET NULL,
"showid" BIGINT CONSTRAINT actin_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "awardinst" (
"aiid" BIGINT NOT NULL PRIMARY KEY,
"awardid" BIGINT CONSTRAINT awardinst_awards_awardid
REFERENCES awards("awardid") ON DELETE SET NULL,
"awarddate" DATE
);

CREATE TABLE "collections" (
"colid" BIGINT NOT NULL PRIMARY KEY
);

CREATE TABLE "compose" (
"personid" BIGINT CONSTRAINT compose_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT compose_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "composers" (
"personid" BIGINT CONSTRAINT composerid
REFERENCES people("personid") ON DELETE CASCADE
);

CREATE TABLE "countriesmakeup" (
"countryid" BIGINT CONSTRAINT countriesmakeup_countries_countryid
REFERENCES countries("countryid") ON DELETE CASCADE,
"cgid" BIGINT CONSTRAINT countriesmakeup_countrygroups_cgid
REFERENCES countrygroups("cgid") ON DELETE CASCADE
);

CREATE TABLE "direct" (
"personid" BIGINT CONSTRAINT direct_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT direct_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "directors" (
"personid" BIGINT CONSTRAINT directOrid
REFERENCES people("personid") ON DELETE CASCADE
);

CREATE TABLE "edit" (
"personid" BIGINT CONSTRAINT edit_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT edit_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "editors" (
"personid" BIGINT CONSTRAINT editOrid
REFERENCES people("personid") ON DELETE CASCADE
);

CREATE TABLE "episodes" (
"episodeid" BIGINT NOT NULL PRIMARY KEY,
"showid" BIGINT NOT NULL CONSTRAINT episodes_showid
REFERENCES shows("showid") ON DELETE CASCADE,
"title" TEXT,
"reldate" DATE
);

CREATE TABLE "films" (
"showid" BIGINT NOT NULL CONSTRAINT Filmsshowid
REFERENCES shows("showid") ON DELETE SET NULL,
"year" INT, "reldate" DATE
);

CREATE TABLE "fluc" (
"curid" BIGINT CONSTRAINT fluc_currencies_curid
REFERENCES currencies("curid") ON DELETE CASCADE,
"flucid" BIGINT NOT NULL PRIMARY KEY,
"change" DATE,
"flucdate" DATE
);

CREATE TABLE "handout" (
"orgid" BIGINT CONSTRAINT handout_org_orgid
REFERENCES org("orgid"),
"awardid" BIGINT CONSTRAINT handout_awards_awardid
REFERENCES awards("awardid") ON DELETE SET NULL
);

CREATE TABLE "havefilms" (
"colid" BIGINT NOT NULL CONSTRAINT havefilms_COLECS
REFERENCES collections("colid") ON DELETE CASCADE,
"showid" BIGINT NOT NULL CONSTRAINT havefilms_showid
REFERENCES shows("showid") ON DELETE CASCADE
);

CREATE TABLE "points" (
"salid" BIGINT CONSTRAINT points_salariespoints
REFERENCES salariespoints("salid") ON DELETE SET NULL,
"personid" BIGINT CONSTRAINT points_people_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT points_showid
REFERENCES shows("showid") ON DELETE SET NULL,
"points" INT,
"value" NUMERIC(5,2)
);

CREATE TABLE "produce" (
"personid" BIGINT CONSTRAINT produce_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT produce_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "producers"(
"personid" BIGINT CONSTRAINT producerid
REFERENCES people("personid") ON DELETE CASCADE
);

CREATE TABLE "ratings" (
"rateid" BIGINT NOT NULL PRIMARY KEY,
"ratings" TEXT
);

CREATE SEQUENCE ratinghist_rhid_seq;
CREATE TABLE "ratinghist" (
"rhid" NUMERIC(10,0) NOT NULL PRIMARY KEY DEFAULT nextval('ratinghist_rhid_seq'),
"showid" BIGINT,
"rateid" BIGINT
);

CREATE TABLE "receive" (
"showid" BIGINT CONSTRAINT receive_shows_showid
REFERENCES shows("showid") ON DELETE CASCADE,
"rateid" BIGINT CONSTRAINT receive_ratings_rateid
REFERENCES ratings("rateid") ON DELETE CASCADE
);

CREATE TABLE "recoredin" (
"showid" BIGINT CONSTRAINT recoredin_shows_showid
REFERENCES shows("showid") ON DELETE CASCADE,
"cgid" BIGINT CONSTRAINT recoredin_countrygroups_cgid
REFERENCES countrygroups("cgid"),
"revid" BIGINT CONSTRAINT recoredin_ratinghist_revid
REFERENCES revenuehist("revid"),
"curid" BIGINT CONSTRAINT recoredin_currencies_curid
REFERENCES currencies("curid")
);

CREATE TABLE "role" (
"personid" BIGINT CONSTRAINT role_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT,
"role" TEXT
);

CREATE TABLE "salaries" (
"salid" BIGINT CONSTRAINT salaries_salariespoints
REFERENCES salariespoints("salid") ON DELETE SET NULL,
"personid" BIGINT CONSTRAINT salaries_personid
REFERENCES people("personid"),
"showid" BIGINT CONSTRAINT salaries_showid REFERENCES shows("showid"),
"amount" NUMERIC(8,2) DEFAULT '0.00'
);

CREATE TABLE "screennames" (
"personid" BIGINT NOT NULL CONSTRAINT personid
REFERENCES people("personid") ON DELETE CASCADE,
"sfname" TEXT NOT NULL,
"smname" TEXT,
"slname" TEXT NOT NULL
);

CREATE TABLE "tvshows" (
"showid" BIGINT NOT NULL PRIMARY KEY CONSTRAINT tvshows_showid
REFERENCES shows("showid") ON DELETE SET NULL,
"startdate" DATE,
"enddate" DATE
);

CREATE TABLE "wonbypeople" (
"aiid" BIGINT CONSTRAINT wonbypeople_awardsINST_aiid
REFERENCES awardinst("aiid") ON DELETE SET NULL,
"personid" BIGINT CONSTRAINT wonbypeople_people_personid
REFERENCES people("personid") ON DELETE SET NULL
);

CREATE TABLE "wonbyshows" (
"aiid" BIGINT CONSTRAINT wonbyshows_awardsINST_aiid
REFERENCES awardinst("aiid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT wonbyshows_shows_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "write" (
"personid" BIGINT CONSTRAINT write_personid
REFERENCES people("personid") ON DELETE SET NULL,
"showid" BIGINT CONSTRAINT write_showid
REFERENCES shows("showid") ON DELETE SET NULL
);

CREATE TABLE "writers" (
"personid" BIGINT CONSTRAINT writerid REFERENCES people("personid") ON DELETE
CASCADE
);
