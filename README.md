DESTINY ARMORY
=================

A plugin to display the inventory items in various languages

##Requirements
This server works using nodejs, npm and coffeescript. Refer to proper documentation for that instalation.

##Instalation
Just clone this repository into desired location. ````cd```` to the directory and

	npm install

Form there you can start the server with

	coffee app.coffee

Or use a daemon like forever to keep it alive

	forever start -c coffee app.coffee

Either way the server will spawn at port **8080** and be ready to work.  
Head to **http://localhost:8080/test** to try it.

##TODO:
Some address and port are hardcoded. Those need to be configurable.