schema = {}
schema.pgParams = 
  database: 'scraped_data_repo_test'
  tableName: 'test_publishes'
  username: 'test'
  password: 'test'
  host: 
    host: '127.0.0.1'
    port: 5432

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

module.exports = schema