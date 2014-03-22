kson = require 'kson'
request = require 'request'
RdbHandler = require('krake-toolkit').data.rdb_handler
PgHandler = require('krake-toolkit').data.pg_handler
MongoHandler = require('krake-toolkit').data.mongo_schema_factory

rbd_handlers = {}
mongo_handlers = {}
pg_handlers = {}

class NetworkPublisher
  
  # @Description: Default constructor
  #   Automatically creates and maintains a link to Mongo or RBD if exist
  # @param: options:Object
  constructor: ()->
    
  # @Description: Publishes a data object to the destination URL
  # @params: options:Object
  # @params: data_object:Object
  # @params: callback:Function(message:string, message_type:string)
  publish: (options, data_object, callback)->
    
    # Writes record into MySql
    if options && options.rdbParams
      rdbParams = options.rdbParams
      rdbParams.origin_url = options.origin_url      
      rdbParams.columns = options.rawSchema?.columns || options.columns || []
      rdbParams.data = options.rawSchema?.data || options.data || []
      
      # ensures only one handler is created for each database
      rdb_key = rdbParams.host + '_' + rdbParams.database + '_' + rdbParams.tableName
      if !rbd_handlers[rdb_key] 
        rbd_handlers[rdb_key] = new RdbHandler rdbParams

      rbd_handlers[rdb_key].publish data_object
      callback && callback 'Publisher : Published ' + kson.stringify(data_object) + ' to MySql', 'information'
    
    # Writes record into Postgresql HStore
    if options && options.pgParams
      console.log '[NETWORK_PUBLISHER] Publishing to PostGresql'
      pgParams = options.pgParams
      pgParams.origin_url = options.origin_url
      pgParams.columns = options.rawSchema?.columns || options.columns
      pgParams.permuted_columns = options.rawSchema?.permuted_columns || options.permuted_columns
      pgParams.data = options.rawSchema?.data || options.data || []

      # ensures only one handler is created for each database
      pg_key = pgParams.host + '_' + pgParams.database + '_' + pgParams.tableName
      if !pg_handlers[pg_key] 
        pg_handlers[pg_key] = new PgHandler pgParams
      pg_handlers[pg_key].publish data_object
      callback && callback 'Publisher : Published ' + kson.stringify(data_object) + ' to Data Server', 'information'

    # Writes record into MongoDb  
    if options && options.mongoParams
      mongoParams = options.mongoParams
      mongoParams.origin_url = options.origin_url
      mongoParams.columns = options.rawSchema?.columns || options.columns || []
      mongoParams.data = options.rawSchema?.data || options.data
      
      # ensures only one handler is created for each database
      mongo_key = mongoParams.host + '_' + mongoParams.database + '_' + mongoParams.collection
      !mongo_handlers[mongo_key] && mongo_handlers[mongo_key] = mongo_handler = new MongoHandler options.mongoParams

      mongo_handlers[mongo_key].publish data_object
      callback && callback 'Publisher : Published ' + kson.stringify(data_object) + ' to MongoDB Data Server', 'information'
      
    # Writes the JSON result to a remote URL via HTTP Post
    if options && options.destination_url
      params =
        method : 'POST'
        json : data_object
        uri : options.destination_url
  
      request.post params, (error, response, body)=>
        if !error && response.statusCode = 200
          callback && callback 'Publisher : Published ' + kson.stringify(data_object) + ' to ' + 
            options.destination_url, 'information'

module.exports = NetworkPublisher

