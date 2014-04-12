app = require "../krake_publishing_server"
request = require "request"
PgHandler = require('krake-toolkit').data.pg_handler

describe "KrakePublishingServer basic", ->

  beforeEach (done)->
    app.listen 9806
    connection_query = require "./fixtures/json/connection_query_with_index"
    @pg_handler = new PgHandler connection_query, ()=>
      done()

  afterEach (done)->
    app.close()
    @pg_handler.trucateTable ()=>
      done()

  it "should publish a record to a repository successfully", (done)->
    options = 
      method: 'POST'  
      url : 'http://localhost:9806/publish'
      json : require "./fixtures/json/payload_with_index"

    request options, (error, response, body)=>
      expect(error).toBe null
      expect(response.statusCode).toEqual 200
      setTimeout ()=>
        @pg_handler.fetchRecords (records)=>
          expect(records.length).toEqual 1
          expect(records[0]["year"]).toEqual '2011'
          done()        
      , 500

  it "should update a record at a repository successfully", (done)->
    options = 
      method: 'POST'  
      url : 'http://localhost:9806/publish'
      json : require "./fixtures/json/payload_with_index"

    request options, (error, response, body)=>
      expect(error).toBe null
      expect(response.statusCode).toEqual 200

      setTimeout ()=>
        @pg_handler.fetchRecords (records)=>
          expect(records.length).toEqual 1
          expect(records[0]["year"]).toEqual '2011'

          options = 
            method: 'POST'  
            url : 'http://localhost:9806/publish'
            json : require "./fixtures/json/updated_payload_with_index"

          request options, (error2, response2, body2)=>
            expect(error2).toBe null
            expect(response2.statusCode).toEqual 200

            setTimeout ()=>
              @pg_handler.fetchRecords (records)=>
                console.log records
                expect(records.length).toEqual 1
                expect(records[0]["year"]).toEqual '2021'
                done()                
            , 500

      , 500
