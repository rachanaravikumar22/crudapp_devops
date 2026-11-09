
class TasksController < ApplicationController
  def index
    @tasks = Task.order(created_at: :desc)
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to root_path, notice: "Task created successfully."
    else
      @tasks = Task.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to root_path, notice: "Task updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to root_path, notice: "Task deleted successfully."
  end

  def search
    query = params[:q].to_s.strip
    @tasks = Task.where("title LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
                 .order(created_at: :desc)
    render :index
  end

  def unlock_history
    session[:history_unlocked] = true
    redirect_to root_path, notice: "Task history unlocked."
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
