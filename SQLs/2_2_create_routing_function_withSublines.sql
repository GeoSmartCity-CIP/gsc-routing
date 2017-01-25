-- Function: public.pgr_fromatobwithsublines(double precision, double precision, double precision, double precision)

-- DROP FUNCTION public.pgr_fromatobwithsublines(double precision, double precision, double precision, double precision, integer, integer);

CREATE OR REPLACE FUNCTION public.pgr_fromatobwithsublines(
    IN x1 double precision,
    IN y1 double precision,
    IN x2 double precision,
    IN y2 double precision,
	IN day integer,
	IN daypart integer,
    OUT seq integer,
    OUT id integer,
    OUT name text,
    OUT geom geometry)
  RETURNS SETOF record AS
$BODY$
DECLARE
	sql     text; sridroutr int; 	startPoint geometry;	endPoint geometry;	nearesrsStartLine geometry;	nearestEndLine geometry;
	nearestStartNode geometry;	nearestEndNode geometry;        rec record;        routewihoutSubline geometry;
        startSubLine geometry;        startDeleteSubLine geometry;		pointStartSubLine geometry;
	pointEndSubLine geometry;		endSubLine geometry;
	endDeleteSubLine geometry;		finalStartRoute geometry;		finalEndRoute geometry;
	closestStartDistance double precision;		closestEndDistance double precision; count int; 
BEGIN
--Find the nearest StartLine
EXECUTE 'SELECT geom FROM public.network_routing 
    ORDER BY geom <-> ST_GeometryFromText(''POINT('||x1 || ' ' || y1 || ')'',4326) LIMIT 1' INTO nearesrsStartLine;
	startPoint:= ST_GeometryFromText('POINT('||x1 || ' ' || y1 || ')',4326);
	nearesrsStartLine:=  ST_SetSRID(nearesrsStartLine, 4326);
  
  --Find the StartPointSubLine
	pointStartSubLine:=  ST_ClosestPoint(nearesrsStartLine, startPoint);
	closestStartDistance:= ST_LineLocatePoint(nearesrsStartLine, pointStartSubLine);
	
    IF closestStartDistance>0.5 
     THEN
        nearestStartNode:= ST_EndPoint(nearesrsStartLine);
        startSubLine:=	ST_LineSubstring (nearesrsStartLine, ST_LineLocatePoint(nearesrsStartLine, pointStartSubLine), 1);
        startDeleteSubLine = ST_LineSubstring (nearesrsStartLine,0,ST_LineLocatePoint(nearesrsStartLine, pointStartSubLine));	
	 ELSE 
     
        nearestStartNode:= ST_StartPoint(nearesrsStartLine);
        startSubLine:=	ST_LineSubstring (nearesrsStartLine,0,ST_LineLocatePoint(nearesrsStartLine, pointStartSubLine));
        startDeleteSubLine:= ST_LineSubstring (nearesrsStartLine, ST_LineLocatePoint(nearesrsStartLine, pointStartSubLine), 1);
     
      
     
	 END IF;

EXECUTE 'SELECT geom FROM public.network_routing 
    ORDER BY geom <-> ST_GeometryFromText(''POINT('|| x2 || ' ' || y2 || ')'',4326) LIMIT 1' INTO nearestEndLine;
    endPoint:= ST_GeometryFromText('POINT('||x2 || ' ' || y2 || ')',4326);
	nearestEndLine:=  ST_SetSRID(nearestEndLine, 4326);
	
	 --Find the StartPointSubLine
	pointEndSubLine:=  ST_ClosestPoint(nearestEndLine, endPoint);
	closestEndDistance:=ST_LineLocatePoint(nearestEndLine, pointEndSubLine);
	
IF closestEndDistance>0.5 
 THEN
	nearestEndNode:= ST_EndPoint(nearestEndLine);
	endSubLine:=	ST_LineSubstring (nearestEndLine, ST_LineLocatePoint(nearestEndLine, pointEndSubLine), 1);
	endDeleteSubLine:= 	ST_LineSubstring (nearestEndLine,0,ST_LineLocatePoint(nearestEndLine, pointEndSubLine));
ELSE 
	 nearestEndNode:= ST_StartPoint(nearestEndLine);
	 endSubLine:=	ST_LineSubstring (nearestEndLine,0,ST_LineLocatePoint(nearestEndLine, pointEndSubLine));
	 endDeleteSubLine:= ST_LineSubstring (nearestEndLine, ST_LineLocatePoint(nearestEndLine, pointEndSubLine), 1);
	 END IF;
		

 DROP TABLE IF EXISTS route;
CREATE TEMP TABLE route AS
SELECT *
FROM   
 pgr_fromAtoB('tmp_join', ST_X(nearestStartNode), ST_Y(nearestStartNode), ST_X(nearestEndNode),ST_Y(nearestEndNode), day, daypart  ) 
   ORDER BY  seq;





count := COUNT(*) FROM route;
	seq := 0;


	FOR rec IN (SELECT recs.id, recs.a_nom_comp, recs.geom FROM public.network_routing as recs, route WHERE recs.id=route.id )
        LOOP
        seq := seq + 1;
        if(seq=1)then 
		
		
			if(closestStartDistance>0.5) then
				   if(ST_DWithin(routewihoutSubline, ST_StartPoint(startSubLine), 0.1, true))then
							id  := rec.id;
							name := rec.a_nom_comp;
							geom  := ST_Difference(rec.geom, ST_Buffer(startSubLine::geography, 0.1)::geometry);
							
					
				   else
							id  := rec.id;
							name := rec.a_nom_comp;
							geom  := ST_Union(ARRAY[rec.geom, startSubLine]);
							
				   end if;
			else
				   if(ST_DWithin(routewihoutSubline, ST_EndPoint(startSubLine), 0.1, true))then
							id  := rec.id;
							name := rec.a_nom_comp;
							geom  := ST_Difference(rec.geom, ST_Buffer(startSubLine::geography, 0.1)::geometry);
							
				   else
							id  := rec.id;
							name := rec.a_nom_comp;
							geom  := ST_Union(ARRAY[rec.geom, startSubLine]);
							
				   end if;
			end if;
				   
				   
				   
			ELSIF (seq = count) then
				if(closestEndDistance>0.5) then
					   if(ST_DWithin(finalStartRoute, ST_StartPoint(endSubLine), 0.1, true))then
								id  := rec.id;
								name := rec.a_nom_comp;
								geom  := ST_Difference(rec.geom, ST_Buffer(endSubLine::geography, 0.1)::geometry);
								
					   else
						id  := rec.id;
								name := rec.a_nom_comp;
								geom  := ST_Union(ARRAY[rec.geom, endSubLine]);
								
					   end if;
				   else
					   if(ST_DWithin(finalStartRoute, ST_EndPoint(endSubLine), 0.1, true))then
								id  := rec.id;
								name := rec.a_nom_comp;
								geom  := ST_Difference(rec.geom, ST_Buffer(endSubLine::geography, 0.1)::geometry);
								
					   else
								id  := rec.id;
								name := rec.a_nom_comp;
								geom  := ST_Union(ARRAY[rec.geom, endSubLine]);
								
					   end if;
				   end if;

		else 
				id  := rec.id;
                name := rec.a_nom_comp;
                geom  := rec.geom;
                

		end if;
	
		RETURN NEXT;
        END LOOP;
        RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.pgr_fromatobwithsublines(double precision, double precision, double precision, double precision, integer, integer)
  OWNER TO postgres;
