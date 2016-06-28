-- Function: public.pgr_fromatob(character varying, double precision, double precision, double precision, double precision)

DROP FUNCTION public.pgr_fromatob(character varying, double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION public.pgr_fromatob(IN tbl character varying, IN x1 double precision, IN y1 double precision, IN x2 double precision, IN y2 double precision, 
OUT seq integer, OUT id integer,  OUT name text, OUT geom geometry)
  RETURNS SETOF record AS
$BODY$
DECLARE
        sql     text;
        rec     record;
        source	integer;
        target	integer;
        point	integer;
        
BEGIN
	-- Find nearest node
	EXECUTE 'SELECT id::integer FROM public."network_routing_vertices_pgr" 
			ORDER BY the_geom <-> ST_GeometryFromText(''POINT(' 
			|| x1 || ' ' || y1 || ')'',4326) LIMIT 1' INTO rec;
	source := rec.id;
	
	EXECUTE 'SELECT id::integer FROM public."network_routing_vertices_pgr" 
			ORDER BY the_geom <-> ST_GeometryFromText(''POINT(' 
			|| x2 || ' ' || y2 || ')'',4326) LIMIT 1' INTO rec;
	target := rec.id;

	-- Shortest path query (TODO: limit extent by BBOX) 
        seq := 0;
        sql := 'SELECT  id, geom,  a_nom_comp,  source, target, 
				ST_Reverse(geom) AS flip_geom FROM ' ||
                        'pgr_dijkstra(''SELECT id, source::int, target::int, '
                                        || 'cost, reverse_cost FROM '
                                        || quote_ident(tbl) || ' WHERE oneway!=''''' || 'N' || ''''''', '
                                        || source || ', ' || target 
                                        || ' , true, true), '
                                || quote_ident(tbl) || ' WHERE id2 = id ORDER BY seq';

	-- Remember start point
        point := source;

        FOR rec IN EXECUTE sql
        LOOP
		-- Flip geometry (if required)
		IF ( point != rec.source ) THEN
			rec.geom := rec.flip_geom;
			point := rec.source;
		ELSE
			point := rec.target;
		END IF;

		

		-- Return record
                seq     := seq + 1;
                id     := rec.id;
                name := rec.a_nom_comp;
                geom    := rec.geom;
                RETURN NEXT;
        END LOOP;
        RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100
  ROWS 1000;
ALTER FUNCTION public.pgr_fromatob(character varying, double precision, double precision, double precision, double precision)
  OWNER TO postgres;
