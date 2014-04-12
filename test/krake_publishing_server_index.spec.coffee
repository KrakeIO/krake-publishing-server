app = require "../krake_publishing_server"
request = require "request"
PgHandler = require('krake-toolkit').data.pg_handler

describe "KrakePublishingServer indexed", ->

  beforeEach (done)->
    app.listen 9806
    connection_query = require "./fixtures/json/connection_query_with_index"
    @pg_handler = new PgHandler connection_query, ()=>
      done()

  afterEach (done)->
    app.close()
    @pg_handler.trucateTable ()=>
      done()
          
  it "should handle itself properly", (done)->
    options = 
      method: 'POST'  
      url : 'http://localhost:9806/publish'
      json : require "./fixtures/json/indexed_payload"

    request options, (error, response, body)=>
      expect(error).toBe null
      expect(response.statusCode).toEqual 200

      setTimeout ()=>
        @pg_handler.fetchRecords (records)=>
          expect(records.length).toEqual 1
          console.log records
          expect(records[0]["make"]).toEqual '3000'

          options = 
            method: 'POST'  
            url : 'http://localhost:9806/publish'
            json : require "./fixtures/json/indexed_payload"

          request options, (error2, response2, body2)=>
            expect(error2).toBe null
            expect(response2.statusCode).toEqual 200

            setTimeout ()=>
              @pg_handler.fetchRecords (records)=>
                console.log records
                expect(records.length).toEqual 1
                expect(records[0]["make"]).toEqual '3000'
                done()                
            , 500

      , 500

  it "should update with 1_nested", (done)->
    options = 
      method: 'POST'  
      url : 'http://localhost:9806/publish'
      json : require "./fixtures/json/indexed_payload"

    request options, (error, response, body)=>
      expect(error).toBe null
      expect(response.statusCode).toEqual 200

      setTimeout ()=>
        @pg_handler.fetchRecords (records)=>
          expect(records.length).toEqual 1
          expect(records[0]["make"]).toEqual '3000'

          options = 
            method: 'POST'  
            url : 'http://localhost:9806/publish'
            json : require "./fixtures/json/indexed_payload_1_nested"

          request options, (error2, response2, body2)=>
            expect(error2).toBe null
            expect(response2.statusCode).toEqual 200

            setTimeout ()=>
              @pg_handler.fetchRecords (records)=>
                expect(records.length).toEqual 1
                expect(records[0]["make"]).toEqual '4000'
                done()                
            , 500

      , 500

  it "should update with 2_nested", (done)->
    options = 
      method: 'POST'  
      url : 'http://localhost:9806/publish'
      json : require "./fixtures/json/indexed_payload"

    request options, (error, response, body)=>
      expect(error).toBe null
      expect(response.statusCode).toEqual 200

      setTimeout ()=>
        @pg_handler.fetchRecords (records)=>
          expect(records.length).toEqual 1
          expect(records[0]["make"]).toEqual '3000'

          options = 
            method: 'POST'  
            url : 'http://localhost:9806/publish'
            json : require "./fixtures/json/indexed_payload_2_nested"

          request options, (error2, response2, body2)=>
            expect(error2).toBe null
            expect(response2.statusCode).toEqual 200

            setTimeout ()=>
              @pg_handler.fetchRecords (records)=>
                expect(records.length).toEqual 1
                expect(records[0]["make"]).toEqual '4000'
                done()                
            , 500

      , 500