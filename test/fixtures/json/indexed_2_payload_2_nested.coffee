payload =

  interim_result_obj:
    pingedAt: "2014-03-22 04:39:25"
    origin_pattern: "http://www.marionford.com/inventory/newsearch/Used/"
    origin_url: "http://www.marionford.com/inventory/newsearch/Used/"
    stock_number: "Honda Civic 2013"
    make: "3000"
    model: "slow runny"
    detail_page: "http://car_detail_page"    

  task_info_obj:
    task_id: "TEST"
    
    origin_url: "http://car_detail_page"
    columns: [{
      col_name: "vehicle_url"
      dom_query: ".vehicletitle a"
    },{
      col_name: "make"
      is_index: true      
      dom_query: "h1 .cardata"
    }]

    rawSchema:
      columns: [{
        col_name: "stock_number"
        is_index: true
        required_attribute: "href"
        options:
          columns: [{
            col_name: "vehicle_url"
            dom_query: ".vehicletitle a"
          },{
            col_name: "make"
            is_index: true
            dom_query: "h1 .cardata"
          }]
      }],
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