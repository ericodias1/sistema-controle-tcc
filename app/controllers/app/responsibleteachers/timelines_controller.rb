class App::Responsibleteachers::TimelinesController < App::Responsibleteachers::BaseController
  layout '/app/responsibleteachers'

  def home
    redirect_to responsible_teacher_timelines_path
  end

  def create
    base_timeline = BaseTimeline.find_by year: params[:year], half: params[:half], tcc: params[:tcc]
    student = Student.find params[:timeline][:student]
    teachers = Array.new
    params[:timeline][:teachers].each do |teacher_id|
      teachers.push Teacher.find(teacher_id) if Teacher.exists?(teacher_id)
    end
    @timeline = Timeline.new(base_timeline: base_timeline, student: student, teachers: teachers, title: params[:timeline][:title])
    if @timeline.save
      @timeline.create_items
      flash[:success] = t('controllers.save')
      render :partial => 'success.js.erb'
    else
      render :partial => 'new.js.erb'
    end
  end

  def update
    @timeline = Timeline.find(params[:id])
    teachers = Array.new
    params[:timeline][:teachers].each do |teacher_id|
      teachers.push Teacher.find(teacher_id) if Teacher.exists?(teacher_id)
    end
    if @timeline.update teachers: teachers, title: params[:timeline][:title]
      flash[:success] = t('controllers.save')
      render :partial => 'success.js.erb'
    else
      render :partial => 'new.js.erb'
    end
  end

  def new
    @timeline = Timeline.new
    render :partial => 'new.js.erb'
  end

  def edit
    @timeline = Timeline.find(params[:id])
    render :partial => 'edit.js.erb'
  end

  def index
    half = Date.today.strftime("%m").to_i < 6 ? 1 : 2
    redirect_to "/responsavel/timelines/#{Time.now.year.to_s}/#{half.to_s}/1"
  end

  def show
    timeline = Timeline.find(params[:id])
    @_calendar = timeline.base_timeline
    items = @_calendar.item_base_timeline

    @items = Array.new
    timeline.item_timelines.each do |item_timeline|
      _item = item_timeline.item_base_timeline.attributes
      _item['status'] = !item_timeline.status_item.nil? ? item_timeline.status_item.name.downcase : 'none'
      @items.push(_item)
    end

    @calendar = @_calendar.attributes
    @json = @_calendar.json
    @calendar.delete("json")
    @timeline_id = params[:id]
    
    # render :partial => 'show.js.erb'
  end

  def list
    @timelines = Timeline.joins(:base_timeline).where(base_timelines: {year: params[:year], half: params[:half], tcc: params[:tcc]})
  end

  def destroy
    Timeline.find(params[:id]).destroy
    redirect_to '/responsavel/timelines'
  end
end
