class ScaleDataController < ApplicationController
  before_action :healthplanet, only: [:show]
  before_action :set_scale_datum, only: [:show, :update, :destroy]

  # GET /scale_data
  def index
    @scale_data = ScaleDatum.all

    render json: @scale_data
  end

  # GET /scale_data/1
  def show
    render json: @scale_datum
  end

  # POST /scale_data
  def create
    @scale_datum = ScaleDatum.new(scale_datum_params)

    if @scale_datum.save
      render json: @scale_datum, status: :created, location: @scale_datum
    else
      render json: @scale_datum.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /scale_data/1
  def update
    if @scale_datum.update(scale_datum_params)
      render json: @scale_datum
    else
      render json: @scale_datum.errors, status: :unprocessable_entity
    end
  end

  # DELETE /scale_data/1
  def destroy
    @scale_datum.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scale_datum
      @scale_datum = ScaleDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scale_datum_params
      params.require(:scale_datum).permit(:date, :keydata, :model, :tag)
    end

    def healthplanet
      require 'mechanize'
      require 'nokogiri'
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
      jsonoutput = ''

      File.open('.../healthTest.json','wb') do |f|
          url2 = "https://www.healthplanet.jp/status/innerscan.json?access_token=#{access_token}&date=#{date_type}&tag=#{tag}"
          page5 = agent.post(url2)

          temp = JSON.parse(page5.body)

          hashoutput = temp["data"]

          jsonoutput = JSON.pretty_generate(hashoutput)

          jsonoutput.lstrip!

          JSON.dump(jsonoutput,f)
      end

      for var in hashoutput do
        ScaleDatum.create!(date: hashoutput[var]["date"], keydata: hashoutput[var]["keydata"], model: hashoutput[var]["model"], tag: hashoutput[var]["tag"])
      end

    end
end
