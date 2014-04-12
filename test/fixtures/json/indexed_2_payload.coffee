payload =

  interim_result_obj:
    pingedAt: "2014-03-22 04:39:25"
    origin_pattern: "http://www.marionford.com/inventory/newsearch/Used/"
    origin_url: "http://www.marionford.com/inventory/newsearch/Used/"
    stock_number: "Honda Civic 2013"
    make: "3000"
    model: "fast runny"

  task_info_obj:
    task_id: "TEST"

    origin_url: "http://www.marionford.com/Used-2011-Ford-Taurus-SEL-Marion-IL/vd/19049660"
    columns: [{
      col_name: "stock_number"
      dom_query: ".detailstitle:contains('Stock#')+span"
      is_index: true      
    },{
      col_name: "make"
      dom_query: "h1 .cardata"
      is_index: true      
    },{
      col_name: "model"
      dom_query: "h1 .cardata"
    }]

    rawSchema:
      columns: [{
        col_name: "stock_number"
        dom_query: ".detailstitle:contains('Stock#')+span"
        is_index: true        
      },{
        col_name: "make"
        dom_query: "h1 .cardata"
        is_index: true        
      },{
        col_name: "model"
        dom_query: "h1 .cardata"
      }]
      data:
        pingedAt: "2014-03-22 04:39:25"

    pgParams:
      database: "scraped_data_repo_test"
      tableName: "kpp_test_table_2"            
      username: "test"
      password: "test"
      host: 
        url: "localhost"
        port: "5432"

module.exports = payload