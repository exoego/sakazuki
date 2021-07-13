# rubocop:disable Metrics/ClassLength
class SakesController < ApplicationController
  before_action :set_sake, only: %i[show edit update destroy]
  before_action :strip_todofuken_from_params!, only: %i[update]
  before_action :signed_in_user, only: %i[new create edit update destroy]

  include SakesHelper

  # GET /sakes
  # GET /sakes.json
  # rubocop:disable Metrics/AbcSize
  def index
    # avoid nil
    params[:q] = {} unless params[:q]

    # default, not empty bottle
    params[:q].merge!({ bottle_level_not_eq: Sake.bottle_levels["empty"] }) unless params.dig(:q, :bottle_level_not_eq)

    # default, sort by id
    params[:q].merge!({ s: "id desc" }) unless params.dig(:q, :s)

    # search
    query = params[:q].deep_dup
    to_multi_search!(query) if query[:all_text_cont]
    @searched = Sake.ransack(query)
    @sakes = @searched.result(distinct: true).page(params[:page])
  end

  # rubocop:enable Metrics/AbcSize

  # GET /sakes/1
  # GET /sakes/1.json
  def show
    set_twitter_meta_tags
  end

  def show_photo
    @photo = Photo.find(params[:photo_id])
  end

  # GET /sakes/new
  def new
    @sake = Sake.new
    @sake.size = 720
  end

  # GET /sakes/1/edit
  def edit
    @sake.kura = add_todofuken(@sake.kura, @sake.todofuken)
    # 開けたボタン経由での処理
    @sake.bottle_level = params["sake"]["bottle_level"] if params.dig(:sake, :bottle_level)
  end

  # POST /sakes
  # POST /sakes.json
  def create
    @sake = Sake.new(sake_params)
    @sake.kura = strip_todofuken(@sake.kura)

    respond_to do |format|
      if @sake.save
        store_photos
        format.html {
          redirect_to(@sake)
          flash[:success] = t("controllers.sake.success.create", name: @sake.name)
        }
      else
        format.html { render(:new) }
      end
    end
  end

  # PATCH/PUT /sakes/1
  # PATCH/PUT /sakes/1.json
  def update
    respond_to do |format|
      if @sake.update(sake_params)
        delete_photos
        store_photos
        format.html {
          redirect_after_update
          flash[:success] = t("controllers.sake.success.update", name: alert_link_tag(@sake.name, sake_path(@sake)))
        }
      else
        format.html { render(:edit) }
      end
    end
  end

  # DELETE /sakes/1
  # DELETE /sakes/1.json
  def destroy
    deleted_name = @sake.name
    @sake.destroy
    respond_to do |format|
      format.html {
        redirect_to(sakes_url)
        flash[:success] = t("controllers.sake.success.destroy", name: deleted_name)
      }
    end
  end

  private

  def to_multi_search!(query)
    words = query.delete(:all_text_cont)
    query[:groupings] = separate_words(words)
  end

  def separate_words(words)
    # 全角空白または半角空白で区切ることを許可
    # { :name_cont => "" }があり得るがransackがSQL変換で削除するのでOK
    words.split(/[ 　]/).map { |word| { all_text_cont: word } }
  end

  # DBに保存された蔵名に括弧つきで県名をつけて、_formの描画でつかうフォーマットにする
  #
  # @example 蔵名がある場合
  #   add_todofuken("原田酒造合資会社", "愛知県") #=> "原田酒造合資会社（愛知県）"
  # @example 蔵名がない場合
  #   add_todofuken("", "") #=> ""
  def add_todofuken(kura, todofuken)
    if kura == "" && todofuken == ""
      ""
    else
      "#{kura}（#{todofuken}）"
    end
  end

  # _formでオートコンプリートされたフォーマットから県名を取り除き、DBへ保存するフォーマットにする
  #   strip_todofuken("原田酒造合資会社（愛知県）")  #=> "原田酒造合資会社"
  def strip_todofuken(kura)
    kura.nil? ? kura : kura.gsub(/（.*）/, "")
  end

  # paramsの件名つき蔵名から県名を取り除く
  def strip_todofuken_from_params!
    params["sake"]["kura"] = strip_todofuken(params["sake"]["kura"]) if params.dig(:sake, :kura)
  end

  def set_twitter_meta_tags
    set_meta_tags(og: { title: "SAKAZUKI - #{@sake.name}" })
    set_meta_tags(og: { image: @sake.photos.first.image.thumb.url }) if @sake.photos.any?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sake
    @sake = Sake.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sake_params
    params.require(:sake)
          .permit(:name, :kura, :photo, :bindume_date, :brew_year,
                  :todofuken, :taste_value, :aroma_value,
                  :nihonshudo, :sando, :aroma_impression,
                  :color, :taste_impression, :nigori, :awa,
                  :tokutei_meisho, :genryomai, :kakemai,
                  :kobo, :alcohol, :aminosando, :season,
                  :warimizu, :moto, :seimai_buai, :roka,
                  :shibori, :note, :bottle_level, :hiire,
                  :size, :price)
  end

  def store_photos
    photos = params[:sake][:photos]
    photos&.each { |photo| @sake.photos.create(image: photo) }
  end

  def delete_photos
    @sake.photos.each do |photo|
      photo.destroy if params[photo.chackbox_name] == "delete"
    end
  end

  # update後のリダイレクト処理
  # 編集画面からupdateする場合: 詳細ページにリダイレクト
  # HTTP_REFERERが設定されていない場合: 詳細ページにリダイレクト
  # 上記のどちらにも当てはまらない場合: ユーザーが直前にいたページにリダイレクト
  def redirect_after_update
    if update_from_edit?
      redirect_to(@sake)
    else
      redirect_back(fallback_location: @sake)
    end
  end

  # @return [Boolean] 編集画面からUpdateが行われた
  def update_from_edit?
    request.referer && request.referer.match?("\/sakes\/[0-9]+\/edit")
  end
end

# rubocop:enable Metrics/ClassLength
