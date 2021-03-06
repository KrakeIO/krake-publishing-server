# @Description : The Publishing Server that listens for remote publish requests via HTTP POST

# dependency libraries
express = require 'express'
fs = require 'fs'
kson = require 'kson'
NetworkPublisher = require './networking/network_publisher'
path = require 'path'

# Web Server section of system
app = module.exports = express.createServer();

app.configure ()->
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(app.router);
  return app.use(express["static"](__dirname + "/public"))


app.get '/', (req, res)->
  res.send 'Publishing Server'

app.post '/publish', (req, res)->
  task_info_obj       = req.body.task_info_obj
  interim_result_obj  = req.body.interim_result_obj

  console.log "[KRAKE PUBLISHING SERVER] #{new Date()} : Publishing transaction started"

  for colname, colval of interim_result_obj
    console.log '  column'
    console.log '    colname : %s', colname
    console.log '    colval  : %s', colval
  
  publisher = new NetworkPublisher() 
  publisher.publish task_info_obj, interim_result_obj, (message, type)=>
    response = {}
    response.message = message
    response.type = type
    res.send response
    console.log "[KRAKE PUBLISHING SERVER] #{new Date()} : Publishing transaction ended\r\n\r\n"    

module.exports = app

if !module.parent
  # Start api server
  port = process.argv[2] || 9806
  app.listen port
  console.log 'publishing server started on', port