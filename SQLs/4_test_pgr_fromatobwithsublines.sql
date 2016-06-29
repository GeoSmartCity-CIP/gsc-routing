--test routing algorithm without using dead end roads 
SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
                SELECT id ,
                         source::integer,
                         target::integer,
                         cost
                        FROM network_routing
                        WHERE oneway!=''' ||'N' || '''',
                1867, 2300, false, false);




--test routing algorithm
SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
                SELECT id ,
                         source::integer,
                         target::integer,
                         cost, reverse_cost
                        FROM network_routing 
                        WHERE oneway!=''' ||'N' || '''',
                1867, 2300, true, true);


--routing from A point to B
--iput X, Y starting point
-- X, Y ending point
--in WGS '84'
SELECT * FROM public.pgr_fromatob(2.8025951377640012, 41.973147232665525, 
                                                2.807710646011401, 41.97307065896433);


--routing form A to B merged the sublines
--iput X, Y starting point
-- X, Y ending point
--in WGS '84'
SELECT * FROM public.pgr_fromatobwithsublines(2.8025951377640012, 41.973147232665525, 
                                                2.807710646011401, 41.97307065896433);