if !module.parent

  # Test case 1: Test data from deal.com.sg      
  data_object = 
    tags: 'bcu'
    tags_url: 'https://scraperwiki.com/tags/bcu'
    person_name: 'Andrew'
    description: 'tutorial'
    language: 'python'
    privacy: 'Public'
    project_name: 'BCU weather tutorial'
    project_detail_url: 'https://scraperwiki.com/scrapers/bcu-weather-tutorial/'
    data_source: 'news.bbc.co.uk'
    run_interval: 'Runs every day'

  # Test case 2: Test data from deal.com.sg    
  data_object2 =
    site_id: 61
    city_id: 1
    parent_cat_id: 45
    cat_id: 7
    status: 'Active'
    encrypt_view: 1
    deal_order: 0
    link: 'http://www.deal.com.sg/deals/singapore/Japanese-Silky-Rebonding-OR-Korean-Magic-Perm-Wash-Blow-Dry-at-City-Cut-Hair-Studio-Yishun-AMK-2'
    link_url: 'http://www.deal.com.sg/deals/singapore/Japanese-Silky-Rebonding-OR-Korean-Magic-Perm-Wash-Blow-Dry-at-City-Cut-Hair-Studio-Yishun-AMK-2'
    title: 'Last Day! Up to 81% off Japanese Silky Rebonding OR Korean Magic Perm + Wash + Blow Dry at City Cut Hair Studio (Yishun / AMK) – Options Available for Hair Colouring, Scalp Treatment & Frizzy Hair Treatment for All Hair Lengths'
    description: 'Highlights\n        \n\n\t\tUp to 81% off Japanese Silky Rebonding OR Korean Magic Perm + Wash + Blow Dry at City Cut Hair Studio\n\n\t\t4 Price Options Available:\n\n\n\t\t\t\tJapanese Silky Rebonding OR Korean Magic Perm + Wash + Blow Dry – Only $29.90 instead of $138\n\n\t\t\t\tJapanese Silky Rebonding OR Korean Magic Perm + Hair Colouring OR Highlights + Wash + Blow Dry – Only $68 instead of $350\n\n\t\t\t\tJapanese Silky Rebonding OR Korean Magic Perm + Hair Colouring OR Highlights + Wash + Blow Dry + Scalp Treatment – Only $88 instead of $450\n\n\t\t\t\tJapanese Silky Rebonding OR Korean Magic Perm + Hair Colouring OR Highlights + Wash + Blow Dry + Scalp Treatment + Frizzy Hair Treatment – Only $138 instead of $580\n\n\n\n\t\tThis package includes:\n\n\n\t\t\t\tJapanese Silky Rebonding OR Korean Magic Perm\n\n\t\t\t\tWash\n\n\t\t\t\tBlow Dry\n\n\n\n\t\tObtain smooth, manageable tresses\n\n\t\tOpt for hair colour or highlights to spice up your hair colour\n\n\t\tRepair your damaged hair quality Italy-imported Scalp treatment which aids in preventing hair-loss, itchy scalp and dandruff\n\nAdditional Details:\n\n\n\t\tMultiple vouchers may be purchased as gifts'
    price: '$29.90'
    value: '$138.00'
    saving: '$108.10'
    imageurl: 'http://static.deal.com.sg/sites/default/files/City-Cut-Hair_2_0.jpg'
    address: 'Partner\n        City Cut Hair Studio\n \nAng Mo Kio Branch:\n\tBlk 453\n\tAng Mo Kio Ave 10\n\t#01-1805\n\tSingapore 560453\n\tTel: 6455 2381\n \nYishun Branch:\n\tBlk 103\n\tYishun Ring Road\n\t#01-113\n\tSingapore 760103\n\tTel: 6556 0350\n \nOperating Hours:\n\t10am to 8pm (Mon – Fri)\n\t10am to 9pm (Sat, Sun & PH)'
    gmap_url: 'http://maps.google.com/maps?ll=1.400087,103.842174&spn=0.094386,0.104713&z=12&key=ABQIAAAAig200QJUN3ohC-PqwvWELhQLxRmnd__z_HmnnvdrgSc7uOVPHBQrNvZAUgqnNmZI15YG9x2rfegr-w+&mapclient=jsapi&oi=map_misc&ct=api_logo'
    merchant_name: 'City Cut Hair Studio'
    conditions: 'Conditions\n        \n\n\t\tVoucher is valid from 8 Feb 2013 to 8 May 2013\n\n\t\tBlackout period: 9 Feb 2013 to 11 Feb 2013\n\n\t\tValid for men & women of all ages\n\n\t\tValid for new & existing customers whom have not visited for the past 12 months\n\n\t\tValid for Singaporeans, PRs, EP, DP, SP only\n\n\t\tOffer is valid for all hair lengths\n\n\t\tAll treatments (rebonding or perm, hair colouring or highlights and scalp treatment) must be completed within first visit; no splitting of treatments is allowed\n\n\t\tAdditional stylish haircut is available at an additional $5; payable to merchant direct\n\n\t\tPlease click HERE for Universal Terms & Conditions\n\nRedemption Details:\n\n\n\t\tStrictly by appointment only and is subject to availability\n\n\t\t3 days advance notice is required for booking, cancellation and postponement\n\n\t\tPlease call your preferred outlets and quote “DEAL.com.sg” (please refer to Partner details)\n\n\t\tPrinted DEAL voucher and Original NRIC must be presented upon redemption'
    address_lat: 1.431573
    address_lng: 103.8288718
    address_country: 'Singapore'
    address_zip: '760103'
  
  # Test case 3: Test data from deal.com.sg
  data_object3 =
    site_id: 61,
    city_id: 1,
    parent_cat_id: 45,
    cat_id: 7,
    status: 'Active',
    encrypt_view: 0,
    deal_order: 0,
    link: 'http://www.deal.com.sg/deals/singapore/Popular-AIBI-Slendertone-Flex-For-Women---Men',
    link_url: 'http://www.deal.com.sg/deals/singapore/Popular-AIBI-Slendertone-Flex-For-Women---Men',
    title: 'Last Day! 35% off Popular AIBI Slendertone Flex For Women & Men – Get Firmer, Flatter Abs in Just 8 Weeks',
    description: 'Highlights\n        \n\n\t\tAIBI Slendertone Flex For Women & Men\n\n\t\tOnly $193.70 instead of $298\n\n\t\tLook great on the beach this Summer - Get Firmer, Flatter Abs in Just 8 Weeks & Achieve Those 6-Pec Abs Many Times FASTER\n\n\t\tCollection available at all AIBI Retail Outlets!\n\n\t\tThe Women’s Slendertone Flex features:\n\n\n\t\t\t\tTargeted abdominal muscle toning with 7 different programmes\n\n\t\t\t\tIntensity levels ranging from 0-99, where you can select your own customized workout training your abdominal muscles in your own way\n\n\t\t\t\tAn intelligent training system allowing you to auto progress through the programmes\n\n\t\t\t\tBelt size adjustable to a maximum waistline of 44-inch\n\n\n\n\t\tThe Men’s Slendertone Flex features:\n\n\n\t\t\t\tTargeted abdominal muscle toning with 7 different programmes\n\n\t\t\t\tIntensity levels ranging from 0-99, where you can select your own customized workout training your abdominal muscles in your own way\n\n\t\t\t\tAn intelligent training system allowing you to auto progress through the programmes\n\n\t\t\t\tBelt size adjustable to a maximum waistline of 47-inch\n\n\n\n\t\tThe Box Includes:\n\n\n\t\t\t\tSlendertone Flex unit and garment (either Blue for Male or Beige for Female)\n\n\t\t\t\t1 Set of Ab-pads\n\n\t\t\t\t3x AAA batteries\n\n\t\t\t\tEasy-to-use Guide Instruction Manual\n\n\t\t\t\tQuickstart guide\n\n\n\n\t\tIndependent clinical trials have shown that 100% of users report firmer and more toned abs. *Clinical trail conducted by Prof. Dr. Jon Porcari, University Wisconsin, La-Crosse\n\n\t\tUses advanced EMS technology that has been used for over 40 years in hospitals, clinics & physiotherapy practices around the world to strengthen & rehabilitate muscles\n\n\t\tOriginal products from AIBI comes with 2-year warranty\n\nAdditional Details:\n\n\n\t\tMultiple purchase of vouchers as gifts allowed\n\n\t\tRedemption of multiple vouchers per person allowed',
    price: '$193.70',
    value: '$298.00',
    saving: '$104.30',
    imageurl: 'http://static.deal.com.sg/sites/default/files/slender%20tone%20flex%201_1.jpg',
    large_width: 504,
    large_height: 252,
    address: 'Partner\n        AIBI Singapore Showrooms (11am to 10pm daily, including Public Holidays)\n \nTel: 6376 9717 / 6899 1190\n \nCauseway Point #B1-35 (Near Cold Storage)\n\tChangi City Point #B1-16\n\tIMM Building #02-13 (Near Best Denki/Kopitiam)\n\tJurong Point #B1-15/16\n\tNex @ Serangoon #03-25 (near Isetan)\n\tParkway Parade #B1-106/107/108\n\tPlaza Singapura #03-05/06\n\tSuntec City #02-091/093 (Between Tower 2 and Tower 3)\n\tVivoCity #02-160/161\n \nWebsite: www.aibifitness.com\n\tFacebook: http://www.facebook.com/AibiFitness',
    gmap_url: 'http://maps.google.com/maps?ll=1.350444,103.83586&spn=0.377549,0.418854&z=10&key=ABQIAAAAig200QJUN3ohC-PqwvWELhQLxRmnd__z_HmnnvdrgSc7uOVPHBQrNvZAUgqnNmZI15YG9x2rfegr-w+&mapclient=jsapi&oi=map_misc&ct=api_logo',
    merchant_name: 'AIBI Singapore Showrooms',
    merchant_url: 'http://www.aibifitness.com/',
    conditions: 'Conditions\n        \n\n\t\tRedemption Period: 8 Feb 2013 to 8 Mar 2013\n\n\t\tBlackout Period: 10 Feb 2013 & 11 Feb 2013\n\n\t\tIncludes 2-year warranty\n\n\t\tDEAL customers are advised to first call the outlet\'s hotline to check for stock availability or request for item to be transferred to preferred outlet\n\n\t\tShould stocks be unavailable at a particular outlet, customer may request for item to be transferred from another outlet that is to be collected on another day\n\n\t\tAllow 2 weeks of waiting / delivery time should stocks be out island-wide; AIBI’s customer service personnel will contact you to inform you once the item is in\n\n\t\tProducts comes with instruction manual and the AIBI staffs will be pleased to provide demonstration of the product\n\n\t\tVoucher is transferrable\n\n\t\tPlease click HERE for Universal Terms & Conditions\n\nRedemption Details:\n\n\n\t\tRedemption via self-collection; please refer to Partner Details for location details\n\n\t\tRedemption Hours: 11am to 10pm, 11am to 4pm (9 Feb 2013)\n\n\t\tPrinted DEAL voucher must be presented upon redemption'    

  # Test case 4: Test data from groupon.sg
  data_object4 = 
    site_id: 61
    city_id: 1
    parent_cat_id: 45
    cat_id: 7
    status: 'Active'
    encrypt_view: 0
    deal_order: 0
    link: 'http://www.groupon.sg/deals/singapore/Fresh-De-Beau/716729215?CID=SG_RSS_217_389_189_22&utm_source=rss_217&utm_medium=rss_389&utm_campaign=rss_189&utm_content=rss_22'
    deal_url: 'http://www.groupon.sg/deals/singapore/Fresh-De-Beau/716729215?CID=SG_RSS_217_389_189_22&utm_source=rss_217&utm_medium=rss_389&utm_campaign=rss_189&utm_content=rss_22'
    title: '$18 for Anti-Cellulite Leg Treatment at Fresh De Beau (Worth $400). Three Session Option Available.'
    description: 'Highlights\n                     \nPremium-quality Histomer Botanical stem-cell products from UK\nHelps to slim and shape for beautiful legs\nWater retention and appearance of bumpy cellulite is reduced\nSea salt scrub gently cleanses and exfoliates to reveal fresh, smooth skin\nLuxurious massage helps improve circulation\nInfrared thermal blanket removes toxins and excess water for improved weight loss\nFriendly, personalised service\nExperienced, professional aestheticians\nCentral location near Raffles Place MRT\nLimited Groupons available'
    price: 'S$18.00'
    saving: 'S$382.00'
    saving_percent: '96%'
    imageurl: 'http://static.sg.groupon-content.net/60/18/1360510531860.jpg'
    large_width: 450
    large_height: 300
    address: 'Fresh De Beau\n    3 Pickering Street, 01-09 Nankin Row, China Square Central (Tel: 6227 8544)\n    Singapore 048660\n    View our Partner\'s website here'
    gmap_url: 'http://mapproxy.groupon.com/maps/api/staticmap?center=1.2848894,103.84768209999993&zoom=14&size=189x172&maptype=roadmap&markers=color:orange%7C1.2848894,103.84768209999993&sensor=false&channel=www.groupon.sg-local-showDeal-merchantDetails'
    merchant_name: 'Fresh De Beau'
    merchant_url: 'http://www.freshdebeau.com.sg/'
    conditions: 'Fine Print\n                    Choose between 2 options (select at payment page):\n\nOne Session 60 min Anti-Cellulite Leg Treatment\nThree Sessions 60 min Anti-Cellulite Leg Treatment\n\nEach session includes:\n\nSea Salt Scrub\nMassage\nInfrared Thermal Blanket\n\n\nValid from 19 Feb to 18 Aug 2013. Limit 1 Groupon per person, may buy multiple as gifts. Valid for first time female customers, 21 years and above only. Valid for Singaporeans, PRs and EP holders. Closed on PH. Appointment required, call 6227 8544.Groupon printout MUST be presented.See the rules that apply to all deals.'
    address_lat: 1.2843885
    address_lng: 103.8477122
    address_country: 'Singapore'
    address_zip: '048660'

  # Test case 5: Test data from meetup.com
  data_object5 =
    group_url: 'http://www.meetup.com/Asias-Smart-Loving-People/'
    member_url: 'http://www.meetup.com/Asias-Smart-Loving-People/members/'
    developer_profile_url: 'http://www.meetup.com/Asias-Smart-Loving-People/members/37573702/'
    developer_name: 'Ron Leong'
    facebook_url: 'http://www.facebook.com/ronleong05'
    linked_url: 'http://www.linkedin.com/in/ronleong'
    location: 'Singapore'
    profile_intro_1: 'Networks'
    profile_intro_2: 'Introduction\n\nAn evolving entrepreneur'
    profile_intro_3: 'Your email address some@mail.com'    
    linkedin_recent_job_title: 'General Manager'
    linkedin_recent_company_name: 'Single Minded Machining'
    linkedin_recent_company_url: 'http://www.linkedin.com/company/flextronics?trk=ppro_cprof'
    linkedin_recent_company_description: 'Flextronics is a place where you come to move mountains and accomplish the impossible. This is how we bring power to everything we do. What you’ll find here is a deeply collaborative, play-to-win culture and opportunities to flourish that you simply won’t find anywhere else.   For more ...more'

  # Test case 6: Test data from meetup.com
  data_object6 =
    group_url: 'http://www.meetup.com/SingaporeMobileDevelopers/'
    region: 'Singapore'
    locality: 'Singapore'
    group_name: 'Singapore Mobile Developers Meetup'
    members_listing_url: 'http://www.meetup.com/SingaporeMobileDevelopers/members/'
    developer_profile_url: 'http://www.meetup.com/SingaporeMobileDevelopers/members/77169482/'
    developer_name: 'Anna Pikina'
    facebook_url: 'http://www.facebook.com/anna.pikina'
    linked_url: 'http://www.linkedin.com/in/annapikina'
    location: 'Singapore'
    profile_intro_1: 'Networks'
    profile_intro_2: 'Introduction\n\nHello, I am Sales Director - APAC for Airpush - second largest android network, operating on Push notifications technology and in-app formats. Passionate about mobile, been in the industry for 7 years.'
    profile_intro_3: 'Why do you like mobile applications?\n\n they allow you to do everything on the go, and are quite entertaining for couch potatos'
    linkedin_recent_job_title: 'Sales Director'
    linkedin_recent_company_name: 'Airpush, Inc.'
    linkedin_recent_company_url: 'http://www.linkedin.com/company/airpush-inc.?trk=ppro_cprof'
    linkedin_recent_company_description: 'Named "Best Mobile Ad Network" at the 2012 Mobile Excellence Awards, Airpush is on a mission to redefine mobile advertising for publishers and advertisers. Over 50,000 apps and 2,000 advertisers rely on Airpush to deliver the industry\'s highest performance, driven by exceptional ad formats and ...more'
  
  schema = {}
  schema.destination_url = 'http://test/post_body.php'
  schema.rdbParams = 
    database: 'test'
    tableName: 'publisher_test'
    username: 'explorya'
    password: 'Explore123!'
    host: 
      host: '127.0.0.1'
      port: 3306
      
  schema.mongoParams =
      host : 'localhost'
      database : 'test'
      collection : 'publisher_test'
  
  schema.columns = [{
    col_name : 'group_url'
    dom_query : '.simple-card a'
    required_attribute : 'href'
    options : 
      columns : [{
          col_name : 'group_name'
          dom_query : 'h1 a'
        },{            
          col_name : 'members_listing_url'
          dom_query : '.metaBox a[href*=members]'
          required_attribute : 'href'
          options : 
            columns: [{
                col_name : 'developer_profile_url'
                dom_query : 'a.memName'
                required_attribute : 'href'
                options :
                  columns: [{
                      col_name : 'developer_name'
                      dom_query : '.memName.fn'
                    },{
                      col_name : 'facebook_url'
                      dom_query : 'a.badge-facebook-24'
                      required_attribute : 'href'
                    },{
                      col_name : 'twitter_url'
                      dom_query : 'a.badge-twitter-24'
                      required_attribute : 'href'
                      options :
                        columns : [{
                            col_name : 'twitter_handle'
                            dom_query : '.username .screen-name'
                          },{
                            col_name : 'twitter_location'
                            dom_query : '.location'
                          },{
                            col_name : 'personal_url_twitter'
                            dom_query : '.location-and-url .url a'
                            required_attribute : 'href'
                          },{
                            col_name : 'twitter_followers'
                            dom_query : 'a[data-nav=followers][data-element-term=follower_stats]'
                          },{
                            col_name : 'twitter_tweets'
                            dom_query : 'a[data-nav=profile][data-element-term=tweet_stats]'
                          },{
                            col_name : 'twitter_following'
                            dom_query : 'a[data-nav=following][data-element-term=following_stats]'
                        }]
                    },{
                      col_name : 'flickr_url'
                      dom_query : 'a.badge-flickr-24'
                      required_attribute : 'href'
                    },{
                      col_name : 'linked_url'
                      dom_query : 'a.badge-linkedin-24'
                      required_attribute : 'href'
                      options :
                        columns : [{
                            col_name : 'linkedin_recent_job_title'
                            dom_query : '.postitle .title[[0]]'
                          },{
                            col_name : 'linkedin_recent_company_name'                            
                            dom_query : '.postitle h4 span[[0]]'
                          },{
                            col_name : 'linkedin_recent_company_url'
                            dom_query : '.postitle h4 a[[0]]'
                            required_attribute : 'href'
                            options : 
                              columns : [{
                                col_name : 'linkedin_recent_company_description'
                                dom_query : '.text-logo[[0]]'                  
                              }]
                        }]
                    },{
                      col_name : 'tumblr_url'
                      dom_query : 'a.badge-tumblr-24'
                      required_attribute : 'href'
                    },{
                      col_name : 'location'
                      dom_query : '.locality[itemprop=addressLocality]'
                    },{
                      col_name : 'profile_intro_1'
                      dom_query : '.D_memberProfileContentItem[[3]]'
                    },{
                      col_name : 'profile_intro_2'
                      dom_query : '.D_memberProfileContentItem[[4]]'
                    },{
                      col_name : 'profile_intro_3'
                      dom_query : '.D_memberProfileContentItem[[5]]'                                            
                  }]                
            }]
            next_page :
              dom_query : 'li.pager_link + li.relative_page a'            
      }]
  }]
  
  schema.rawSchema = 
    columns : [{
        col_name : 'group_url'
        dom_query : '.simple-card a'
        required_attribute : 'href'
        options : 
          columns : [{
              col_name : 'group_name'
              dom_query : 'h1 a'
            },{            
              col_name : 'members_listing_url'
              dom_query : '.metaBox a[href*=members]'
              required_attribute : 'href'
              options : 
                columns: [{
                    col_name : 'developer_profile_url'
                    dom_query : 'a.memName'
                    required_attribute : 'href'
                    options :
                      columns: [{
                          col_name : 'developer_name'
                          dom_query : '.memName.fn'
                        },{
                          col_name : 'facebook_url'
                          dom_query : 'a.badge-facebook-24'
                          required_attribute : 'href'
                        },{
                          col_name : 'twitter_url'
                          dom_query : 'a.badge-twitter-24'
                          required_attribute : 'href'
                          options :
                            columns : [{
                                col_name : 'twitter_handle'
                                dom_query : '.username .screen-name'
                              },{
                                col_name : 'twitter_location'
                                dom_query : '.location'
                              },{
                                col_name : 'personal_url_twitter'
                                dom_query : '.location-and-url .url a'
                                required_attribute : 'href'
                              },{
                                col_name : 'twitter_followers'
                                dom_query : 'a[data-nav=followers][data-element-term=follower_stats]'
                              },{
                                col_name : 'twitter_tweets'
                                dom_query : 'a[data-nav=profile][data-element-term=tweet_stats]'
                              },{
                                col_name : 'twitter_following'
                                dom_query : 'a[data-nav=following][data-element-term=following_stats]'
                            }]
                        },{
                          col_name : 'flickr_url'
                          dom_query : 'a.badge-flickr-24'
                          required_attribute : 'href'
                        },{
                          col_name : 'linked_url'
                          dom_query : 'a.badge-linkedin-24'
                          required_attribute : 'href'
                          options :
                            columns : [{
                                col_name : 'linkedin_recent_job_title'
                                dom_query : '.postitle .title[[0]]'
                              },{
                                col_name : 'linkedin_recent_company_name'                            
                                dom_query : '.postitle h4 span[[0]]'
                              },{
                                col_name : 'linkedin_recent_company_url'
                                dom_query : '.postitle h4 a[[0]]'
                                required_attribute : 'href'
                                options : 
                                  columns : [{
                                    col_name : 'linkedin_recent_company_description'
                                    dom_query : '.text-logo[[0]]'                  
                                  }]
                            }]
                        },{
                          col_name : 'tumblr_url'
                          dom_query : 'a.badge-tumblr-24'
                          required_attribute : 'href'
                        },{
                          col_name : 'location'
                          dom_query : '.locality[itemprop=addressLocality]'
                        },{
                          col_name : 'profile_intro_1'
                          dom_query : '.D_memberProfileContentItem[[3]]'
                        },{
                          col_name : 'profile_intro_2'
                          dom_query : '.D_memberProfileContentItem[[4]]'
                        },{
                          col_name : 'profile_intro_3'
                          dom_query : '.D_memberProfileContentItem[[5]]'                                            
                      }]                
                }]
                next_page :
                  dom_query : 'li.pager_link + li.relative_page a'            
          }]
    }]
    data : 
      region: 'Funky country'
    
  console.log data_object6
  np = new NetworkPublisher()
  np.publish schema, data_object6
