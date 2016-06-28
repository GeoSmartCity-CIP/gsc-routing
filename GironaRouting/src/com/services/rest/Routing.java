package com.services.rest;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.dbg.connector.DBConnector;

public class Routing {
	
	 public static String GetRoute (double x1, double y1, double x2, double y2)     {
	        Connection con = null;
	        Statement st = null;
	        ResultSet rs = null;
	        String results="";
	    	try {
	    		
	    			con = DBConnector.getConnection();
	            
	    		
	    			st = con.createStatement();
	    			
	    			String routingQuery = "Select id, ST_AsGeoJSON(geom)from public.pgr_fromatobwithsublines(";
	    			String routingQuery2 = ") As lg )    As    f)    As fc;";
	    			routingQuery= "SELECT row_to_json(fc) "+ 
					"FROM (SELECT \'FeatureCollection\' As type, array_to_json(array_agg(f)) As features " + 
					"FROM (SELECT \'Feature\' As type , ST_AsGeoJSON(lg.geom)::json As geometry , row_to_json((SELECT l FROM (SELECT seq, id , name) As l" + 
					")) As properties FROM public.pgr_fromatobwithsublines("; 
		            rs = st.executeQuery(routingQuery + x1 + ", " + y1 + ", "  + x2 + ", " +  y2 + routingQuery2 );

	           
		            while(rs.next()) {
		            	 results = 	rs.getString(1);
		            }
	            	
		           
	            	
	           

	        } catch (SQLException ex) {
	        	//result = ex.getMessage();
	        	Logger lgr = Logger.getLogger(DBConnector.class.getName());
	            lgr.log(Level.SEVERE, ex.getMessage(), ex);



	        } catch (Exception  ex) {
				// TODO Auto-generated catch block
	        	//result = e.getMessage();
	        	Logger lgr = Logger.getLogger(DBConnector.class.getName());
	            lgr.log(Level.SEVERE, ex.getMessage(), ex);


			}  finally {
	            try {
	                if (rs != null) {
	                    rs.close();
	                }
	                if (st != null) {
	                    st.close();
	                }
	                if (con != null) {
	                    //con.close();
	                }

	            } catch (SQLException ex) {
	            	//result = ex.getMessage();
	            	Logger lgr = Logger.getLogger(DBConnector.class.getName());
	                lgr.log(Level.SEVERE, ex.getMessage(), ex);
	            }
	            
	        }
	    	return results;
	    }
	

}
