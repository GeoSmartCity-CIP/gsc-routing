package com.dbg.connector;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnector {

    private static Connection con;

    public static void createConnection(String dbUrl , String db, String dbusername,String dbPassword){
        try {
            Class.forName("org.postgresql.Driver");
            con=DriverManager.getConnection(dbUrl + db, dbusername, dbPassword);     
        } catch (Exception ex) {
            ex.printStackTrace();
        }    
    }

    public static Connection getConnection(){
        return con;
    }

    public static void closeConnection(){
        if(con!=null){
            try {
                con.close();
            } catch (SQLException ex) {
                 ex.printStackTrace();
            }
        }

    }
}
