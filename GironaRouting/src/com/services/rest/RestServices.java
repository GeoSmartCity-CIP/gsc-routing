package com.services.rest;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Application;
import javax.ws.rs.core.MediaType;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@Path("/RestService") 
@ApplicationPath("/geo")
public class RestServices  extends Application{
	
	//http://localhost:8080/GironaRouting/geo/RestService/sayHello
	@GET
	@Path("/sayHello")
	@Produces(MediaType.APPLICATION_JSON)
	public String GetHelloMessage(){
		return "Hello World";		
	}
	
	//http://localhost:8080/GironaRouting/geo/RestService/getroute?x1=2.81098&y1=41.97196&x2=2.81447&y2=41.97530
	@GET
	@Path("/getroute")
	@Produces(MediaType.APPLICATION_JSON  + ";charset=utf-8")
	public String GetRoute(@QueryParam("x1") double x1, @QueryParam("y1") double y1, @QueryParam("x2") double x2, @QueryParam("y2") double y2 )
	{
		System.out.println(x1);
		System.out.println(y1);
		System.out.println(x2);
		System.out.println(y2);
		String json = Routing.GetRoute(x1, y1, x2, y2);
		System.out.println(json);
		return json; 
	}
	
	//http://localhost:8080/GironaRouting/geo/RestService/postroute?x1=,y1=‚x2=,y2=
	@POST
	@Path("/postroute/x1?={x1},y1={y1},x2={x2},y2={y2}")
	@Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
	public String PostRoute(@QueryParam("x1") double x1, @QueryParam("y1") double y1, @QueryParam("x2") double x2, @QueryParam("y2") double y2 )
	{
		
		String json = Routing.GetRoute(x1, y1, x2, y2);
		return json; 
	}
}
