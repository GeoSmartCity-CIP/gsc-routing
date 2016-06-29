# gsc-routing
GeoSmartCity  routing service 


This is a Java project for routing OSM data in Girona
![alt tag](https://raw.githubusercontent.com/GeoSmartCity-CIP/gsc-routing/master/images/preview.jpg)


###Rest API GET
There is a Service in REST API GET to get the route in GeoJson format.

http://hub.geosmartcity.eu/GironaRouting/geo/RestService/getroute?x1={Latitude Starting Point}&y1={Longitude Starting Point}&x2={Latitude Ending Point}&y2={Longitude Starting Point}


###Rest API POST
There is a Service in REST API POST to get the route in GeoJson format.

POST /getroute?x1={Latitude Starting Point}&y1={Longitude Starting Point}&x2={Latitude Ending Point}&y2={Longitude Starting Point} 

HTTP/1.1

Content-Length: 0

Host: http://hub.geosmartcity.eu/GironaRouting/geo/RestService 



PS. The points must be inside the extent of Girona, Spain. 

###Status

The development of the service has been completed.

 

###Funding

The development of Girona Routing Service is part-funded by the European Commission through the GeoSmartCity project
