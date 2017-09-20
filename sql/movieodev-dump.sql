--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.0
-- Dumped by pg_dump version 9.6.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: movie; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE movie AS (
	showid bigint,
	title text,
	year integer,
	overview text,
	actors text[],
	directors text[],
	genres text[]
);


ALTER TYPE movie OWNER TO postgres;

--
-- Name: add_movie(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_movie(movie_title text, movie_overview text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
current_showid BIGINT;
BEGIN
INSERT INTO shows (title, overview) VALUES (movie_title, movie_overview) RETURNING showid INTO current_showid;
INSERT INTO films (showid) VALUES (current_showid);
END;
$$;


ALTER FUNCTION public.add_movie(movie_title text, movie_overview text) OWNER TO postgres;

--
-- Name: add_tvshow(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_tvshow(tvshow_title text, tvshow_overview text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
current_showid BIGINT;
BEGIN
INSERT INTO shows (title, overview) VALUES (tvshow_title, tvshow_overview) RETURNING showid INTO current_showid;
INSERT INTO films (showid) VALUES (current_showid);
END;
$$;


ALTER FUNCTION public.add_tvshow(tvshow_title text, tvshow_overview text) OWNER TO postgres;

--
-- Name: movie_details(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION movie_details() RETURNS SETOF movie
    LANGUAGE plpgsql
    AS $$
              
DECLARE
show SHOWS;
film FILMS;
movie_actors TEXT[];
movie_directors TEXT[];
movie_genres TEXT[];
movieid BIGINT;
BEGIN
FOR movieid IN SELECT s.showid FROM shows s
JOIN films f USING (showid)
LOOP
SELECT * INTO show FROM shows s 
WHERE s.showid = movieid;

SELECT f.* INTO film FROM films f
JOIN shows s USING (showid)
WHERE s.showid = movieid; 

SELECT array_agg(concat_ws(' ', fname, mname, lname)) INTO movie_actors FROM people p
JOIN actin a USING (personid)
JOIN shows s USING (showid)
WHERE s.showid = movieid;

SELECT array_agg(concat_ws(' ', fname, mname, lname)) INTO movie_directors FROM people p
JOIN direct d USING (personid)
JOIN shows s USING (showid)
WHERE s.showid = movieid;

SELECT array_agg(g.name) INTO movie_genres from genres g
JOIN showgenres USING (genreid)
JOIN shows s USING (showid)
WHERE s.showid = movieid;
RETURN QUERY SELECT show.showid, show.title, film.year, show.overview, movie_actors, movie_directors, movie_genres;
END LOOP;
RETURN;
END;
$$;


ALTER FUNCTION public.movie_details() OWNER TO postgres;

--
-- Name: movie_details(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION movie_details(movieid bigint) RETURNS SETOF movie
    LANGUAGE plpgsql
    AS $$
              
DECLARE
show SHOWS;
film FILMS;
movie_actors TEXT[];
movie_directors TEXT[];
movie_genres TEXT[];

BEGIN

SELECT * INTO show FROM shows s 
WHERE s.showid = movieid;

SELECT f.* INTO film FROM films F
JOIN shows s USING (showid)
WHERE s.showid = movieid; 

SELECT array_agg(concat_ws(' ', fname, mname, lname)) INTO movie_actors FROM people p
JOIN actin a USING (personid)
JOIN shows s USING (showid)
WHERE s.showid = movieid;

SELECT array_agg(concat_ws(' ', fname, mname, lname)) INTO movie_directors FROM people p
JOIN direct d USING (personid)
JOIN shows s USING (showid)
WHERE s.showid = movieid;

SELECT array_agg(g.name) INTO movie_genres from genres g
JOIN showgenres USING (genreid)
JOIN shows s USING (showid)
WHERE s.showid = movieid;

RETURN QUERY
SELECT show.showid, show.title, film.year, show.overview, movie_actors, movie_directors, movie_genres;
END;
$$;


ALTER FUNCTION public.movie_details(movieid bigint) OWNER TO postgres;

--
-- Name: movie_details(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION movie_details(movie_title text) RETURNS SETOF movie
    LANGUAGE plpgsql
    AS $$
              
DECLARE
show SHOWS;
film FILMS;
movie_actors TEXT[];
movie_directors TEXT[];
movie_genres TEXT[];

BEGIN

SELECT * INTO show FROM shows s 
WHERE s.title = movie_title;

SELECT f.* INTO film FROM films F
JOIN shows s USING (showid)
WHERE s.title = movie_title; 

SELECT array_agg(concat_ws(' ', fname, mname, lname)) INTO movie_actors FROM people p
JOIN actin a USING (personid)
JOIN shows s USING (showid)
WHERE s.title = movie_title;

SELECT array_agg(concat_ws(' ', fname, mname, lname)) INTO movie_directors FROM people p
JOIN direct d USING (personid)
JOIN shows s USING (showid)
WHERE s.title = movie_title;

SELECT array_agg(g.name) INTO movie_genres from genres g
JOIN showgenres USING (genreid)
JOIN shows s USING (showid)
WHERE s.title = movie_title;

RETURN QUERY
SELECT show.showid, show.title, film.year, show.overview, movie_actors, movie_directors, movie_genres;
END;
$$;


ALTER FUNCTION public.movie_details(movie_title text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acthist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE acthist (
    personid bigint,
    showid bigint
);


ALTER TABLE acthist OWNER TO postgres;

--
-- Name: actin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE actin (
    personid bigint NOT NULL,
    showid bigint NOT NULL
);


ALTER TABLE actin OWNER TO postgres;

--
-- Name: actors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE actors (
    personid bigint
);


ALTER TABLE actors OWNER TO postgres;

--
-- Name: awardinst; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE awardinst (
    aiid bigint NOT NULL,
    awardid bigint,
    awarddate date
);


ALTER TABLE awardinst OWNER TO postgres;

--
-- Name: awards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE awards (
    awardid bigint NOT NULL,
    name text
);


ALTER TABLE awards OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE collections (
    colid bigint NOT NULL
);


ALTER TABLE collections OWNER TO postgres;

--
-- Name: compose; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compose (
    personid bigint,
    showid bigint
);


ALTER TABLE compose OWNER TO postgres;

--
-- Name: composers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE composers (
    personid bigint
);


ALTER TABLE composers OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE countries (
    countryid bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE countries OWNER TO postgres;

--
-- Name: countriesmakeup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE countriesmakeup (
    countryid bigint,
    cgid bigint
);


ALTER TABLE countriesmakeup OWNER TO postgres;

--
-- Name: countrygroups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE countrygroups (
    cgid bigint NOT NULL
);


ALTER TABLE countrygroups OWNER TO postgres;

--
-- Name: currencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE currencies (
    curid bigint NOT NULL,
    name text
);


ALTER TABLE currencies OWNER TO postgres;

--
-- Name: direct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE direct (
    personid bigint,
    showid bigint
);


ALTER TABLE direct OWNER TO postgres;

--
-- Name: directors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE directors (
    personid bigint
);


ALTER TABLE directors OWNER TO postgres;

--
-- Name: distribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE distribute (
    distid bigint,
    showid bigint
);


ALTER TABLE distribute OWNER TO postgres;

--
-- Name: distributors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE distributors (
    distid bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE distributors OWNER TO postgres;

--
-- Name: edit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE edit (
    personid bigint,
    showid bigint
);


ALTER TABLE edit OWNER TO postgres;

--
-- Name: editors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE editors (
    personid bigint
);


ALTER TABLE editors OWNER TO postgres;

--
-- Name: episodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE episodes (
    episodeid bigint NOT NULL,
    showid bigint NOT NULL,
    title text,
    reldate date
);


ALTER TABLE episodes OWNER TO postgres;

--
-- Name: films; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE films (
    showid bigint NOT NULL,
    year integer,
    reldate date
);


ALTER TABLE films OWNER TO postgres;

--
-- Name: fluc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE fluc (
    curid bigint,
    flucid bigint NOT NULL,
    change date,
    flucdate date
);


ALTER TABLE fluc OWNER TO postgres;

--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE genres (
    genreid smallint NOT NULL,
    name text
);


ALTER TABLE genres OWNER TO postgres;

--
-- Name: handout; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE handout (
    orgid bigint,
    awardid bigint
);


ALTER TABLE handout OWNER TO postgres;

--
-- Name: havefilms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE havefilms (
    colid bigint NOT NULL,
    showid bigint NOT NULL
);


ALTER TABLE havefilms OWNER TO postgres;

--
-- Name: org; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE org (
    orgid bigint NOT NULL,
    name text
);


ALTER TABLE org OWNER TO postgres;

--
-- Name: people_personid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE people_personid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE people_personid_seq OWNER TO postgres;

--
-- Name: people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE people (
    personid bigint DEFAULT nextval('people_personid_seq'::regclass) NOT NULL,
    dob date,
    age integer,
    fname text NOT NULL,
    mname text,
    lname text
);


ALTER TABLE people OWNER TO postgres;

--
-- Name: points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE points (
    salid bigint,
    personid bigint,
    showid bigint,
    points integer,
    value numeric(5,2)
);


ALTER TABLE points OWNER TO postgres;

--
-- Name: produce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE produce (
    personid bigint,
    showid bigint
);


ALTER TABLE produce OWNER TO postgres;

--
-- Name: producers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE producers (
    personid bigint
);


ALTER TABLE producers OWNER TO postgres;

--
-- Name: ratinghist_rhid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ratinghist_rhid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ratinghist_rhid_seq OWNER TO postgres;

--
-- Name: ratinghist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ratinghist (
    rhid numeric(10,0) DEFAULT nextval('ratinghist_rhid_seq'::regclass) NOT NULL,
    showid bigint,
    rateid bigint
);


ALTER TABLE ratinghist OWNER TO postgres;

--
-- Name: ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ratings (
    rateid bigint NOT NULL,
    ratings text
);


ALTER TABLE ratings OWNER TO postgres;

--
-- Name: receive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE receive (
    showid bigint,
    rateid bigint
);


ALTER TABLE receive OWNER TO postgres;

--
-- Name: recordedin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE recordedin (
    showid bigint,
    cgid bigint,
    revid bigint,
    curid bigint
);


ALTER TABLE recordedin OWNER TO postgres;

--
-- Name: revenuehist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE revenuehist (
    showid bigint,
    cgid bigint,
    revid bigint NOT NULL,
    amount numeric(12,2),
    rhdate date
);


ALTER TABLE revenuehist OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE role (
    personid bigint,
    showid bigint,
    role text
);


ALTER TABLE role OWNER TO postgres;

--
-- Name: salaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE salaries (
    salid bigint,
    personid bigint,
    showid bigint,
    amount numeric(8,2) DEFAULT 0.00
);


ALTER TABLE salaries OWNER TO postgres;

--
-- Name: salariespoints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE salariespoints (
    salid bigint NOT NULL,
    personid bigint,
    showid bigint,
    type text
);


ALTER TABLE salariespoints OWNER TO postgres;

--
-- Name: screennames; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE screennames (
    personid bigint NOT NULL,
    sfname text NOT NULL,
    smname text,
    slname text NOT NULL
);


ALTER TABLE screennames OWNER TO postgres;

--
-- Name: showgenres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE showgenres (
    genreid smallint NOT NULL,
    showid bigint NOT NULL
);


ALTER TABLE showgenres OWNER TO postgres;

--
-- Name: shows_showid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shows_showid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shows_showid_seq OWNER TO postgres;

--
-- Name: shows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE shows (
    showid bigint DEFAULT nextval('shows_showid_seq'::regclass) NOT NULL,
    title text NOT NULL,
    rating bigint,
    language text,
    overview text DEFAULT 'Nothing here yet'::text NOT NULL
);


ALTER TABLE shows OWNER TO postgres;

--
-- Name: tvshows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tvshows (
    showid bigint NOT NULL,
    startdate date,
    enddate date
);


ALTER TABLE tvshows OWNER TO postgres;

--
-- Name: wonbypeople; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE wonbypeople (
    aiid bigint,
    personid bigint
);


ALTER TABLE wonbypeople OWNER TO postgres;

--
-- Name: wonbyshows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE wonbyshows (
    aiid bigint,
    showid bigint
);


ALTER TABLE wonbyshows OWNER TO postgres;

--
-- Name: write; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE write (
    personid bigint,
    showid bigint
);


ALTER TABLE write OWNER TO postgres;

--
-- Name: writers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE writers (
    personid bigint
);


ALTER TABLE writers OWNER TO postgres;

--
-- Data for Name: acthist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY acthist (personid, showid) FROM stdin;
95	4
95	15
55	5
79	5
54	9
54	11
60	13
55	14
46	16
54	16
63	18
69	19
54	20
67	20
21	24
67	25
72	26
77	28
80	30
54	31
2	36
80	32
2	39
2	41
2	42
82	33
2	44
2	46
83	34
85	37
54	39
54	5
54	45
79	7
56	8
59	49
57	9
58	11
59	12
96	10
61	13
62	14
55	40
64	16
65	17
66	18
67	19
68	20
67	21
70	22
71	23
55	24
74	25
75	26
76	27
94	28
74	29
78	30
79	31
78	32
81	33
96	34
74	35
86	37
89	38
80	43
21	47
94	48
95	49
86	1
98	3
97	55
\.


--
-- Data for Name: actin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY actin (personid, showid) FROM stdin;
95	4
95	15
55	5
79	5
54	9
54	11
60	13
55	14
46	16
54	16
63	18
69	19
54	20
67	20
21	24
67	25
72	26
77	28
80	30
54	31
2	36
80	32
2	39
2	41
2	42
82	33
2	44
2	46
83	34
85	37
54	39
54	5
54	45
79	7
56	8
59	49
57	9
58	11
59	12
96	10
61	13
62	14
55	40
64	16
65	17
66	18
67	19
68	20
67	21
70	22
71	23
55	24
74	25
75	26
76	27
94	28
74	29
78	30
79	31
78	32
81	33
96	34
74	35
86	37
89	38
80	43
21	47
94	48
95	49
86	1
98	3
97	55
\.


--
-- Data for Name: actors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY actors (personid) FROM stdin;
1
2
3
4
5
6
7
8
9
10
12
13
15
16
17
18
19
20
22
26
27
28
30
31
32
33
34
35
36
37
39
40
41
43
44
45
46
47
48
49
50
52
53
54
14
42
38
25
29
23
11
51
24
55
56
57
58
59
21
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
\.


--
-- Data for Name: awardinst; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY awardinst (aiid, awardid, awarddate) FROM stdin;
\.


--
-- Data for Name: awards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY awards (awardid, name) FROM stdin;
\.


--
-- Data for Name: collections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY collections (colid) FROM stdin;
\.


--
-- Data for Name: compose; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY compose (personid, showid) FROM stdin;
\.


--
-- Data for Name: composers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY composers (personid) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY countries (countryid, name) FROM stdin;
1	Egypt
2	United States
3	France
\.


--
-- Data for Name: countriesmakeup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY countriesmakeup (countryid, cgid) FROM stdin;
\.


--
-- Data for Name: countrygroups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY countrygroups (cgid) FROM stdin;
\.


--
-- Data for Name: currencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY currencies (curid, name) FROM stdin;
1	Dollar
2	EGP
\.


--
-- Data for Name: direct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY direct (personid, showid) FROM stdin;
104	49
104	34
104	24
111	26
113	15
113	29
120	19
123	4
123	1
128	28
128	7
135	17
135	37
135	47
138	33
141	41
144	42
155	35
155	46
160	3
160	45
161	5
162	8
163	9
163	39
164	10
165	16
165	27
165	31
165	11
166	12
167	13
168	44
169	14
170	18
171	20
172	21
173	22
174	43
174	30
175	32
176	25
177	23
180	36
181	38
182	40
183	48
104	55
\.


--
-- Data for Name: directors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY directors (personid) FROM stdin;
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
143
144
145
146
147
148
149
150
151
152
153
154
155
156
157
158
159
160
161
162
163
164
165
166
167
168
169
170
171
172
173
174
175
176
177
178
179
180
181
182
183
\.


--
-- Data for Name: distribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY distribute (distid, showid) FROM stdin;
\.


--
-- Data for Name: distributors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY distributors (distid, name) FROM stdin;
\.


--
-- Data for Name: edit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY edit (personid, showid) FROM stdin;
\.


--
-- Data for Name: editors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY editors (personid) FROM stdin;
\.


--
-- Data for Name: episodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY episodes (episodeid, showid, title, reldate) FROM stdin;
1	52	Pilot	\N
2	53	Cat's in the Bag...	\N
\.


--
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY films (showid, year, reldate) FROM stdin;
1	2006	\N
3	2002	\N
4	2004	\N
5	2000	\N
7	2000	\N
8	2001	\N
9	2002	\N
10	2002	\N
11	2002	\N
12	2003	\N
13	2003	\N
14	2003	\N
15	2003	\N
16	2004	\N
17	2004	\N
18	2004	\N
19	2004	\N
20	2005	\N
21	2005	\N
22	2005	\N
23	2005	\N
24	2005	\N
25	2005	\N
26	2005	\N
27	2007	\N
28	2007	\N
29	2007	\N
30	2007	\N
31	2007	\N
32	2008	\N
33	2008	\N
34	2008	\N
35	2008	\N
36	2008	\N
37	2008	\N
38	2008	\N
39	2008	\N
40	2008	\N
41	2008	\N
42	2008	\N
43	2009	\N
44	2009	\N
45	2009	\N
46	2009	\N
47	2009	\N
48	2009	\N
49	2009	\N
64	\N	\N
55	2004	\N
\.


--
-- Data for Name: fluc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fluc (curid, flucid, change, flucdate) FROM stdin;
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY genres (genreid, name) FROM stdin;
1	Action
2	Adventure
3	Animation
4	Comedy
5	Crime
6	Documentry
7	Drama
8	Family
9	Fantasy
10	History
11	Horror
12	Musics
13	Mystery
14	Romance
15	SciFi
16	TV Movie
17	Thriller
18	War
19	Western
\.


--
-- Data for Name: handout; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY handout (orgid, awardid) FROM stdin;
\.


--
-- Data for Name: havefilms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY havefilms (colid, showid) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY org (orgid, name) FROM stdin;
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY people (personid, dob, age, fname, mname, lname) FROM stdin;
1	\N	\N	Faten	\N	Hamama
2	\N	\N	Hend	\N	Rostom
3	\N	\N	Soad	\N	Hosny
4	\N	\N	Shadia	\N	
5	\N	\N	Ahmed	\N	Mazhar
6	\N	\N	Rushdy	\N	Abaza
7	\N	\N	Imad	\N	Hamdi
8	\N	\N	Nadia	\N	Lutfi
9	\N	\N	Shukry	\N	Sarhan
10	\N	\N	Magda	\N	
12	\N	\N	Madiha	\N	Yousri
13	\N	\N	Farid	\N	Shawqi
15	\N	\N	Om	\N	Koultoum
16	\N	\N	Laila	\N	Mourad
17	\N	\N	Lobna	\N	Abdel
18	\N	\N	Mariem	\N	Fakhr
19	\N	\N	Ahmed	\N	Ramzy
20	\N	\N	Ismail	\N	Yasseen
22	\N	\N	Laila	\N	Taher
26	\N	\N	Soheir	\N	Ramzy
27	\N	\N	Shouweikar	\N	
28	\N	\N	Amina	\N	Rizk
30	\N	\N	Anwar	\N	Wagdi
32	\N	\N	Mahmoud	\N	Moursy
33	\N	\N	Samiha	\N	Ayyoub
34	\N	\N	Hussein	\N	Riad
35	\N	\N	Salah	\N	Zulfakar
36	\N	\N	Samia	\N	Gamal
37	\N	\N	Taheya	\N	Cariocca
39	\N	\N	Yehia	\N	Chahine
40	\N	\N	Zeinat	\N	Sedki
41	\N	\N	Tawfik	\N	El
43	\N	\N	Samir	\N	Sabri
44	\N	\N	Lebleba	\N	
45	\N	\N	Zaki	\N	Rostom
46	\N	\N	Amal	\N	Zayed
47	\N	\N	Sanaa	\N	Gamil
48	\N	\N	Salah	\N	Mansour
49	\N	\N	Mohamed	\N	Abdel
50	\N	\N	Youssef	\N	Fakhr
52	\N	\N	Naima	\N	Akef
53	\N	\N	Leila	\N	Fawzi
14	\N	\N	Abdel Halim	\N	
42	\N	\N	Sabah	\N	
38	\N	\N	Omar	\N	ElHariri
25	\N	\N	Soheir	\N	ElBably
29	\N	\N	Zahrat	\N	ElOla
23	\N	\N	Ragaa	\N	AlGidawy
11	\N	\N	Mahmoud	\N	ElMeliguy
51	\N	\N	Zubaida	\N	
24	\N	\N	OM Koulthoum	\N	ElKhatib
55	\N	\N	Ahmed	\N	Zaki
56	\N	\N	Ashraf	\N	Abdel Baqi
58	\N	\N	Nichole	\N	Saba
59	\N	\N	Ahmed	\N	Adam
21	\N	\N	Mona	\N	Zaki
60	\N	\N	Mai	\N	Ezzidine
61	\N	\N	Abla	\N	Kamel
62	\N	\N	Hisham	\N	Abdul Hamid
63	\N	\N	Mahmoud	\N	Hemida
64	\N	\N	Hala	\N	Shiha
65	\N	\N	Hiam	\N	Abbass
66	\N	\N	Leila	\N	Elwi
67	\N	\N	Hanan	\N	Tork
68	\N	\N	Dalia	\N	ElBehery
69	\N	\N	Mohamed	\N	Mounir
70	\N	\N	Tamer	\N	Hosny
71	\N	\N	Noha	\N	Fouad
72	\N	\N	Hanan	\N	Youssef
73	\N	\N	Yasmin	\N	AbdulAziz
74	\N	\N	Khaled	\N	Saleh
75	\N	\N	Ramadan	\N	Khater
76	\N	\N	Moustafa	\N	Amar
77	\N	\N	Ghada	\N	Adel
78	\N	\N	Menna	\N	Shalabi
79	\N	\N	Mervat	\N	Amin
80	\N	\N	Ahmed	\N	Helmy
81	\N	\N	Basem	\N	Samra
82	\N	\N	Yara	\N	Goubran
83	\N	\N	Mahmoud	\N	Yassine
84	\N	\N	Ruby	\N	
85	\N	\N	Amr	\N	Waked
86	\N	\N	Hend	\N	Sabry
87	\N	\N	Nour	\N	ElShereif
88	\N	\N	Mahmoud	\N	Abdul Aziz
89	\N	\N	Ahmed	\N	Mekky
90	\N	\N	Farook	\N	ElFishawy
91	\N	\N	Mahmoud	\N	ElFishawy
92	\N	\N	Khaled	\N	ElNabawy
93	\N	\N	Yousra	\N	
94	\N	\N	Khaled	\N	AbulNaga
95	\N	\N	Karim	\N	Abdel Aziz
96	\N	\N	Ahmed	\N	ElSakka
97	\N	\N	Mohamed	\N	Henedy
98	\N	\N	Mohamed	\N	Saad
99	\N	\N	Omar	\N	Shereif
100	\N	\N	Daoud	\N	Abdel Sayed
101	\N	\N	Salah	\N	Abu Seif
102	\N	\N	Youssef	\N	Alimam
103	\N	\N	Ayten	\N	Amin
104	\N	\N	Sherif	\N	Arafa
105	\N	\N	Ashraf	\N	Fahmy
106	\N	\N	Ovidio	\N	G. Assonitis
107	\N	\N	Islam	\N	el Azzazi
108	\N	\N	Ahmed	\N	Badrakhan
109	\N	\N	Emad	\N	El Bahat
110	\N	\N	Henry	\N	Barakat
111	\N	\N	Ibrahim	\N	El Batout
112	\N	\N	Khairy	\N	Beshara
113	\N	\N	Youssef	\N	Chahine
114	\N	\N	Inas	\N	El-Degheidy
115	\N	\N	Mohamed	\N	Diab
116	\N	\N	Ahmed	\N	Diaa Eddine
117	\N	\N	Karim	\N	Diaa Eddine
118	\N	\N	Hassan	\N	al-Imam
119	\N	\N	Atef	\N	El-Tayeb
120	\N	\N	Tarek	\N	Al Eryan
121	\N	\N	Paul	\N	Geday
122	\N	\N	Helmy	\N	Halim
123	\N	\N	Marwan	\N	Hamed
124	\N	\N	Mohamed	\N	Henedi
125	\N	\N	Youssef	\N	Hesham
126	\N	\N	Hussein	\N	Kamal
127	\N	\N	Aida	\N	El-Kashef
128	\N	\N	Mohamed	\N	Khan
129	\N	\N	Nasr	\N	Mahrous
130	\N	\N	Salah	\N	Mansour
131	\N	\N	Togo	\N	Mizrahi
132	\N	\N	Niazi	\N	Mostafa
133	\N	\N	Kal	\N	Naga
134	\N	\N	Ahmed	\N	El-Nahass
135	\N	\N	Yousry	\N	Nasrallah
136	\N	\N	Helmy	\N	Rafla
137	\N	\N	Lenin	\N	El-Ramly
138	\N	\N	Ahmed	\N	Rashwan
139	\N	\N	Stephan	\N	Rosti
140	\N	\N	Saad	\N	Nadim
141	\N	\N	Maher	\N	Sabry
142	\N	\N	Tamer	\N	El Said
143	\N	\N	Shadi	\N	Abdel Salam
144	\N	\N	Amr	\N	Salama
145	\N	\N	Tewfik	\N	Saleh
146	\N	\N	Atef	\N	Salem
147	\N	\N	Jackie	\N	Sawiris
148	\N	\N	Kamal	\N	El Sheikh
149	\N	\N	Kamal	\N	el-Shennawi
150	\N	\N	Jihan	\N	El-Tahri
151	\N	\N	Anwar	\N	Wagdi
152	\N	\N	Fatin	\N	Abdel Wahab
153	\N	\N	Youssef	\N	Wahbi
154	\N	\N	Bishara	\N	Wakim
57	\N	\N	Shereen	\N	\N
155	\N	\N	Khaled	\N	Youssef
156	\N	\N	Nour	\N	Zaki
157	\N	\N	Kamla	\N	Abou Zekry
158	\N	\N	Ezzel	\N	Dine Zulficar
159	\N	\N	Mahmoud	\N	Zulfikar
160	\N	\N	Wael	\N	Ihsan
161	\N	\N	Nader	\N	Galal
162	\N	\N	Said	\N	Hamed
163	\N	\N	Rami	\N	Imam
164	\N	\N	Samir	\N	Chamas
165	\N	\N	Ali	\N	Idris
166	\N	\N	Mounir	\N	Reda
167	\N	\N	Ahmed	\N	Awwadh
168	\N	\N	Ahmed	\N	Maher
169	\N	\N	Samir	\N	Seif
170	\N	\N	Osama	\N	Fawzy
171	\N	\N	Amr	\N	Arafa
172	\N	\N	Jocelyne	\N	Saab
173	\N	\N	Ali	\N	Ragab
174	\N	\N	Ahmed	\N	Nader Galal
175	\N	\N	Khaled	\N	Marei
176	\N	\N	Mohamed	\N	Gomaa
177	\N	\N	Mohamed	\N	Hammad
178	\N	\N	Mohamed	\N	Fadel
179	\N	\N	Mohamed	\N	Karim
180	\N	\N	Mohamed	\N	Yassine
181	\N	\N	Ahmed	\N	ElGendi
183	\N	\N	Ahmed	\N	Abdalla
31	\N	\N	Adel	\N	\N
182	\N	\N	Adel	\N	\N
54	\N	\N	Adel	\N	Imam
\.


--
-- Name: people_personid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('people_personid_seq', 183, true);


--
-- Data for Name: points; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY points (salid, personid, showid, points, value) FROM stdin;
\.


--
-- Data for Name: produce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY produce (personid, showid) FROM stdin;
\.


--
-- Data for Name: producers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY producers (personid) FROM stdin;
\.


--
-- Data for Name: ratinghist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ratinghist (rhid, showid, rateid) FROM stdin;
\.


--
-- Name: ratinghist_rhid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ratinghist_rhid_seq', 1, false);


--
-- Data for Name: ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ratings (rateid, ratings) FROM stdin;
\.


--
-- Data for Name: receive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY receive (showid, rateid) FROM stdin;
\.


--
-- Data for Name: recordedin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY recordedin (showid, cgid, revid, curid) FROM stdin;
\.


--
-- Data for Name: revenuehist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY revenuehist (showid, cgid, revid, amount, rhdate) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY role (personid, showid, role) FROM stdin;
\.


--
-- Data for Name: salaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY salaries (salid, personid, showid, amount) FROM stdin;
\.


--
-- Data for Name: salariespoints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY salariespoints (salid, personid, showid, type) FROM stdin;
\.


--
-- Data for Name: screennames; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY screennames (personid, sfname, smname, slname) FROM stdin;
\.


--
-- Data for Name: showgenres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY showgenres (genreid, showid) FROM stdin;
4	9
7	9
\.


--
-- Data for Name: shows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shows (showid, title, rating, language, overview) FROM stdin;
1	The Yacoubian Building	\N	\N	Nothing here yet
3	Ellemby	\N	\N	Nothing here yet
4	The Blue Elephant	\N	\N	Nothing here yet
5	Hello America	\N	\N	Nothing here yet
7	Ayyam El Sadat	\N	\N	Nothing here yet
8	Rasha Garea	\N	\N	Nothing here yet
9	Amir El Zalam	\N	\N	Nothing here yet
10	Africano	\N	\N	Nothing here yet
11	El Tagrubah El Danemarkiyyah	\N	\N	Nothing here yet
12	Film Hindi	\N	\N	Nothing here yet
13	Kalem Mama	\N	\N	Nothing here yet
14	Maali al Wazir	\N	\N	Nothing here yet
15	Alexandria... New York	\N	\N	Nothing here yet
16	Aris Min Geha Amneya	\N	\N	Nothing here yet
17	Bab El Shams	\N	\N	Nothing here yet
18	Baheb el cima	\N	\N	Nothing here yet
19	Tito	\N	\N	Nothing here yet
20	ElSefara Fi ElOmara	\N	\N	Nothing here yet
21	Dunia	\N	\N	Nothing here yet
22	Sayed El Atefy	\N	\N	Nothing here yet
23	Central	\N	\N	Nothing here yet
24	Halim	\N	\N	Nothing here yet
25	Ahlam Haqiqeya	\N	\N	Nothing here yet
26	Ein Shams	\N	\N	Nothing here yet
27	Esabet AlDoctor Omar	\N	\N	Nothing here yet
28	Fi shaket Masr El Gedeeda	\N	\N	Nothing here yet
29	Heya Fawda	\N	\N	Nothing here yet
30	Keda Reda	\N	\N	Nothing here yet
31	Morgan Ahmed Morgan	\N	\N	Nothing here yet
32	Asef Ala Al Izaag	\N	\N	Nothing here yet
33	Basra	\N	\N	Nothing here yet
34	El Gezira	\N	\N	Nothing here yet
35	El Rayes Omar Harb	\N	\N	Nothing here yet
36	El Waad	\N	\N	Nothing here yet
37	Genenet al asmak	\N	\N	Nothing here yet
38	H Dabour	\N	\N	Nothing here yet
39	Hassan wa Morkus	\N	\N	Nothing here yet
40	Leilet ElBaby Doll	\N	\N	Nothing here yet
41	Toul Omry	\N	\N	Nothing here yet
42	Zay El Naharda	\N	\N	Nothing here yet
43	1000 Mabrouk	\N	\N	Nothing here yet
44	AlMusafir	\N	\N	Nothing here yet
45	Bobbos	\N	\N	Nothing here yet
46	Dokkan Shehata	\N	\N	Nothing here yet
47	Ehki ya shahrazade	\N	\N	Nothing here yet
48	Heliopolis	\N	\N	Nothing here yet
49	Welaad El Am	\N	\N	Nothing here yet
50	Breaking Bad	\N	\N	Nothing here yet
52	Pilot	\N	\N	Nothing here yet
53	Cat's in the Bag...	\N	\N	Nothing here yet
64	ليلة سقوط بغداد	\N	\N	مع سقوط بغداد تحت الاحتلال الأمريكي، سقطت الشعوب العربية فريسة لهاجس يسأل من الدولة الآتية. شاكر ناظر مدرسة ثانوية يسقط فى وسواس دائم يسيطر على حياته اليومية، وهو يتصور نفسه مكان الإنسان العراقي الذى يراه على شاشةة التليفزيون وهو يهان ويذل تحت القدام الأمريكية.
55	Fool El Seen El Azeem	\N	\N	Nothing here yet
\.


--
-- Name: shows_showid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shows_showid_seq', 65, true);


--
-- Data for Name: tvshows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tvshows (showid, startdate, enddate) FROM stdin;
50	\N	\N
\.


--
-- Data for Name: wonbypeople; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY wonbypeople (aiid, personid) FROM stdin;
\.


--
-- Data for Name: wonbyshows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY wonbyshows (aiid, showid) FROM stdin;
\.


--
-- Data for Name: write; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY write (personid, showid) FROM stdin;
\.


--
-- Data for Name: writers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY writers (personid) FROM stdin;
\.


--
-- Name: actin actin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actin
    ADD CONSTRAINT actin_pkey PRIMARY KEY (personid, showid);


--
-- Name: awardinst awardinst_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY awardinst
    ADD CONSTRAINT awardinst_pkey PRIMARY KEY (aiid);


--
-- Name: awards awards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY awards
    ADD CONSTRAINT awards_pkey PRIMARY KEY (awardid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (colid);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (countryid);


--
-- Name: countrygroups countrygroups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countrygroups
    ADD CONSTRAINT countrygroups_pkey PRIMARY KEY (cgid);


--
-- Name: currencies currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (curid);


--
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (distid);


--
-- Name: episodes episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (episodeid);


--
-- Name: fluc fluc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fluc
    ADD CONSTRAINT fluc_pkey PRIMARY KEY (flucid);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genreid);


--
-- Name: org org_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY org
    ADD CONSTRAINT org_pkey PRIMARY KEY (orgid);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (personid);


--
-- Name: ratinghist ratinghist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ratinghist
    ADD CONSTRAINT ratinghist_pkey PRIMARY KEY (rhid);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (rateid);


--
-- Name: revenuehist revenuehist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY revenuehist
    ADD CONSTRAINT revenuehist_pkey PRIMARY KEY (revid);


--
-- Name: salariespoints salariespoints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY salariespoints
    ADD CONSTRAINT salariespoints_pkey PRIMARY KEY (salid);


--
-- Name: showgenres showgenres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY showgenres
    ADD CONSTRAINT showgenres_pkey PRIMARY KEY (genreid, showid);


--
-- Name: shows shows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shows
    ADD CONSTRAINT shows_pkey PRIMARY KEY (showid);


--
-- Name: tvshows tvshows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tvshows
    ADD CONSTRAINT tvshows_pkey PRIMARY KEY (showid);


--
-- Name: acthist acthist_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acthist
    ADD CONSTRAINT acthist_personid FOREIGN KEY (personid) REFERENCES people(personid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: acthist acthist_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acthist
    ADD CONSTRAINT acthist_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: actin actin_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actin
    ADD CONSTRAINT actin_personid FOREIGN KEY (personid) REFERENCES people(personid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: actin actin_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actin
    ADD CONSTRAINT actin_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: actors actorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY actors
    ADD CONSTRAINT actorid FOREIGN KEY (personid) REFERENCES people(personid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: awardinst awardinst_awards_awardid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY awardinst
    ADD CONSTRAINT awardinst_awards_awardid FOREIGN KEY (awardid) REFERENCES awards(awardid) ON DELETE SET NULL;


--
-- Name: compose compose_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compose
    ADD CONSTRAINT compose_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: compose compose_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compose
    ADD CONSTRAINT compose_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: composers composerid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY composers
    ADD CONSTRAINT composerid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- Name: countriesmakeup countriesmakeup_countries_countryid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countriesmakeup
    ADD CONSTRAINT countriesmakeup_countries_countryid FOREIGN KEY (countryid) REFERENCES countries(countryid) ON DELETE CASCADE;


--
-- Name: countriesmakeup countriesmakeup_countrygroups_cgid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countriesmakeup
    ADD CONSTRAINT countriesmakeup_countrygroups_cgid FOREIGN KEY (cgid) REFERENCES countrygroups(cgid) ON DELETE CASCADE;


--
-- Name: direct direct_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY direct
    ADD CONSTRAINT direct_personid FOREIGN KEY (personid) REFERENCES people(personid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: direct direct_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY direct
    ADD CONSTRAINT direct_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: directors directorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY directors
    ADD CONSTRAINT directorid FOREIGN KEY (personid) REFERENCES people(personid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: distribute distribute_distributors_distid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY distribute
    ADD CONSTRAINT distribute_distributors_distid FOREIGN KEY (distid) REFERENCES distributors(distid) ON DELETE SET NULL;


--
-- Name: distribute distribute_shows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY distribute
    ADD CONSTRAINT distribute_shows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: edit edit_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY edit
    ADD CONSTRAINT edit_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: edit edit_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY edit
    ADD CONSTRAINT edit_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: editors editorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY editors
    ADD CONSTRAINT editorid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- Name: episodes episodes_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: films films_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY films
    ADD CONSTRAINT films_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fluc fluc_currencies_curid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fluc
    ADD CONSTRAINT fluc_currencies_curid FOREIGN KEY (curid) REFERENCES currencies(curid) ON DELETE CASCADE;


--
-- Name: showgenres genres_genreid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY showgenres
    ADD CONSTRAINT genres_genreid FOREIGN KEY (genreid) REFERENCES genres(genreid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: handout handout_awards_awardid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY handout
    ADD CONSTRAINT handout_awards_awardid FOREIGN KEY (awardid) REFERENCES awards(awardid) ON DELETE SET NULL;


--
-- Name: handout handout_org_orgid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY handout
    ADD CONSTRAINT handout_org_orgid FOREIGN KEY (orgid) REFERENCES org(orgid);


--
-- Name: havefilms havefilms_colecs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY havefilms
    ADD CONSTRAINT havefilms_colecs FOREIGN KEY (colid) REFERENCES collections(colid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: havefilms havefilms_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY havefilms
    ADD CONSTRAINT havefilms_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: screennames personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY screennames
    ADD CONSTRAINT personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- Name: points points_people_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_people_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: points points_salariespoints; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_salariespoints FOREIGN KEY (salid) REFERENCES salariespoints(salid) ON DELETE SET NULL;


--
-- Name: points points_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: produce produce_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produce
    ADD CONSTRAINT produce_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: produce produce_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produce
    ADD CONSTRAINT produce_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: producers producerid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY producers
    ADD CONSTRAINT producerid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- Name: receive receive_ratings_rateid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY receive
    ADD CONSTRAINT receive_ratings_rateid FOREIGN KEY (rateid) REFERENCES ratings(rateid) ON DELETE CASCADE;


--
-- Name: receive receive_shows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY receive
    ADD CONSTRAINT receive_shows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE CASCADE;


--
-- Name: recordedin recordedin_countrygroups_cgid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY recordedin
    ADD CONSTRAINT recordedin_countrygroups_cgid FOREIGN KEY (cgid) REFERENCES countrygroups(cgid);


--
-- Name: recordedin recordedin_currencies_curid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY recordedin
    ADD CONSTRAINT recordedin_currencies_curid FOREIGN KEY (curid) REFERENCES currencies(curid);


--
-- Name: recordedin recordedin_ratinghist_revid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY recordedin
    ADD CONSTRAINT recordedin_ratinghist_revid FOREIGN KEY (revid) REFERENCES revenuehist(revid);


--
-- Name: recordedin recordedin_shows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY recordedin
    ADD CONSTRAINT recordedin_shows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE CASCADE;


--
-- Name: revenuehist revenuehist_cgropus_cgid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY revenuehist
    ADD CONSTRAINT revenuehist_cgropus_cgid FOREIGN KEY (cgid) REFERENCES countrygroups(cgid) ON DELETE CASCADE;


--
-- Name: revenuehist revenuehist_shows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY revenuehist
    ADD CONSTRAINT revenuehist_shows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE CASCADE;


--
-- Name: role role_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: salaries salaries_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY salaries
    ADD CONSTRAINT salaries_personid FOREIGN KEY (personid) REFERENCES people(personid);


--
-- Name: salaries salaries_salariespoints; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY salaries
    ADD CONSTRAINT salaries_salariespoints FOREIGN KEY (salid) REFERENCES salariespoints(salid) ON DELETE SET NULL;


--
-- Name: salaries salaries_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY salaries
    ADD CONSTRAINT salaries_showid FOREIGN KEY (showid) REFERENCES shows(showid);


--
-- Name: salariespoints salariespoints_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY salariespoints
    ADD CONSTRAINT salariespoints_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: salariespoints salariespoints_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY salariespoints
    ADD CONSTRAINT salariespoints_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: showgenres shows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY showgenres
    ADD CONSTRAINT shows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tvshows tvshows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tvshows
    ADD CONSTRAINT tvshows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wonbypeople wonbypeople_awardsinst_aiid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wonbypeople
    ADD CONSTRAINT wonbypeople_awardsinst_aiid FOREIGN KEY (aiid) REFERENCES awardinst(aiid) ON DELETE SET NULL;


--
-- Name: wonbypeople wonbypeople_people_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wonbypeople
    ADD CONSTRAINT wonbypeople_people_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: wonbyshows wonbyshows_awardsinst_aiid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wonbyshows
    ADD CONSTRAINT wonbyshows_awardsinst_aiid FOREIGN KEY (aiid) REFERENCES awardinst(aiid) ON DELETE SET NULL;


--
-- Name: wonbyshows wonbyshows_shows_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wonbyshows
    ADD CONSTRAINT wonbyshows_shows_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: write write_personid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY write
    ADD CONSTRAINT write_personid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE SET NULL;


--
-- Name: write write_showid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY write
    ADD CONSTRAINT write_showid FOREIGN KEY (showid) REFERENCES shows(showid) ON DELETE SET NULL;


--
-- Name: writers writerid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY writers
    ADD CONSTRAINT writerid FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

