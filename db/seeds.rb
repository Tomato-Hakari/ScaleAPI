# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'mechanize'
require 'json'

client_id = '2372.eJBi93F9fc.apps.healthplanet.jp'
client_secret = '1626310603695-oXQuPUBFeAnOLnxArpxnkp3KID427EzcMyT4KE5C'
user_id = 'Teraken_Shuryo'
user_pass = 'Hakari'
redirect_uri = 'https://www.healthplanet.jp/success.html'

agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'
url = "https://www.healthplanet.jp/oauth/auth?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=innerscan&response_type=code"

page = agent.get(url)
login_form = page.forms_with(:name => 'login.LoginForm').first
login_form.fields_with(:name => 'loginId').first.value = user_id
login_form.fields_with(:name => 'passwd').first.value = user_pass
page2 = login_form.click_button

login_form2 = page2.forms_with(:name => 'common.SiteInfoBaseForm').first
login_form2.fields_with(:name => 'approval').first.value = 'true'
page3 = login_form2.click_button

auth_code = page3.uri.query[5,page3.uri.query.length-5]

page4 = agent.post('https://www.healthplanet.jp/oauth/token', {
    "client_id" => client_id,
    "client_secret" => client_secret,
    "redirect_uri" => redirect_uri,
    "code" => auth_code,
    "grant_type" => "authorization_code"
})

access_array = JSON.parse(page4.body)

access_token = access_array["access_token"]
date_type = 0
tag = 6021
tag_params = 6
hashoutput = []

url2 = "https://www.healthplanet.jp/status/innerscan.json?access_token=#{access_token}&date=#{date_type}&tag=#{tag}"
page5 = agent.post(url2)

hashoutput = JSON.parse(page5.body)

hashoutput["data"].each do |var|
    scaledata = ScaleDatum.find_or_create_by(date: var["date"])
    scaledata.update(date: var["date"], keydata: var["keydata"], model: var["model"], tag: var["tag"])
end

