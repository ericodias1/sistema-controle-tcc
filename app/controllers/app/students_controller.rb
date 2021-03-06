class App::StudentsController < ApplicationController
  before_filter :set_student
  before_filter :check_permission

  def timelines
  end

  def orientations
    ids = @student.timeline.ids
    @orientations = Orientation.where(timeline_id: ids).order(date: :desc)
  end

  def item
    @timeline = Timeline.find(params[:timeline_id])
    @item_base = ItemBaseTimeline.find(params[:id])
    if(DateTime.now.to_date > @item_base.date)
      flash[:warning] = t('controllers.expired_delivery_date')
      redirect_to student_path
    end
    @item_timeline = @timeline.item_timelines.find_by(item_base_timeline_id: @item_base.id)
  end

  def delivery
    @item_timeline = ItemTimeline.find(params[:id])
    @item_timeline.file = params[:item][:file]
    @item_timeline.dropbox_file = params[:item][:dropbox_file]
    @item_timeline.status_item = StatusItem.find_by(name: "Pendente")

    if @item_timeline.save
      flash[:success] = t('controllers.save')
      redirect_to student_path
    else
      flash[:danger] = 'Ops, algum erro ocorreu. Verifique a extensão do arquivo, são aceitas extensões .jpg e .pdf.'
      redirect_to student_delivery_item_get_path(@item_timeline.timeline_id, @item_timeline.item_base_timeline.id)
    end
  end

  def show_timeline
    timeline = Timeline.find(params[:id])
    @timeline = Hash.new
    calendar = timeline.base_timeline
    @timeline[:items] = Array.new
    timeline.item_timelines.each do |item_timeline|
      _item = item_timeline.item_base_timeline.attributes
      _item['status'] = !item_timeline.status_item.nil? ? item_timeline.status_item.name.downcase : 'none'
      @timeline[:items].push(_item)
    end
    @timeline[:calendar] = calendar.attributes
    @timeline[:json] = calendar.json
    @timeline[:calendar].delete('json')
    @timeline[:id] = timeline.id
    render layout: false
  end

  def show_orientation
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @orientation = Orientation.find(params[:id])
  end

  def accept_orientation
    @orientation = Orientation.find(params[:id])
    @orientation.update accept: true
    redirect_to student_orientacoes_path, flash: {success: "Operação realizada com sucesso."}
  end

  private
  def check_permission
    if !(can? :manage, :student)
      redirect_to get_redirect_path, :flash => { :danger => t('controllers.login.forbidden') }
    end
  end

  def set_student
    @student = current_user
  end
end
