class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  require 'icalendar'

  # GET /todos or /todos.json
  def index
    if (current_user!= nil) 
      if params[:query] != nil 
        @todos = current_user.todos.where("name LIKE ? OR description LIKE ?", "%" + params[:query] + "%", "%" + params[:query] + "%")
      elsif params[:tag] != nil
        @todos = current_user.todos.where(tag: params[:tag])
      elsif params[:start_date] != nil && params[:end_date] != nil
        @todos = current_user.todos.where(due: (params[:start_date]..params[:end_date]))
      elsif params[:order] != nil
        order = params[:order].upcase
        @todos = current_user.todos.order('due ' + order)
      else
        @todos = current_user.todos.where(done: nil)
      end
      @tags = current_user.todos.distinct.pluck(:tag)
      @completed_todos = current_user.todos.where(done: true)
      @users = User.where(" name <> ? ",current_user.name)
    else
       redirect_to login_path
    end
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
    if params[:done] != nil 
      todo = Todo.find_by_id(params[:id])
      todo.done = true;
      todo.save
      redirect_back(fallback_location: root_path)
    elsif params[:give_to] != nil 
      user = User.find_by(name: params[:give_to])
      post = Todo.find_by_id(params[:id])
      post.user = user
      post.save
      redirect_back(fallback_location: root_path)
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def calendar
    todo = Todo.find_by_id(params[:id])
    filename = todo.name

    cal = gen_calendar(todo)

    if params[:type] == 'vcs'
      cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
      cal.version = '1.0'
      filename += '.vcs'
    else # ical
      cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
      cal.version = '2.0'
      filename += '.ics'
    end
    
    send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename
    
  end

  def search
    @todos = Todo.first
    respond_to do |format|
      format.html { redirect_to todos_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:name, :description, :due, :tag)
    end

    def gen_calendar(todo)
      cal = Icalendar::Calendar.new
      cal.event do |e|
        e.dtstart     = Icalendar::Values::Date.new(todo.due)
        e.dtend       = Icalendar::Values::Date.new(todo.due + 1.hour)
        e.summary     = todo.name
        e.description = todo.description
        e.ip_class    = "PRIVATE"
      end
      cal
    end

    def redirect_to_default
      redirect_to root_path
    end
end
