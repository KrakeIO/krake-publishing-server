schema =
  pgParams:
    database: 'scraped_data_repo_test'
    tableName: 'test_publishes_permuted'
    username: 'test'
    password: 'test'
    host: 
      host: '127.0.0.1'
      port: 5432
  origin_url: "http://item.taobao.com/item.htm?id=2198023897"
  permuted_columns:
    handles: [{
      col_name: "measurement",
      dom_query: ".tb-prop:nth-child(1) a",
      selected_checksum: ".tb-selected"
    },{
      col_name: "color",
      dom_query: ".tb-prop:nth-child(2) a",
      selected_checksum: ".tb-selected"
    }],
    responses: [{
      col_name: "enlarged_image",
      dom_query: ".tb-gallery img#J_ImgBooth",
      required_attribute: "src"
    },{
      col_name: "stock",
      dom_query: "#J_SpanStock"
    }]
  "wait" : 35000,
  "cookies" : [{
    "domain": ".taobao.com",
    "hostOnly": false,
    "httpOnly": true,
    "name": "_tb_token_",
    "path": "/",
    "secure": false,
    "session": true,
    "storeId": "0",
    "value": "e357673413643"
  },{
    "domain": ".taobao.com",
    "expirationDate": 1708055630.192562,
    "hostOnly": false,
    "httpOnly": false,
    "name": "cna",
    "path": "/",
    "secure": false,
    "session": false,
    "storeId": "0",
    "value": "BzF3C277DWcCAXTXqkOwJZ19"
  },{
    "domain": ".taobao.com",
    "hostOnly": false,
    "httpOnly": true,
    "name": "cookie2",
    "path": "/",
    "secure": false,
    "session": true,
    "storeId": "0",
    "value": "c34b8c501803950fdf24969f6a0d9f47"
  },{
    "domain": ".taobao.com",
    "expirationDate": 1708585810,
    "hostOnly": false,
    "httpOnly": false,
    "name": "lzstat_uv",
    "path": "/",
    "secure": false,
    "session": false,
    "storeId": "0",
    "value": "14893130332161399892|3284827@2581759@2581747"
  },{
    "domain": ".taobao.com",
    "expirationDate": 1394414968,
    "hostOnly": false,
    "httpOnly": false,
    "name": "mt",
    "path": "/",
    "secure": false,
    "session": false,
    "storeId": "0",
    "value": "ci%3D0_0"
  },{
    "domain": ".taobao.com",
    "expirationDate": 1401586168.262333,
    "hostOnly": false,
    "httpOnly": false,
    "name": "t",
    "path": "/",
    "secure": false,
    "session": false,
    "storeId": "0",
    "value": "e2383ec5322d844291cd063323c98a84"
  },{
    "domain": ".taobao.com",
    "hostOnly": false,
    "httpOnly": false,
    "name": "uc1",
    "path": "/",
    "secure": false,
    "session": true,
    "storeId": "0",
    "value": "cookie14=UoLVZqEyjVNufw%3D%3D"
  },{
    "domain": ".taobao.com",
    "hostOnly": false,
    "httpOnly": false,
    "name": "v",
    "path": "/",
    "secure": false,
    "session": true,
    "storeId": "0",
    "value": "0"
  }]

module.exports = schema