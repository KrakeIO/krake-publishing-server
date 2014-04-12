payload =
  task_info_obj:
      task_id: "TEST"
      auth_token: "TEST"
      quota_limited: true
      pgParams:
          database: "scraped_data_repo_test"
          tableName: "kpp_test_table_1"            
          username: "test"
          password: "test"
          host: 
              url: "localhost"
              port: "5432"
      rawSchema:
          columns: [{
              col_name: "vehicle url",
              dom_query: ".vehicletitle a",
              required_attribute: "href",
              options: {
                  columns: [{
                      "col_name": "stock_number",
                      "is_index": true,
                      "dom_query": ".detailstitle:contains('Stock#')+span"
                  },{
                      "col_name": "year",
                      "dom_query": "h1 .cardata",
                      "regex_pattern": {}
                  },{
                      "col_name": "make",
                      "dom_query": "h1 .cardata",
                      "regex_pattern": {}
                  },{
                      "col_name": "model",
                      "dom_query": "h1 .cardata"
                  }]
              }
          }],
          data:
              condition: "used",
              pingedAt: "2014-03-22 04:39:25"
      columns: [{
          "col_name": "stock_number"
          "is_index": true
          "dom_query": ".detailstitle:contains('Stock#')+span"
      },{
          "col_name": "year"
          "dom_query": "h1 .cardata"
          "regex_pattern": {}
      },{
          "col_name": "make"
          "dom_query": "h1 .cardata"
          "regex_pattern": {}
      },{
          "col_name": "model"
          "dom_query": "h1 .cardata"
      }],
      data:
          condition: "used"
          pingedAt: "2014-03-22 04:39:25"
          origin_pattern: "http://www.marionford.com/inventory/newsearch/Used/"
          origin_url: "http://www.marionford.com/inventory/newsearch/Used/"
          "vehicle url": "http://www.marionford.com/Used-2011-Ford-Taurus-SEL-Marion-IL/vd/19049660"
      origin_url: "http://www.marionford.com/Used-2011-Ford-Taurus-SEL-Marion-IL/vd/19049660"
      task_type: "listing page scrape",
      url_to_process: "http://www.marionford.com/Used-2011-Ford-Taurus-SEL-Marion-IL/vd/19049660"
  interim_result_obj:
      condition: "used",
      pingedAt: "2014-03-22 04:39:25",
      origin_pattern: "http://www.marionford.com/inventory/newsearch/Used/",
      origin_url: "http://www.marionford.com/inventory/newsearch/Used/",
      "vehicle url": "http://www.marionford.com/Used-2011-Ford-Taurus-SEL-Marion-IL/vd/19049660",
      make: "Ford",
      model: "2011 Ford Taurus SEL - Marion, IL",
      "stock_number": "AA8816",
      year: "2011"

module.exports = payload