app = require '../krake_publishing_server'
NetworkPublisher = require '../networking/network_publisher'

describe "KrakePublishingServer", ->
  beforeEach ->
    @publisher = new NetworkPublisher()
    app.listen 9806

  afterEach ->
    app.close()

  it "should publish record successfully to Postgres HSTORE database", (done)->

    # Test case 6: Test data from meetup.com
    data_object =
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


    schema = require './fixtures/json/schema'
    @publisher.publish schema, data_object, (message, type)=>
      response = {}
      response.message = message
      response.type = type
      done()