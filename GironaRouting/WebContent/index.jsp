<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Example of routing service using gsc.routing</title>
    <link href="ol.css" rel="stylesheet">
    <script src="ol.js"></script>
    <link href="gsc.css" rel="stylesheet">
    <style>
        #map {
            width: 100%;
            height: 400px;
        }
        
        #scalebar {
            float: right;
        }
    </style>
</head>

<body>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="page-header">
        <div class="container">
            <h2>View/Browse map</h2>
            <p id="example"> See the <a href="routing.js" target="_blank">Browse/View routing source</a> to see how this is done.</p>
        </div>
    </div>



    <div class="container">
        X1: <input type="number" id="x1" /> Y1: <input type="number" id="y1" /> X2: <input type="number" id="x2" /> Y2: <input type="number" id="y2" />
        <button onclick="myFunction()">Clear</button>
        <div id="mouse-position"></div>
        <div id='map'></div>
       
        <script src="routing.js"></script>

    </div>
</body>

</html>