require 'consolecolors'
request = require 'request'
sqlite3 = require 'sqlite3'
express = require 'express'
jade    = require 'jade'
stylus  = require 'stylus'
fs      = require 'fs'
coffee  = require 'coffee-script'

console.log 'Starting'.blue
app = express()
db = new sqlite3.Database __dirname+'/data/'+'database.db'

db.run '
	CREATE TABLE IF NOT EXISTS "items"
	(
		"id" int,
		"lan" char,
		"json" char
	)
', (err)->
	throw err if err
	console.log 'Startup complete'.blue
	startWebServer()

_getItem = (id,lan,cb)->
	db.get 'SELECT * FROM items WHERE id=$id and lan=$lan',{$id:id,$lan:lan},(err,data)->
		cb data

_render = (res,view,data)->
	res.render __dirname+'/views/'+view+'.jade',data
	return

app.get '/style.css', (req,res)->
	styl = fs.readFileSync(__dirname+'/views/item.styl',{encoding:'utf8'})
	stylus.render styl,(err,css)->
		res.header "Content-type", "text/css"
		res.send css

app.get '/destinyArmory.js', (req,res)->
	script = fs.readFileSync(__dirname+'/views/armory.coffee',{encoding:'utf8'})
	compiled = coffee.compile script
	res.header "Content-type", "application/javascript"
	res.send compiled

app.get '/test',(req,res)->
	res.render __dirname+'/views/test.jade',{pretty:true}

app.get '/:id/:lan?', (req,res)->
	lan = req.params.lan or 'en'
	_getItem req.params.id, lan, (data)->
		if data is undefined
			request 'http://www.bungie.net/Platform/Destiny/Manifest/inventoryItem/'+req.params.id+'/?lc='+lan+'&definitions=true', (err,data,body)->
				body = JSON.parse body
				if body.ErrorStatus isnt 'Success'
					res.sendStatus 404
					return

				db.run 'INSERT INTO items (id,json,lan) VALUES($id,$json,$lan)',{
					$id : req.params.id
					$json : JSON.stringify(body.Response)
					$lan : lan
				},(err)->
					_getItem req.params.id, lan, (data)->
						_render res,'item',JSON.parse(data.json)
						return
		else
			_render res,'item',JSON.parse(data.json)
			return


startWebServer = ->
	app.listen 8080, ->
		console.log 'Webserver online:','http://localhost:8080'.magenta.underline