query = 
  username: "test"
  password: "test"
  tableName: "kpp_test_table_2"
  host: 
    url: "localhost"
    port: "5432"
  database: "scraped_data_repo_test"
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
    },{
      col_name: "vehicle_url"
      dom_query: "h1 .cardata"
    },{
      col_name: "vehicle_url_2"
      dom_query: "h1 .cardata"
    },{
      col_name: "vehicle_url_3"
      dom_query: "h1 .cardata"
  }],
  origin_url: "http://www.marionford.com/Used-2011-Ford-Taurus-SEL-Marion-IL/vd/19049660"


module.exports = query