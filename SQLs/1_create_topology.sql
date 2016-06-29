ALTER TABLE network_routing ADD COLUMN "source" integer;
ALTER TABLE network_routing ADD COLUMN "target" integer;

--CREATE EXTENSION pgrouting;

--SELECT pgr_version();

ALTER TABLE public.network_routing
  ADD COLUMN id2 integer;    

UPDATE   public.network_routing
SET id2=id;


ALTER TABLE public.network_routing
  DROP COLUMN id;

ALTER TABLE public.network_routing
  ADD COLUMN id integer;

UPDATE   public.network_routing
SET id=id2;


ALTER TABLE public.network_routing
  ADD CONSTRAINT primary_key_idx PRIMARY KEY (id);

ALTER TABLE public.network_routing
  DROP COLUMN id2;





-- Run topology function
SELECT pgr_createTopology('network_routing', 0.00001, 'geom', 'id');



--CREATE INDEX network_routing_source_idx ON network_routing ("source");
--CREATE INDEX network_routing_target_idx ON network_routing ("target");




 ALTER TABLE public.network_routing
  ADD COLUMN reverse_cost double precision;


UPDATE network_routing
SET reverse_cost=cost
WHERE oneway='FT' OR oneway='DD' OR oneway = '';

UPDATE network_routing
SET reverse_cost=cost+100000
WHERE oneway='TF' OR oneway='N';

SELECT Count(*) FROM network_routing
WHERE reverse_cost=NULL;



