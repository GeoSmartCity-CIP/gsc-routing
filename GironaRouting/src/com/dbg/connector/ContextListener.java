package com.dbg.connector;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ContextListener implements ServletContextListener {

    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context=sce.getServletContext();
        String dburl=context.getInitParameter("dbUrl");
        String db=context.getInitParameter("db");
        String dbusername=context.getInitParameter("dbUserName");
        String dbpassword=context.getInitParameter("dbPassword");

        DBConnector.createConnection(dburl, db, dbusername, dbpassword);
        
        
    }

    public void contextDestroyed(ServletContextEvent sce) {
        DBConnector.closeConnection();
    }

}
